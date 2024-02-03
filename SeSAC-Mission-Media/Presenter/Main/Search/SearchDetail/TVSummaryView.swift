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
  private let posterImageView = PosterImageView(samplingHeight: 180)
  private let backgroundImageView = UIImageView().configured {
    $0.alpha = 0.3
    $0.contentMode = .scaleAspectFill
  }
  private let titleLabel = PrimaryLabel()
  private let startDateLabel = PrimaryLabel()
  private let genreLabel = PrimaryLabel()
  private let runningTimeLabel = PrimaryLabel()
  private let broadcasterLabel = SecondaryLabel()
  private let broadcasterLogoImageView = UIImageView().configured { $0.contentMode = .scaleAspectFit }
  private let overviewLabel = TertiaryLabel().configured { $0.numberOfLines = 3 }
  
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    addSubviews(backgroundImageView, posterImageView, titleLabel, startDateLabel, genreLabel, runningTimeLabel, broadcasterLabel, broadcasterLogoImageView, overviewLabel)
  }
  
  override func setConstraint() {
    self.snp.makeConstraints {
      $0.width.equalTo(UIScreen.main.bounds.width)
    }
    
    backgroundImageView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
      $0.bottom.equalTo(overviewLabel.snp.bottom).offset(16)
    }
    
    posterImageView.snp.makeConstraints {
      $0.top.leading.equalToSuperview().inset(16)
      $0.width.equalTo(posterImageView.samplingSize.width)
      $0.height.equalTo(posterImageView.samplingSize.height)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.leading.equalTo(posterImageView.snp.trailing).offset(16)
      $0.trailing.equalToSuperview().offset(-16)
    }
    
    startDateLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(16)
      $0.horizontalEdges.equalTo(titleLabel)
    }
    
    genreLabel.snp.makeConstraints {
      $0.top.equalTo(startDateLabel.snp.bottom).offset(16)
      $0.horizontalEdges.equalTo(titleLabel)
    }
    
    runningTimeLabel.snp.makeConstraints {
      $0.top.equalTo(genreLabel.snp.bottom).offset(16)
      $0.horizontalEdges.equalTo(titleLabel)
    }
    
    broadcasterLabel.snp.makeConstraints {
      $0.top.equalTo(runningTimeLabel.snp.bottom).offset(16)
      $0.leading.equalTo(titleLabel)
    }
    
    broadcasterLogoImageView.snp.makeConstraints {
      $0.centerY.equalTo(broadcasterLabel)
      $0.leading.equalTo(broadcasterLabel.snp.trailing).offset(16)
      $0.trailing.lessThanOrEqualTo(titleLabel)
      $0.height.equalTo(20)
      $0.width.equalTo(broadcasterLogoImageView.snp.height).multipliedBy(2)
    }
    
    overviewLabel.snp.makeConstraints {
      $0.top.equalTo(posterImageView.snp.bottom).offset(16)
      $0.horizontalEdges.equalToSuperview().inset(16)
    }
  }
  
  // MARK: - Method
  func setData(with data: TVDetail) {
    backgroundImageView.setImage(
      from: URL(string: APIKey.TMDB.imageRequestPath + data.backdropURL),
      with: CGSize(width: UIScreen.main.bounds.width, height: 300)
    )
    
    posterImageView.setImage(
      from: URL(string: APIKey.TMDB.imageRequestPath + data.posterURL),
      with: posterImageView.samplingSize
    )
    
    broadcasterLogoImageView.setImage(
      from: URL(string: APIKey.TMDB.imageRequestPath + data.broadcasterLogo),
      with: CGSize(width: 100, height: 50)
    )
    
    titleLabel.text = data.name.replacedEmptyToDash
    startDateLabel.text = data.startDate
    genreLabel.text = data.genres.joined(separator: " · ").replacedEmptyToDash
    runningTimeLabel.text = data.runningTime.replacedEmptyToDash + " 분"
    overviewLabel.text = data.overview.replacedEmptyToDash
  }
}
