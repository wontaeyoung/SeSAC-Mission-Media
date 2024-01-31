//
//  SearchTableViewCell.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/31/24.
//

import UIKit
import SnapKit

final class SearchTableViewCell: BaseTableViewCell {
  
  // MARK: - UI
  private let posterImageView = PosterImageView(frame: .zero)
  private let titleLabel = PrimaryLabel(text: nil)
  private let overviewLabel = SecondaryLabel(text: nil).configured {
    $0.numberOfLines = 5
  }
  
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    contentView.addSubviews(posterImageView, titleLabel, overviewLabel)
  }
  
  override func setConstraint() {
    posterImageView.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview().inset(8)
      $0.height.equalTo(160)
      $0.width.equalTo(posterImageView.snp.height).multipliedBy(0.75)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.trailing.equalToSuperview().inset(16)
      $0.leading.equalTo(posterImageView.snp.trailing).offset(8)
      $0.height.equalTo(20)
    }
    
    overviewLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(16)
      $0.leading.equalTo(posterImageView.snp.trailing).offset(8)
      $0.trailing.equalToSuperview().inset(8)
      $0.bottom.lessThanOrEqualToSuperview().inset(8)
    }
  }
  
  
  // MARK: - Method
  func setData(data: TV) {
    posterImageView.kf.setImage(with: URL(string: APIKey.TMDB.imageRequestPath + data.posterURL))
    titleLabel.text = data.name
    overviewLabel.text = data.overview
  }
}

#Preview {
  SearchTableViewCell()
}
