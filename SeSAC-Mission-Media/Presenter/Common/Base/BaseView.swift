//
//  BaseView.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/1/24.
//

import UIKit

class BaseView: UIView {
  
  // MARK: - Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = .systemBackground
    
    setHierarchy()
    setAttribute()
    setConstraint()
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError("init(coder:) BaseView")
  }
  
  // MARK: - Method
  func setHierarchy() { }
  func setAttribute() { }
  func setConstraint() { }
}
