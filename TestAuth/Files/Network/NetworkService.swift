import Moya
import RxSwift
import RxSwift

protocol NetworkStrategy: Strategy {
  
  static func api(_ object: StrategyObject) -> Api
  static func error(_ error: Moya.MoyaError?) -> Observable<StrategyResult>
  static func map(_ data: Data, object: StrategyObject?) -> StrategyResult
}

class NetworkService: Disposable {
  
  enum ServiceType {
    case normal, auth, mocked
  }
  
  fileprivate lazy var providerNormal: RxMoyaProvider<Api> = self.getProviderNormal()
  
  func request<S: NetworkStrategy>(_ type: NetworkService.ServiceType = .normal) -> Request<S> {
    switch type {
    case .normal:   return Request<S>(providerNormal, .normal)
    default:        return Request<S>(providerNormal, .normal)
    }
  }
  
  func dispose() {
    //
  }
}

private extension NetworkService {
  
  private enum MoyaPluginType {
    case none
    case debug
  }
  
  func getProviderNormal() -> RxMoyaProvider<Api> {
    return RxMoyaProvider<Api>()
  }
  
  private static func plugins(_ forType: MoyaPluginType) -> [PluginType] {
    switch forType {
    case .none:                 return []
    case .debug:                return [NetworkLoggerPlugin(verbose: true)]
    }
  }
}

class Request<S: NetworkStrategy> {
  
  fileprivate weak var provider: RxMoyaProvider<Api>?
  fileprivate var type: NetworkService.ServiceType = .normal
  
  fileprivate init(_ provider: RxMoyaProvider<Api>, _ type: NetworkService.ServiceType = .normal) {
    self.provider = provider
    self.type = type
  }
  
  fileprivate func with(target: Api, object: S.StrategyObject? = nil) -> Observable<S.StrategyResult> {
    guard let provider = provider else { return S.error(nil) }
    
    let observableRequest =  provider
      .request(target)
      .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .map({ (response: Response) -> S.StrategyResult in
        return S.map(response.data, object: object)
      })
      .delay(0.5, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
    
    return observableRequest
  }
}

extension Request {
  
  func observe(_ object: S.StrategyObject) -> Observable<S.StrategyResult> {
    return with(target: S.api(object), object: object)
  }
}
