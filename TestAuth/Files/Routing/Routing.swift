//
//  Routing.swift
//  wrun-ios
//
//  Created by Denis Bezrukov on 05.06.17.
//  Copyright © 2017 Denis Bezrukov. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit

enum Routing {
  case preparedRoot
  case preparedNavigation(type: UIViewController.ViewType)
  case showActionAlert(AlertTitle, [AlertAction], (() -> ())?)
  case openAuth
  case openRegister
  case openResetPassword
  case back
  case dismiss
}

extension Routing: NotificationDescriptable {
  
  static var descriptor: NotificationDescriptor<Routing> {
    return NotificationDescriptor<Routing> { (notification) -> Routing? in
      return notification.object as? Routing
    }
  }
  
  static var name: Notification.Name {
    return Notification.Name("\(#file)+\(#line)")
  }
}

extension UIViewController {
  
  enum ViewType {
    case abstract
    case root0
    case navigation1
    case preAuth2
    case auth3
    case register4
    case resetPassword5
  }
  
  private struct UIViewControllerRuntimeKeys {
    static var key = "\(#file)+\(#line)"
  }
  
  var type: ViewType {
    get { return objc_getAssociatedObject(self, &UIViewControllerRuntimeKeys.key) as? ViewType ?? .abstract }
    set { objc_setAssociatedObject(self,
                                   &UIViewControllerRuntimeKeys.key,
                                   newValue,
                                   .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
  }
}

extension UIViewController {
  
  func routing(with routing: Routing) {
    switch type {
    case .root0:
      preparedRoot(with: routing)
    case .navigation1:
      preparedNavigation(with: routing)
    case .preAuth2:
      openAuth(with: routing)
    case .auth3:
      openRegister(with: routing)
      openResetPassword(with: routing)
      showActionAlert(with: routing)
    case .register4:
      dismiss(with: routing)
    case .resetPassword5:
      dismiss(with: routing)
    default:
      break
    }
  }
}


fileprivate extension UIViewController {
  
  func preparedRoot(with routing: Routing) {
    guard case .preparedRoot = routing else { return }
    Routing.setRoot(with: NavigationViewController(type: .preAuth2))
  }
  
  func preparedNavigation(with routing: Routing) {
    guard case .preparedNavigation(let type) = routing,
          let navigation = self as? UINavigationController else { return }
    switch type {
    case .preAuth2:
      navigation.setViewControllers([PreAuthViewController()], animated: false)
    case .auth3:
      navigation.setViewControllers([AuthViewController()], animated: false)
    case .register4:
      navigation.setViewControllers([RegisterViewController()], animated: false)
    case .resetPassword5:
      navigation.setViewControllers([ResetPasswordViewController()], animated: false)
    default:
      break
    }
  }
  
  func openAuth(with routing: Routing) {
    guard case .openAuth = routing,
          let navigation = navigationController else { return }
    navigation.pushViewController(AuthViewController(), animated: true)
  }
  
  func openRegister(with routing: Routing) {
    guard case .openRegister = routing,
          let rootView = RootViewController.getRootViewController() else { return }
    rootView.present(NavigationViewController(type: .register4),
                     animated: true,
                     completion: nil)
  }
  
  func openResetPassword(with routing: Routing) {
    guard case .openResetPassword = routing,
          let rootView = RootViewController.getRootViewController() else { return }
    rootView.present(NavigationViewController(type: .resetPassword5),
                     animated: true,
                     completion: nil)
  }
  
  func showActionAlert(with routing: Routing) {
    guard case .showActionAlert(let title, let actions, let cancel) = routing,
          let rootView = RootViewController.getRootViewController() else { return }
    
    let alertController = UIAlertController(title: title.title, message: title.message, preferredStyle: UIAlertControllerStyle.alert)
    for action in actions {
      let style: UIAlertActionStyle = (action.style == .normal ? UIAlertActionStyle.default : UIAlertActionStyle.destructive)
      let alertAction = UIAlertAction(title: action.title, style: style, handler: { [handler = action.handler] _ in
        handler()
      })
      alertController.addAction(alertAction)
    }
    if let cancel = cancel {
      let alertAction = UIAlertAction(title: "Отмена", style: UIAlertActionStyle.cancel, handler: { [cancel] _ in
        cancel()
      })
      alertController.addAction(alertAction)
    }
    rootView.present(alertController, animated: true, completion: nil)
  }

  
//  func back(with routing: Routing) {
//    guard case .back = routing else { return }
//    guard let navig = self.navigationController  else { return }
//    navig.popViewController(animated: true)
//  }
//
  func dismiss(with routing: Routing) {
    guard case .dismiss = routing else { return }
    dismiss(animated: true, completion: nil)
  }

}

// MARK: - External Reactive

extension Reactive where Base: UIViewController {

  var observerRouting: AnyObserver<Routing> {
    let binding = UIBindingObserver(UIElement: base) { (view: UIViewController, routing: Routing) in
      view.routing(with: routing)
    }
    return binding.asObserver()
  }
}

fileprivate extension Routing {

  static func setRoot(with viewController: UIViewController) {

    guard let rootViewController = RootViewController.getRootViewController() else { return }
    rootViewController.childViewControllers.forEach { (controller) in
      controller.removeFromParentViewController()
    }
    rootViewController.view.subviews.forEach { (view) in
      view.removeFromSuperview()
    }
    rootViewController.addChildViewController(viewController)
    rootViewController.view.addSubview(viewController.view)
    rootViewController.view.bringSubview(toFront: viewController.view)
    viewController.view.snp.makeConstraints({ (maker) in
      maker.top.equalTo(rootViewController.topLayoutGuide.snp.top)
      maker.bottom.equalTo(rootViewController.bottomLayoutGuide.snp.top)
      maker.right.left.equalToSuperview()
    })
  }
}

extension RootViewController {
  
  static func getRootViewController() -> RootViewController? {
    return UIApplication.shared.keyWindow?.rootViewController as? RootViewController
  }
}
