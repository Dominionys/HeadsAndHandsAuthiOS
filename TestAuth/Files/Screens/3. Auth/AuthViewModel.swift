import RxSwift
import UIKit

typealias AuthViewControllerBindings = (
  observableAppearanceState: Observable<UIViewController.AppearanceState>?,
  observableClickRegisterButton: Observable<Void>?,
  observableClickResetPasswordButton: Observable<Void>?,
  observableValidateTapEnter: Observable<(email: String, password: String)>?
)

typealias AuthViewControllerBindingsFactory = () -> AuthViewControllerBindings

final class AuthViewModel: DisposeBagProvider, ReactiveCompatible {
  fileprivate let factoryBindings: AuthViewControllerBindingsFactory
  fileprivate(set) lazy var observableRouting = Observable<Routing>.never()
  
  required init(factoryBindings: @escaping AuthViewControllerBindingsFactory) {
    self.factoryBindings = factoryBindings
    
    let observableClickRegisterButton = rx.observableClickRegisterButton()
    let observableClickRegisterRouting = rx.observableClickRegisterRouting(observableClickRegisterButton)
    
    let observableClickResetPasswordButton = rx.observableClickResetPasswordButton()
    let observableClickResetPasswordRouting = rx.observableClickResetPasswordRouting(observableClickResetPasswordButton)
    
    let observableValidateTapEnter = rx.observableValidateTapEnter()
    let observableRequestWeather = rx.observableRequestWeather(observableValidateTapEnter)
    let observableAlertWeatherRouting = rx.observableAlertWeatherRouting(observableRequestWeather)
    
    let observableRouting = rx.observableRouting(observableClickRegisterRouting, observableClickResetPasswordRouting, observableAlertWeatherRouting)
    self.observableRouting = observableRouting
  }
}

fileprivate extension Reactive where Base == AuthViewModel {
  
  func observableRouting(_ observables: Observable<Routing>...) -> Observable<Routing> {
    return Observable
      .merge(observables)
      .throttle(2.0, scheduler: MainScheduler.instance)
  }
  
  func observableClickRegisterRouting(_ observableClickRegisterButton: Observable<Void>) -> Observable<Routing> {
    return observableClickRegisterButton
      .map({ Routing.openRegister })
  }
  
  func observableClickResetPasswordRouting(_ observableClickResetPasswordButton: Observable<Void>) -> Observable<Routing> {
    return observableClickResetPasswordButton
      .map({ Routing.openResetPassword })
  }
  
  func observableAlertWeatherRouting(_ observableRequestWeather: Observable<Int>) -> Observable<Routing> {
    return observableRequestWeather
      .map({ (temperature) -> Routing in
        let title: AlertTitle = AlertTitle(message: "\(temperature) градус(ов)", title: "г.Красноярск")
        let actions: [AlertAction] = []
        return Routing.showActionAlert(title, actions, {})
      })
  }
  
  func observableRequestWeather(_ observableValidateTapEnter: Observable<(email: String, password: String)>) -> Observable<Int> {

    return observableValidateTapEnter
      .flatMapLatest({ _ -> Observable<Int> in
        return Observable
          .using({ NetworkService() }, observableFactory: { (service: NetworkService) in
            let request: Request<NetworkStrategyWeather> = service.request(NetworkService.ServiceType.normal)
            let observable: Observable<Int> = request.observe("Krasnoyarsk")
            return observable
          })
      })
  }
}

fileprivate extension Reactive where Base == AuthViewModel {
  
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
  
  func observableClickRegisterButton() -> Observable<Void> {
    return base.factoryBindings().observableClickRegisterButton.observableOrNever
  }
  
  func observableClickResetPasswordButton() -> Observable<Void> {
    return base.factoryBindings().observableClickResetPasswordButton.observableOrNever
  }
  
  func observableValidateTapEnter() -> Observable<(email: String, password: String)> {
    return base.factoryBindings().observableValidateTapEnter.observableOrNever
  }
}




