//
//  SearchTVTableViewCell.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/31/24.
//

import UIKit
import SnapKit

final class SearchTVTableViewCell: BaseTableViewCell {
  
  // MARK: - UI
  private let posterImageView = PosterImageView(samplingHeight: 160)
  private let titleLabel = PrimaryLabel()
  private let overviewLabel = SecondaryLabel().configured {
    $0.numberOfLines = 5
  }
  
  
  // MARK: - Initializer
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.selectionStyle = .none
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
      $0.leading.equalTo(posterImageView.snp.trailing).offset(16)
      $0.height.equalTo(20)
    }
    
    overviewLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(16)
      $0.leading.equalTo(posterImageView.snp.trailing).offset(16)
      $0.trailing.equalToSuperview().inset(16)
      $0.bottom.lessThanOrEqualToSuperview().inset(16)
    }
  }
  
  
  // MARK: - Method
  func setData(with data: Media) {
    posterImageView.setImage(from: data.posterURL, with: posterImageView.samplingSize)
    titleLabel.text = data.title
    overviewLabel.text = data.overview
  }
}
