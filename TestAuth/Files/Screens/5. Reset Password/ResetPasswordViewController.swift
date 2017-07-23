//
//  ResetPasswordViewController.swift
//  TestAuth
//
//  Created by Denis Bezrukov on 23.07.17.
//  Copyright © 2017 Denis Bezrukov. All rights reserved.
//

import AsyncDisplayKit

final class ResetPasswordViewController: ASViewController<ResetPasswordNode>, DisposeBagProvider {
  
  fileprivate var viewModel: ResetPasswordViewModel!

  required convenience init() {
    let node = ResetPasswordNode()
    self.init(node: node)
    
    type = .resetPassword5
    title = "Восстановление пароля"
    viewModel = ResetPasswordViewModel.init(factoryBindings: getFactoryBindings())
    viewModel.observableRouting.bind(to: rx.observerRouting).addDisposableTo(disposeBag)
  }
  
  deinit {
    debugPrint("\(#file)+\(#line)")
  }
}

fileprivate extension ResetPasswordViewController {
  
  func getFactoryBindings() -> () -> ResetPasswordViewControllerBindings {
    return { [weak self] () -> ResetPasswordViewControllerBindings in
      return RegisterViewControllerBindings(
        observableAppearanceState:     self?.rx.observableAppearanceState(),
        observableClickDismissButton:  self?.node.publishDismissTap.asObservable()
      )
    }
  }
}
