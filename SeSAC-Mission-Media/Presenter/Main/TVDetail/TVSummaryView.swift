//
//  TVSummaryView.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/1/24.
//

import UIKit
import SnapKit

final class TVSummaryView: BaseView {
  
  
  // MARK: - UI
  private let posterImageView = PosterImageView(samplingHeight: Constant.UI.collectionHeight)
  private let backgroundImageView = UIImageView().configured {
    $0.alpha = 0.2
    $0.contentMode = .scaleAspectFill
  }
  private let titleLabel = PrimaryLabel().configured { $0.numberOfLines = 2 }
  private let startDateLabel = SecondaryLabel()
  private let genreLabel = SecondaryLabel().configured { $0.numberOfLines = 2 }
  private let runningTimeLabel = SecondaryLabel()
  private let broadcasterLogoImageView = UIImageView().configured { $0.contentMode = .scaleAspectFit }
  private let overviewLabel = SecondaryLabel().configured { $0.numberOfLines = 0 }
  
  
  // MARK: - Property
  private let commonVerticalPadding = 12
  
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    addSubviews(
      backgroundImageView,
      posterImageView,
      titleLabel,
      startDateLabel,
      genreLabel,
      runningTimeLabel,
      broadcasterLogoImageView,
      overviewLabel
    )
  }
  
  override func setConstraint() {
    self.snp.makeConstraints {
      $0.width.equalTo(UIScreen.main.bounds.width)
      $0.height.lessThanOrEqualTo(UIScreen.main.bounds.height * 0.5)
    }
    
    backgroundImageView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
      $0.bottom.equalTo(overviewLabel.snp.bottom).offset(commonVerticalPadding)
    }
    
    posterImageView.snp.makeConstraints {
      $0.top.leading.equalToSuperview().inset(commonVerticalPadding)
      $0.width.equalTo(posterImageView.samplingSize.width)
      $0.height.equalTo(posterImageView.samplingSize.height)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(commonVerticalPadding)
      $0.leading.equalTo(posterImageView.snp.trailing).offset(16)
      $0.trailing.equalToSuperview().offset(-16)
    }
    
    startDateLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(commonVerticalPadding)
      $0.horizontalEdges.equalTo(titleLabel)
    }
    
    genreLabel.snp.makeConstraints {
      $0.top.equalTo(startDateLabel.snp.bottom).offset(commonVerticalPadding)
      $0.horizontalEdges.equalTo(titleLabel)
    }
    
    runningTimeLabel.snp.makeConstraints {
      $0.top.equalTo(genreLabel.snp.bottom).offset(commonVerticalPadding)
      $0.horizontalEdges.equalTo(titleLabel)
    }
    
    broadcasterLogoImageView.snp.makeConstraints {
      $0.top.equalTo(runningTimeLabel.snp.bottom).offset(commonVerticalPadding)
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.trailing.lessThanOrEqualTo(titleLabel)
      $0.height.equalTo(20)
      $0.width.equalTo(broadcasterLogoImageView.snp.height).multipliedBy(2.5)
    }
    
    overviewLabel.snp.makeConstraints {
      $0.top.equalTo(posterImageView.snp.bottom).offset(commonVerticalPadding)
      $0.horizontalEdges.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Method
  func setData(with data: MediaDetail) {
    backgroundImageView.setImage(
      from: data.backdropURL,
      with: CGSize(width: UIScreen.main.bounds.width, height: 300)
    )
    
    posterImageView.setImage(
      from: data.posterURL,
      with: posterImageView.samplingSize
    )
    
    broadcasterLogoImageView.setImage(
      from: data.companyLogoURL,
      with: CGSize(width: 20 * 2.5, height: 20)
    )
    
    titleLabel.text = data.name.replaceEmptyByDash
    startDateLabel.text = data.startDate
    genreLabel.text = data.genres.joined(separator: " · ").replaceEmptyByDash
    runningTimeLabel.text = data.runningTime.replaceEmptyByDash + " 분"
    overviewLabel.text = data.overview.replaceEmptyByDash
  }
}
