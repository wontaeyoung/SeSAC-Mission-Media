//
//  PosterImageView.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/31/24.
//

import UIKit

final class PosterImageView: UIImageView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureView()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureView() {
    
    contentMode = .scaleAspectFill
    layer.cornerRadius = 12
    clipsToBounds = true
  }
}

