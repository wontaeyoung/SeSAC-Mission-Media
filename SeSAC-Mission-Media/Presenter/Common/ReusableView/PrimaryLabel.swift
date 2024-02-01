//
//  PrimaryLabel.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/31/24.
//

import UIKit

final class PrimaryLabel: UILabel {
  
  init(text: String? = nil) {
    super.init(frame: .zero)
    
    configureView(text: text)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureView(text: String?) {
    self.text = text
    self.font = .systemFont(ofSize: 17, weight: .black)
    self.textColor = .label
    self.textAlignment = .left
  }
}
