//
//  Fonts.swift
//  TestAuth
//
//  Created by Denis Bezrukov on 22.07.17.
//  Copyright © 2017 Denis Bezrukov. All rights reserved.
//

import UIKit

enum Fonts {
  enum MainFonts: Fontable {
    case system
    
    func font(size: CGFloat, weight: CGFloat) -> UIFont {
      switch self {
      case .system:
        return UIFont.systemFont(ofSize: size, weight:weight)
      }
    }
  }
}

