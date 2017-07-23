import RxSwift
import UIKit

typealias RootViewControllerBindings = (
  Observable<UIViewController.AppearanceState>?
)

typealias RootViewControllerBindingsFactory = () -> RootViewControllerBindings

final class RootViewModel: DisposeBagProvider, ReactiveCompatible {
  fileprivate let factoryBindings: RootViewControllerBindingsFactory
  fileprivate(set) lazy var observableRouting = Observable<Routing>.never()
  
  required init(factoryBindings: @escaping RootViewControllerBindingsFactory) {
    self.factoryBindings = factoryBindings
    
    let observableAppeared = self.rx.observableAppeared()
    let observableApearedRouting = self.rx.observableApearedRouting(observableAppeared)
    let observableRouting = self.rx.observableRouting(observableApearedRouting)
    
    self.observableRouting = observableRouting
  }
}

fileprivate extension Reactive where Base == RootViewModel {
  func observableApearedRouting(_ observableAppeared: Observable<Void>) -> Observable<Routing> {
    return observableAppeared
      .map({ Routing.preparedRoot })
  }
  
  func observableRouting(_ observables: Observable<Routing>...) -> Observable<Routing> {
    return Observable
      .merge(observables)
      .observeOn(MainScheduler.instance)
  }
}

fileprivate extension Reactive where Base == RootViewModel {
  
  func observableAppeared() -> Observable<Void> {
    guard let observableState = base.factoryBindings() else { return Observable<Void>.never() }
    return observableState
      .filter({ $0 == .didAppear })
      .map({ _ in () })
      .take(1)
      .shareReplay(1)
  }
}

