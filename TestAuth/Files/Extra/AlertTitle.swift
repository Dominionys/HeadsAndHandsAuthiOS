//
//  AlertTitle.swift
//  TestAuth
//
//  Created by Denis Bezrukov on 24.07.17.
//  Copyright © 2017 Denis Bezrukov. All rights reserved.
//

import Foundation

struct AlertTitle {
  
  let message: String?
  let title: String?
  
  init(message: String? = nil, title: String? = nil) {
    self.message = message
    self.title = title
  }
}
