//
//  UIView.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/31/24.
//

import UIKit

extension UIView {
  func addSubviews(_ view: UIView...) {
    view.forEach { self.addSubview($0) }
  }
}
