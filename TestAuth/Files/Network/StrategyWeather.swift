//
//  StrategyWeather.swift
//  TestAuth
//
//  Created by Denis Bezrukov on 24.07.17.
//  Copyright © 2017 Denis Bezrukov. All rights reserved.
//

import SwiftyJSON
import Moya
import RxSwift

class NetworkStrategyWeather: NetworkStrategy {
  
  typealias StrategyObject = String
  
  typealias StrategyResult = Int
  
  static func api(_ object: StrategyObject) -> Api {
    return Api.weather(object)
  }
  
  static func error(_ error: MoyaError?) -> Observable<StrategyResult> {
    return Observable<StrategyResult>.just(0)
  }
  
  static func map(_ data: Data, object: StrategyObject?) -> StrategyResult {
    let json = JSON(data: data)
    return json["main"]["temp"].intValue
  }
}
