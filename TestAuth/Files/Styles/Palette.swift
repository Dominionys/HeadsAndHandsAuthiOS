//
//  Style.swift
//  TestAuth
//
//  Created by Denis Bezrukov on 20.07.17.
//  Copyright © 2017 Denis Bezrukov. All rights reserved.
//

import UIKit

enum Palette {
  
  enum Window: Colorable {
    case background
    var color: UIColor {
      switch self {
      case .background:
        return Colors.white.color
      }
    }
  }
  
  enum Navigation: Colorable {
    case background
    case navigationBar
    case title
    
    var color: UIColor {
      switch self {
      case .background:
        return Colors.white.color
      case .navigationBar:
        return Colors.white.color
      case .title:
        return Colors.black.color
      }
    }
  }
  
  enum PreAuth {
    enum Node: Colorable {
      case background
      case border
      
      var color: UIColor {
        switch self {
        case .background:
          return Colors.white.color
        case .border:
          return Colors.lightGray.color
        }
      }
    }
  }
  
  enum Auth {
    enum Node: Colorable {
      enum InputNode: Colorable {
        case validTitle
        case invalidTitle
        case inputText
        case validSeparator
        case invalidSeparator
        case errorText
        
        var color: UIColor {
          switch self {
          case .validTitle:
            return Colors.gray.color
          case .invalidTitle:
            return Colors.darkRed.color
          case .validSeparator:
            return Colors.lightGray.color
          case .invalidSeparator:
            return Colors.darkRed.color
          case .inputText:
            return Colors.black.color
          case .errorText:
            return Colors.darkRed.color
          }
        }
      }
      
      enum ResetPassword: Colorable {
        case text
        case border
        
        var color: UIColor {
          switch self {
          case .text:
            return Colors.gray.color
          case .border:
            return Colors.lightGray.color
          }
        }
      }
      
      enum EnterNode: Colorable {
        case background
        case text
        
        var color: UIColor {
          switch self {
          case .background:
            return Colors.orange.color
          case .text:
            return Colors.white.color
          }
        }
      }
      
      case background
      case registerText
      
      var color: UIColor {
        switch self {
        case .background:
          return Colors.white.color
        case .registerText:
          return Colors.blue.color
        }
      }
    }
  }
  
}

private enum Colors: Colorable {
  
  case black
  case carbon
  case darkGray
  case gray
  case lightGray
  case white
  case lightGreen
  case green
  case orange
  case darkRed
  case blue
  case transparent
  
  
  var color: UIColor {
    
    switch self {
    case .black:            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    case .carbon:           return #colorLiteral(red: 0.09322849661, green: 0.1168923005, blue: 0.1584300697, alpha: 1)
    case .darkGray:         return #colorLiteral(red: 0.3832177818, green: 0.4148965478, blue: 0.4648051858, alpha: 1)
    case .gray:             return #colorLiteral(red: 0.4744554758, green: 0.4745410681, blue: 0.4744500518, alpha: 1)
    case .lightGray:        return #colorLiteral(red: 0.9214683175, green: 0.9216262698, blue: 0.9214583635, alpha: 1)
    case .white:            return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    case .lightGreen:       return #colorLiteral(red: 0.389090836, green: 0.7592173815, blue: 0.6823834181, alpha: 1)
    case .green:            return #colorLiteral(red: 0.3364262617, green: 0.6564551047, blue: 0.5900208413, alpha: 1)
    case .orange:           return #colorLiteral(red: 1, green: 0.6064860225, blue: 0.0006096240832, alpha: 1)
    case .darkRed:          return #colorLiteral(red: 0.7607843137, green: 0.3882352941, blue: 0.3882352941, alpha: 1)
    case .blue:             return #colorLiteral(red: 0.218144834, green: 0.5202445984, blue: 0.7819221616, alpha: 1)
    case .transparent:      return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
  }
}


