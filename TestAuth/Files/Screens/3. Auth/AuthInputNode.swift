//
//  AuthInputNode.swift
//  TestAuth
//
//  Created by Denis Bezrukov on 24.07.17.
//  Copyright © 2017 Denis Bezrukov. All rights reserved.
//

import AsyncDisplayKit
import RxSwift


final class AuthInputNode: ASDisplayNode, DisposeBagProvider {
  enum AuthInputType {
    case email
    case password
    
    var text: String {
      switch self {
      case .email:
        return "Почта"
      case .password:
        return "Пароль"
      }
    }
    
    var errorMessage: String {
      switch self {
      case .email:
        return "Некорректный формат почты"
      case .password:
        return "Минимум 6 символов, обязательно содержать строчную букву, заглавную, и цифру"
      }
    }
    
    func isValid(text: String) -> Bool {
      switch self {
      case .email:
        let regularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regularExpression)
        return predicate.evaluate(with: text)
      default:
        guard text.characters.count >= 6 else { return false }
        return [CharacterSet.decimalDigits, .lowercaseLetters, .uppercaseLetters]
          .map({ (text as NSString).rangeOfCharacter(from: $0).location })
          .filter({ $0 != NSNotFound })
          .count == 3
      }
    }
  }
  
  enum State {
    case initial
    case valid
    case invalid
  }
  
  fileprivate(set) lazy var state: Variable<State> = Variable(.initial)
  
  fileprivate(set) lazy var titleNode: ASTextNode = ASTextNode()
  fileprivate(set) lazy var inputNode: ASEditableTextNode = ASEditableTextNode()
  fileprivate(set) lazy var separatorNode: ASDisplayNode = ASDisplayNode()
  fileprivate(set) lazy var errorMessageNode: ASTextNode = ASTextNode()
  
  fileprivate(set) lazy var variableInput = Variable<String>("")
  fileprivate lazy var textPasting: Bool = false
  fileprivate var insertNode: ASDisplayNode? = nil
  
  fileprivate let type: AuthInputType
  
  required init(with type: AuthInputType, insertNode: ASDisplayNode? = nil) {
    self.type = type
    self.insertNode = insertNode
    super.init()
    automaticallyManagesSubnodes = true
    
    inputNode.style.minHeight = ASDimension(unit: .points, value: 19.0)
    separatorNode.style.height = ASDimension(unit: .points, value: 1)
    
    look.apply(Style.authInputStyle(type: type))
    look.prepare(states: "valid", "initial", change: Style.authInputValidStyle)
    look.prepare(state: "invalid", change: Style.authInputInvalidStyle)
    look.state = "initial"
    
    let gesture = UITapGestureRecognizer.init(target: self, action: #selector(openKeyboard))
    view.addGestureRecognizer(gesture)
    
    inputNode.delegate = self
    
    state.asObservable()
      .distinctUntilChanged()
      .bind(onNext: { [weak self] (state) in
        self?.transitionLayout(withAnimation: true, shouldMeasureAsync: false, measurementCompletion: nil)
      }).addDisposableTo(disposeBag)
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    guard let insertNode = insertNode else {
      var children: [ASLayoutElement] = [titleNode, inputNode, separatorNode]
      if state.value == .invalid {
        children.append(errorMessageNode)
      }
      return ASStackLayoutSpec(direction: .vertical,
                               spacing: 4.0,
                               justifyContent: .start,
                               alignItems: .stretch,
                               children: children)
    }
    let inputSpec = ASStackLayoutSpec(direction: .vertical,
                                      spacing: 4.0,
                                      justifyContent: .start,
                                      alignItems: .stretch,
                                      children: [titleNode, inputNode])
    inputSpec.style.flexGrow = 1
    inputSpec.style.flexShrink = 1
    let mainSpec = ASStackLayoutSpec(direction: .horizontal,
                                     spacing: 5.0,
                                     justifyContent: .start,
                                     alignItems: .center,
                                     children: [inputSpec, insertNode])
    var children: [ASLayoutElement] = [mainSpec, separatorNode]
    if state.value == .invalid {
      children.append(errorMessageNode)
    }
    return ASStackLayoutSpec(direction: .vertical,
                             spacing: 4.0,
                             justifyContent: .start,
                             alignItems: .stretch,
                             children: children)
    
  }
  
  override func didCompleteLayoutTransition(_ context: ASContextTransitioning) {
    super.didCompleteLayoutTransition(context)
    supernode?.transitionLayout(withAnimation: true, shouldMeasureAsync: true, measurementCompletion: nil)
  }
  
  
  override func animateLayoutTransition(_ context: ASContextTransitioning) {
    
    switch state.value {
    case .invalid:
      UIView.animate(withDuration: 1.0, animations: { [weak self] in
        guard let unwrapSelf = self else { return }
        unwrapSelf.look.state = "invalid"
        unwrapSelf.titleNode.attributedText = NSAttributedString(string: unwrapSelf.type.text, attributes: Attributes.invalidTitleTextAttributes)
        unwrapSelf.errorMessageNode.frame = context.finalFrame(for: unwrapSelf.errorMessageNode)
        
        }, completion: { (finish) in
          context.completeTransition(finish)
      })
      
    case .valid, .initial:
      UIView.animate(withDuration: 1.0, animations: { [weak self] in
        guard let unwrapSelf = self else { return }
        unwrapSelf.errorMessageNode.frame.size = .zero
        unwrapSelf.separatorNode.frame = context.finalFrame(for: unwrapSelf.separatorNode)
        unwrapSelf.inputNode.frame = context.finalFrame(for: unwrapSelf.inputNode)
        unwrapSelf.titleNode.frame = context.finalFrame(for: unwrapSelf.titleNode)
        unwrapSelf.look.state = "valid"
        unwrapSelf.titleNode.attributedText = NSAttributedString(string: unwrapSelf.type.text, attributes: Attributes.titleTextAttributes)
        },completion: { (finish) in
          context.completeTransition(finish)
      })
    }
  }
}

