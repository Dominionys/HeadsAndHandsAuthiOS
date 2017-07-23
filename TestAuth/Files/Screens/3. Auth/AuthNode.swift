//
//  AuthNode.swift
//  TestAuth
//
//  Created by Denis Bezrukov on 20.07.17.
//  Copyright © 2017 Denis Bezrukov. All rights reserved.
//

import AsyncDisplayKit
import RxSwift

final class AuthNode: ASDisplayNode {
  
  lazy var insetBottom: CGFloat = 0.0

  fileprivate(set) lazy var publishTapEnterButton: PublishSubject<Void> = PublishSubject()
  fileprivate(set) lazy var publishTapRegisterButton: PublishSubject<Void> = PublishSubject()
  fileprivate(set) lazy var publishTapResetPasswordButton: PublishSubject<Void> = PublishSubject()
  
  fileprivate(set) lazy var emailNode: AuthInputNode = AuthInputNode(with: .email)
  fileprivate(set) lazy var passwordNode: AuthInputNode = AuthInputNode(with: .password, insertNode: self.resetPassword)
  fileprivate(set) lazy var enterButtonNode: ASButtonNode = ASButtonNode()
  fileprivate(set) lazy var registerButtonNode: ASButtonNode = ASButtonNode()
  fileprivate(set) lazy var resetPassword: ASButtonNode = ASButtonNode()
  
  override init() {
    super.init()
    automaticallyManagesSubnodes = true
    registerButtonNode.addTarget(self, action: #selector(tapRegisterButton), forControlEvents: .touchUpInside)
    resetPassword.addTarget(self, action: #selector(tapResetPassword), forControlEvents: .touchUpInside)
    enterButtonNode.addTarget(self, action: #selector(tapEnterButton), forControlEvents: .touchUpInside)
    
    let gesture = UITapGestureRecognizer.init(target: self, action: #selector(closeKeyboard))
    view.addGestureRecognizer(gesture)
    look.apply(Style.authNodeStyle)
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    enterButtonNode.style.spacingBefore = 22.0
    enterButtonNode.style.alignSelf = .center
    
    registerButtonNode.style.alignSelf = .center
    registerButtonNode.style.spacingBefore = 9.0
    let contentSpec = ASStackLayoutSpec(direction: .vertical,
                                        spacing: 12.0,
                                        justifyContent: .start,
                                        alignItems: .stretch,
                                        children: [emailNode, passwordNode, enterButtonNode, registerButtonNode])
    let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 16.0, bottom: insetBottom, right: 16.0),
                                      child: contentSpec)
    return ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: insetSpec)
  }
}

fileprivate extension AuthNode {
  
  @objc func tapRegisterButton() {
    publishTapRegisterButton.onNext()
  }
  
  @objc func closeKeyboard() {
    emailNode.inputNode.resignFirstResponder()
    passwordNode.inputNode.resignFirstResponder()
  }
  
  @objc func tapResetPassword() {
    publishTapResetPasswordButton.onNext()
  }
  
  @objc func tapEnterButton() {
    publishTapEnterButton.onNext()
  }
}


extension Attributes {
  
  static var enterTextAttributes = [NSFontAttributeName: Fonts.MainFonts.system.font(size: 15.0, weight: UIFontWeightMedium),
                                    NSForegroundColorAttributeName: Palette.Auth.Node.EnterNode.text.color]
  static var registerTextAttributes = [NSFontAttributeName: Fonts.MainFonts.system.font(size: 15.0, weight: UIFontWeightRegular),
                                       NSForegroundColorAttributeName: Palette.Auth.Node.registerText.color]
  static var resetPasswordTextAttributes = [NSFontAttributeName: Fonts.MainFonts.system.font(size: 12.0, weight: UIFontWeightRegular),
                                            NSForegroundColorAttributeName: Palette.Auth.Node.ResetPassword.text.color]
}







