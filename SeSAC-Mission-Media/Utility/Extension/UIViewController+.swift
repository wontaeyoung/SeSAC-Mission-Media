//
//  UIViewController+.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/3/24.
//

import UIKit

extension UIViewController {
  func hideBackTitle() {
    self.navigationItem.backButtonTitle = ""
  }
  
  func navigationTitle(with title: String) {
    self.navigationItem.title = title
  }
}
