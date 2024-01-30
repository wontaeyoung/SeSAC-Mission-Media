//
//  BaseCollectionViewCell.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
  
  class var identifier: String {
    return self.description()
  }
  
  func setHierarchy() { }
  func setAttribute() { }
  func setConstraint() { }
  
  override init(frame: CGRect) {
    
    super.init(frame: frame)
    
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    
    setHierarchy()
    setAttribute()
    setConstraint()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
