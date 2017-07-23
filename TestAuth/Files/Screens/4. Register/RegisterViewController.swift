//
//  RegisterViewController.swift
//  TestAuth
//
//  Created by Denis Bezrukov on 23.07.17.
//  Copyright © 2017 Denis Bezrukov. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

final class RegisterViewController: ASViewController<RegisterNode>, DisposeBagProvider {
  
  fileprivate var viewModel: RegisterViewModel!
  
  required init() {
    super.init(node: RegisterNode())
    type = .register4
    title = "Регистрация"
    viewModel = RegisterViewModel.init(factoryBindings: getFactoryBindings())
    viewModel.observableRouting.bind(to: rx.observerRouting).addDisposableTo(disposeBag)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    debugPrint("\(#file)+\(#line)")
  }
}

fileprivate extension RegisterViewController {
  
  func getFactoryBindings() -> () -> RegisterViewControllerBindings {
    return { [weak self] () -> RegisterViewControllerBindings in
      return RegisterViewControllerBindings(
        observableAppearanceState:     self?.rx.observableAppearanceState(),
        observableClickDismissButton:  self?.node.publishDismissTap.asObservable()
      )
    }
  }
}


