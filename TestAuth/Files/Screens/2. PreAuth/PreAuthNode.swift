//
//  PreAuthNode.swift
//  TestAuth
//
//  Created by Denis Bezrukov on 20.07.17.
//  Copyright © 2017 Denis Bezrukov. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import Look

final class PreAuthNode: ASDisplayNode {
  
  fileprivate(set) lazy var publishClickAuth = PublishSubject<Void>()
  fileprivate lazy var authButton = ASButtonNode()
  
  override init() {
    super.init()
    automaticallyManagesSubnodes = true
    authButton.setTitle("Авторизация", with: nil, with: nil, for: .normal)
    authButton.addTarget(self,
                         action: #selector(clickAuthButton),
                         forControlEvents: .touchUpInside)
    look.apply(Style.preAuthNodeStyle)
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASCenterLayoutSpec.init(centeringOptions: .XY, sizingOptions: .minimumXY, child: authButton)
  }
}

fileprivate extension PreAuthNode {
  
  @objc func clickAuthButton() {
    publishClickAuth.onNext()
  }
}

fileprivate extension Style {
  static var preAuthNodeStyle: Change<PreAuthNode> {
    return { (node: PreAuthNode) -> Void in
      node.backgroundColor = Palette.PreAuth.Node.background.color
      node.authButton.style.preferredSize = CGSize(width: 200, height: 200)
      node.authButton.borderColor = Palette.PreAuth.Node.border.color.cgColor
      node.authButton.borderWidth = 0.5
    }
  }
}
