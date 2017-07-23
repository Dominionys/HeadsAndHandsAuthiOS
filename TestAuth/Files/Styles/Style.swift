import Look
import AsyncDisplayKit

struct Style {
  static var windowStyle: Change<UIView> {
    return { (view: UIView) -> Void in
      view.backgroundColor = Palette.Window.background.color
    }
  }
  
  static var navigationBarStyle: Change<UINavigationBar> {
    return { (bar: UINavigationBar) -> Void in
      bar.barTintColor = Palette.Navigation.navigationBar.color
      bar.isTranslucent = false
      bar.titleTextAttributes = [
        NSFontAttributeName: Fonts.MainFonts.system.font(size: 17.0, weight: UIFontWeightMedium),
        NSForegroundColorAttributeName: Palette.Navigation.title.color
      ]
      
    }
  }
  
  static var navigationStyle: Change<UINavigationController> {
    return { (nav: UINavigationController) -> Void in
      nav.view.backgroundColor = Palette.Navigation.background.color
      nav.view.isOpaque = true
      nav.navigationBar.look.apply(Style.navigationBarStyle)
    }
  }
  
  static var authContollerStyle: Change<AuthViewController> {
    return { (controller: AuthViewController) -> Void in
      
    }
  }
  
  static var authNodeStyle: Change<AuthNode> {
    return { (auth: AuthNode) -> Void in
      auth.backgroundColor = Palette.Auth.Node.background.color
      auth.resetPassword.look.apply(Style.resetPasswordStyle)
      auth.enterButtonNode.look.apply(Style.enterButtonStyle)
      auth.registerButtonNode.setAttributedTitle(NSAttributedString(string: "У меня еще нет аккаунта. Создать.", attributes: Attributes.registerTextAttributes), for: .normal)
    }
  }
  
  static var enterButtonStyle: Change<ASButtonNode> {
    return { (node: ASButtonNode) -> Void in
      node.backgroundColor = Palette.Auth.Node.EnterNode.background.color
      node.cornerRadius = 22.0
      node.setAttributedTitle(NSAttributedString(string: "Войти", attributes: Attributes.enterTextAttributes), for: .normal)
      node.style.preferredSize = CGSize(width: 147.0, height: 44.0)
    }
  }
  
  static var resetPasswordStyle: Change<ASButtonNode> {
    return { (node: ASButtonNode) -> Void in
      node.cornerRadius = 4.0
      node.borderWidth = 0.5
      node.borderColor = Palette.Auth.Node.ResetPassword.border.color.cgColor
      node.setAttributedTitle(NSAttributedString.init(string: "Забыли пароль?", attributes: Attributes.resetPasswordTextAttributes), for: .normal)
      node.style.preferredSize = CGSize(width: 113.0, height: 30.0)
    }
  }
  
  static var authInputValidStyle: Change<AuthInputNode> {
    return { (node: AuthInputNode) -> Void in
      node.separatorNode.backgroundColor = Palette.Auth.Node.InputNode.validSeparator.color
    }
  }
  
  static var authInputInvalidStyle: Change<AuthInputNode> {
    return { (node: AuthInputNode) -> Void in
      node.separatorNode.backgroundColor = Palette.Auth.Node.InputNode.invalidSeparator.color
    }
  }
  
  static func authInputStyle(type: AuthInputNode.AuthInputType) -> Change<AuthInputNode> {
    return { (node: AuthInputNode) -> Void in
      node.titleNode.attributedText = NSAttributedString(string: type.text, attributes: Attributes.titleTextAttributes)
      node.errorMessageNode.attributedText = NSAttributedString(string: type.errorMessage, attributes: Attributes.messageTextAttributes)
      node.inputNode.textView.textContainer.maximumNumberOfLines = 1
      node.inputNode.typingAttributes = Attributes.inputTextAttributes
    }
  }
  
}
