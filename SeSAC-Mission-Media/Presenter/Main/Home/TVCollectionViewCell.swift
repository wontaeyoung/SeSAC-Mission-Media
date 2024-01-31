//
//  TVCollectionViewCell.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/31/24.
//

import UIKit
import SnapKit
import Kingfisher

final class TVCollectionViewCell: BaseCollectionViewCell {
  
  // MARK: - UI
  private let posterImageView = PosterImageView(frame: .zero)
  private let nameLabel = SecondaryLabel(text: nil)
  
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    contentView.addSubviews(posterImageView, nameLabel)
  }
  
  override func setConstraint() {
    posterImageView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
    }
    
    nameLabel.snp.makeConstraints {
      $0.top.equalTo(posterImageView.snp.bottom).offset(4)
      $0.horizontalEdges.bottom.equalToSuperview().inset(4)
      $0.height.equalTo(20)
    }
  }
  
  
  // MARK: - Method
  func setData(with data: TV) {
    let url = URL(string: APIKey.TMDB.imageRequestPath + data.posterURL)
    self.posterImageView.kf.setImage(with: url, placeholder: UIImage.actions)
    self.nameLabel.text = data.name
  }
}

