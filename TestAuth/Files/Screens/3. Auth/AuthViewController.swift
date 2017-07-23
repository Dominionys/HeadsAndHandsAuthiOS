import AsyncDisplayKit
import RxSwift
import RxCocoa
import RxKeyboard
import RxOptional

final class AuthViewController: ASViewController<AuthNode>, DisposeBagProvider {
  
  fileprivate var viewModel: AuthViewModel!
  
  convenience init() {
    let node = AuthNode()
    self.init(node: node)
    
    viewModel = AuthViewModel.init(factoryBindings: getFactoryBindings())
    type = .auth3
    title = "Авторизация"
    viewModel.observableRouting.bind(to: rx.observerRouting).addDisposableTo(disposeBag)
    
    RxKeyboard.instance
      .visibleHeight
      .drive(onNext: { [weak self] height in
        guard let unwrapSelf = self else { return }
        unwrapSelf.node.insetBottom = height
        unwrapSelf.node.transitionLayout(withAnimation: true, shouldMeasureAsync: false, measurementCompletion: nil)
    })
    .addDisposableTo(disposeBag)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    look.apply(Style.authContollerStyle)
  }
  
  deinit {
    debugPrint("\(#file)+\(#line)")
  }
}

fileprivate extension AuthViewController {

  func getFactoryBindings() -> () -> AuthViewControllerBindings {
    return { [weak self] () -> AuthViewControllerBindings in
      return AuthViewControllerBindings(
        observableAppearanceState:          self?.rx.observableAppearanceState(),
        observableClickRegisterButton:      self?.node.publishTapRegisterButton.asObservable(),
        observableClickResetPasswordButton: self?.node.publishTapResetPasswordButton.asObservable(),
        observableValidateTapEnter:         self?.rx.observableValidateTapEnter()
      )
    }
  }
}


extension Reactive where Base == AuthViewController {
  
  func observableValidateTapEnter() -> Observable<(email: String, password: String)> {
    return base.node
      .publishTapEnterButton
      .asObserver()
      .throttle(2.0, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
      .filter({ [weak base] () -> Bool in
        guard let base = base else { return false }
        let isEmailValid = base.node.emailNode.isValid()
        let isPasswordValid = base.node.passwordNode.isValid()
        return isEmailValid && isPasswordValid
      })
      .map({ [weak base] () -> (email: String, password: String)? in
        guard let base = base else { return nil }
        let email = base.node.emailNode.variableInput.value
        let password = base.node.passwordNode.variableInput.value
        return (email, password)
      })
      .filterNil()
  }
}