extension AuthInputNode: ASEditableTextNodeDelegate {
  
  func editableTextNode(_ editableTextNode: ASEditableTextNode, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if text == "\n" {
      editableTextNode.resignFirstResponder()
      return false
    }
    
    guard type == .password else {
      variableInput.value = (variableInput.value as NSString).replacingCharacters(in: range, with: text)
      
      if !(state.value == .initial) {
        _ = isValid()
      }
      return true
    }
    
    switch textPasting {
    case true:
      textPasting = false
      return true
      
    case false:
      variableInput.value = (variableInput.value as NSString).replacingCharacters(in: range, with: text)
      if !(state.value == .initial) {
        _ = isValid()
      }
      switch text.characters.count {
      case 0:
        return true
      default:
        textPasting = true
        UIPasteboard.general.string = text.characters.map({ _ in "*" }).joined()
        editableTextNode.textView.paste(self)
        return false
      }
    }
  }
}

extension AuthInputNode {
  
  func isValid() -> Bool {
    if (!type.isValid(text: variableInput.value)) {
      state.value = .invalid
      return false
    } else {
      state.value = .valid
      return true
    }
  }
  
  @objc func openKeyboard() {
    inputNode.becomeFirstResponder()
  }
}

extension Attributes {
  static var titleTextAttributes = [NSFontAttributeName: Fonts.MainFonts.system.font(size: 13.0, weight: UIFontWeightRegular),
                                    NSForegroundColorAttributeName: Palette.Auth.Node.InputNode.validTitle.color]
  static var invalidTitleTextAttributes =
    [NSFontAttributeName: Fonts.MainFonts.system.font(size: 13.0, weight: UIFontWeightRegular),
     NSForegroundColorAttributeName: Palette.Auth.Node.InputNode.invalidTitle.color]
  static var messageTextAttributes =
    [NSFontAttributeName: Fonts.MainFonts.system.font(size: 10.0, weight: UIFontWeightRegular),
     NSForegroundColorAttributeName: Palette.Auth.Node.InputNode.errorText.color]
  static var inputTextAttributes = [NSFontAttributeName: Fonts.MainFonts.system.font(size: 16.0, weight: UIFontWeightRegular),
                                    NSForegroundColorAttributeName: Palette.Auth.Node.InputNode.inputText.color,
                                    NSParagraphStyleAttributeName: Attributes.paragraphAuthInputStyle]
}

fileprivate extension Attributes {
  static var paragraphAuthInputStyle: NSParagraphStyle {
    let style = NSMutableParagraphStyle()
    style.lineBreakMode = .byTruncatingHead
    return style
  }
}
