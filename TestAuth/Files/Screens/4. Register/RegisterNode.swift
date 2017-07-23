//
//  RegisterNode.swift
//  TestAuth
//
//  Created by Denis Bezrukov on 23.07.17.
//  Copyright © 2017 Denis Bezrukov. All rights reserved.
//

import AsyncDisplayKit
import RxSwift

final class RegisterNode: ASDisplayNode {
  
  fileprivate(set) lazy var publishDismissTap: PublishSubject<Void> = PublishSubject()
  fileprivate(set) lazy var dismissButton: ASButtonNode = ASButtonNode()
  
  required override init() {
    super.init()
    backgroundColor = .white
    automaticallyManagesSubnodes = true
  
    dismissButton.borderWidth = 1.0
    dismissButton.borderColor = UIColor.black.cgColor
    dismissButton.style.preferredSize = CGSize(width: 150, height: 150)
    dismissButton.setAttributedTitle(NSAttributedString.init(string: "Закрыть"), for: .normal)
    dismissButton.addTarget(self, action: #selector(dismiss), forControlEvents: .touchUpInside)
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: dismissButton)
  }
}

fileprivate extension RegisterNode {
  
  @objc func dismiss() {
    publishDismissTap.onNext()
  }
}
