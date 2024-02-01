//
//  TertiaryLabel.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/1/24.
//

import UIKit

final class TertiaryLabel: UILabel {
  
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
    self.font = .systemFont(ofSize: 13, weight: .semibold)
    self.textColor = .label
    self.textAlignment = .left
  }
}
