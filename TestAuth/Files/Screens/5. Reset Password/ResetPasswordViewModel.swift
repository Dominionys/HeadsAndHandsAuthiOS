import RxSwift
import UIKit

typealias ResetPasswordViewControllerBindings = (
  observableAppearanceState: Observable<UIViewController.AppearanceState>?,
  observableClickDismissButton: Observable<Void>?
)

typealias ResetPasswordViewControllerBindingsFactory = () -> ResetPasswordViewControllerBindings

final class ResetPasswordViewModel: DisposeBagProvider, ReactiveCompatible {
  fileprivate let factoryBindings: ResetPasswordViewControllerBindingsFactory
  fileprivate(set) lazy var observableRouting = Observable<Routing>.never()
  
  required init(factoryBindings: @escaping ResetPasswordViewControllerBindingsFactory) {
    self.factoryBindings = factoryBindings
    
    let observableClickDismissButton = rx.observableClickDismissButton()
    let observableClickDismissRouting = rx.observableClickDismissRouting(observableClickDismissButton)
    
    let observableRouting = rx.observableRouting(observableClickDismissRouting)
    self.observableRouting = observableRouting
  }
  
  deinit {
    debugPrint("\(#file)+\(#line)")
  }
}

fileprivate extension Reactive where Base == ResetPasswordViewModel {
  
  func observableRouting(_ observables: Observable<Routing>...) -> Observable<Routing> {
    return Observable
      .merge(observables)
      .throttle(2.0, scheduler: MainScheduler.instance)
  }
  
  func observableClickDismissRouting(_ observableClickDismissButton: Observable<Void>) -> Observable<Routing> {
    return observableClickDismissButton
      .map({ Routing.dismiss })
  }
}

fileprivate extension Reactive where Base == ResetPasswordViewModel {
  
  func observableAppeared() -> Observable<Void> {
    return base
      .factoryBindings()
      .observableAppearanceState
      .observableOrNever
      .filter({ $0 == .didAppear })
      .map({ _ in () })
      .take(1)
      .shareReplay(1)
  }
  
  func observableClickDismissButton() -> Observable<Void> {
    return base.factoryBindings().observableClickDismissButton.observableOrNever
  }
}






