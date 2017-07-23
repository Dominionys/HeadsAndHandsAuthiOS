import AsyncDisplayKit
import RxSwift
import RxCocoa

final class PreAuthViewController: ASViewController<PreAuthNode>, DisposeBagProvider {
  
  fileprivate var viewModel: PreAuthViewModel!
  
  convenience init() {
    let node = PreAuthNode()
    self.init(node: node)
    
    title = ""
    viewModel = PreAuthViewModel.init(factoryBindings: getFactoryBindings())
    type = .preAuth2
    viewModel.observableRouting.bind(to: rx.observerRouting).addDisposableTo(disposeBag)
  }
  
  deinit {
    debugPrint("\(#file)+\(#line)")
  }
}

fileprivate extension PreAuthViewController {
  
  func getFactoryBindings() -> () -> PreAuthViewControllerBindings {
    return { [weak self] () -> PreAuthViewControllerBindings in
      return PreAuthViewControllerBindings(
      observableAppearanceState:    self?.rx.observableAppearanceState(),
      observableClickAuthButton:    self?.node.publishClickAuth.asObservable()
      )
    }
  }
}



