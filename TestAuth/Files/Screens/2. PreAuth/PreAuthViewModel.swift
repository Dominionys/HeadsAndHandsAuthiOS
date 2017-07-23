import RxSwift
import UIKit

typealias PreAuthViewControllerBindings = (
  observableAppearanceState: Observable<UIViewController.AppearanceState>?,
  observableClickAuthButton: Observable<Void>?
)

typealias PreAuthViewControllerBindingsFactory = () -> PreAuthViewControllerBindings

final class PreAuthViewModel: DisposeBagProvider, ReactiveCompatible {
  fileprivate let factoryBindings: PreAuthViewControllerBindingsFactory
  fileprivate(set) lazy var observableRouting = Observable<Routing>.never()
  
  required init(factoryBindings: @escaping PreAuthViewControllerBindingsFactory) {
    self.factoryBindings = factoryBindings
    
    let observableClickAuthButton = rx.observableClickAuthButton()
    let observableClickAuthRouting = rx.observableClickAuthRouting(observableClickAuthButton)
    let observableRouting = self.rx.observableRouting(observableClickAuthRouting)
    
    self.observableRouting = observableRouting
  }
}

fileprivate extension Reactive where Base == PreAuthViewModel {
  
  func observableRouting(_ observables: Observable<Routing>...) -> Observable<Routing> {
    return Observable
      .merge(observables)
      .observeOn(MainScheduler.instance)
  }
  
  func observableClickAuthRouting(_ observableClickAuthButton: Observable<Void>) -> Observable<Routing> {
    return observableClickAuthButton
      .map({ Routing.openAuth })
  }
}

fileprivate extension Reactive where Base == PreAuthViewModel {
  
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
  
  func observableClickAuthButton() -> Observable<Void> {
    return base.factoryBindings().observableClickAuthButton.observableOrNever
  }
}



