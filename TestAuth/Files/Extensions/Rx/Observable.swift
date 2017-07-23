import RxSwift

protocol ObservableType {
  
  associatedtype ElementType
  
  var wrapped: Observable<ElementType> { get }
}

extension Observable: ObservableType {
  
  typealias ElementType = E
  
  var wrapped: Observable {
    return self
  }
}

extension Optional where Wrapped: ObservableType {
  
  var observableOrEmpty: Observable<Wrapped.ElementType> {
    switch self?.wrapped {
    case .none:
      return Observable<Wrapped.ElementType>.empty()
    case .some(let wrapped):
      return wrapped
    }
  }
  
  var observableOrNever: Observable<Wrapped.ElementType> {
    switch self?.wrapped {
    case .none:
      return Observable<Wrapped.ElementType>.never()
    case .some(let wrapped):
      return wrapped
    }
  }
}

