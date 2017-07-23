//
//  DispatchQueue.swift
//  TestAuth
//
//  Created by Denis Bezrukov on 23.07.17.
//  Copyright © 2017 Denis Bezrukov. All rights reserved.
//

import Foundation

extension DispatchQueue {
  
  private static var array = [String]()
  
  class func once(file: String = #file, function: String = #function, line: Int = #line, block: () -> Void) {
    let token = "\(file)+\(function)+\(line)"
    once(token: token, block: block)
  }
  
  private class func once(token: String, block:() -> Void) {
    objc_sync_enter(self)
    defer {
      objc_sync_exit(self)
    }
    if array.contains(token) {
      return
    }
    array.append(token)
    block()
  }
}

