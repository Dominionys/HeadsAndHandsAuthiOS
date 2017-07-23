import Moya
import RxSwift

enum Api: Moya.TargetType {
  
  case weather(String)
  
  var baseURL: URL {
    return URL(string: "http://api.openweathermap.org/data/2.5/")!
  }
  
  var path: String {
    switch self {
    case .weather:
      return "weather"
    }
  }
  
  var method: Moya.Method {
    return Moya.Method.get
  }
  
  var parameters: [String: Any]? {
    switch self {
    case .weather(let city):
      return [
        "q": city,
        "units": "metric",
        "APPID": "2147249be40cff646cb1b31120dfc66f"
      ]
    }
  }
  
  var parameterEncoding: ParameterEncoding {
    return URLEncoding()
  }
  
  var sampleData: Data {
    return Data()
  }
  
  var task: Moya.Task {
    return Moya.Task.request
  }
  
  var validate: Bool {
    return false
  }
}
