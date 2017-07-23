import UIKit
import RxSwift
import RxCocoa

final class RootViewController: UIViewController, DisposeBagProvider {

  fileprivate var viewModel: RootViewModel!

  override func loadView() {
    super.loadView()
    viewModel = RootViewModel.init(factoryBindings: getFactoryBindings())
    type = .root0
    viewModel.observableRouting.bind(to: rx.observerRouting).addDisposableTo(disposeBag)
  }

  deinit {
    debugPrint("\(#file)+\(#line)")
  }
}

fileprivate extension RootViewController {

  func getFactoryBindings() -> () -> RootViewControllerBindings {

    return { [weak self] () -> RootViewControllerBindings in
      return self?.rx.observableAppearanceState()
    }
  }
}

