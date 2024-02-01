//
//  PosterImageView.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/31/24.
//

import UIKit
import Kingfisher

final class PosterImageView: UIImageView {
  
  var samplingHeight: CGFloat?
  
  var samplingSize: CGSize {
    guard let samplingHeight else { return self.frame.size }
    
    return CGSize(width: samplingHeight * 0.75, height: samplingHeight)
  }
  
  init(samplingHeight: CGFloat?) {
    super.init(frame: .zero)
    
    self.samplingHeight = samplingHeight
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

