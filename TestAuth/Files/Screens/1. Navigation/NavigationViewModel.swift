import RxSwift
import UIKit

typealias NavigationViewControllerBindings = (
  observableAppearanceState: Observable<UIViewController.AppearanceState>?,
  rootType: UIViewController.ViewType
)

typealias NavigationViewControllerBindingsFactory = () -> NavigationViewControllerBindings

final class NavigationViewModel: DisposeBagProvider, ReactiveCompatible {
  fileprivate let factoryBindings: NavigationViewControllerBindingsFactory
  fileprivate(set) lazy var observableRouting = Observable<Routing>.never()
  
  required init(factoryBindings: @escaping NavigationViewControllerBindingsFactory) {
    self.factoryBindings = factoryBindings
    
    let observableAppeared = self.rx.observableAppeared()
    let observableApearedRouting = self.rx.observableApearedRouting(observableAppeared, factoryBindings().rootType)
    let observableRouting = self.rx.observableRouting(observableApearedRouting)
    
    self.observableRouting = observableRouting
  }
}

fileprivate extension Reactive where Base == NavigationViewModel {
  func observableApearedRouting(_ observableAppeared: Observable<Void>, _ type: UIViewController.ViewType) -> Observable<Routing> {
    return observableAppeared
      .map({ Routing.preparedNavigation(type: type) })
  }
  
  func observableRouting(_ observables: Observable<Routing>...) -> Observable<Routing> {
    return Observable
      .merge(observables)
      .observeOn(MainScheduler.instance)
  }
}

fileprivate extension Reactive where Base == NavigationViewModel {
  
  func observableAppeared() -> Observable<Void> {
    guard let observableState = base.factoryBindings().observableAppearanceState else { return Observable<Void>.never() }
    return observableState
      .filter({ $0 == .willAppear })
      .map({ _ in () })
      .take(1)
      .shareReplay(1)
  }
}


