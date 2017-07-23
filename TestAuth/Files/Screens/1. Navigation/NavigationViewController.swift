import AsyncDisplayKit
import RxSwift
import RxCocoa
import Look

final class NavigationViewController: ASNavigationController, DisposeBagProvider {
  
  fileprivate var viewModel: NavigationViewModel!
  fileprivate var rootType: UIViewController.ViewType!
  
  
  required convenience init(type: UIViewController.ViewType) {
    self.init(rootViewController: UIViewController())
    self.rootType = type
    self.type = .navigation1

    viewModel = NavigationViewModel.init(factoryBindings: getFactoryBindings())
    viewModel.observableRouting.bind(to: rx.observerRouting).addDisposableTo(disposeBag)
    
    look.apply(Style.navigationStyle)
  }

  deinit {
    debugPrint("\(#file)+\(#line)")
  }
}

fileprivate extension NavigationViewController {

  func getFactoryBindings() -> () -> NavigationViewControllerBindings {
    let rootType = self.rootType

    return { [weak self] () -> NavigationViewControllerBindings in
      return NavigationViewControllerBindings(
        observableAppearanceState:  self?.rx.observableAppearanceState(),
        rootType: rootType ?? .root0
      )
    }
  }
}


