//
//  AlertAction.swift
//  TestAuth
//
//  Created by Denis Bezrukov on 24.07.17.
//  Copyright © 2017 Denis Bezrukov. All rights reserved.
//

import Foundation

struct AlertAction {
  
  enum Style {
    case destructive, normal
  }
  
  let handler: () -> Void
  let style: AlertAction.Style
  let title: String
  
  init(title: String, style: AlertAction.Style = .normal, handler: @escaping () -> Void) {
    self.handler = handler
    self.style = style
    self.title = title
  }
}
