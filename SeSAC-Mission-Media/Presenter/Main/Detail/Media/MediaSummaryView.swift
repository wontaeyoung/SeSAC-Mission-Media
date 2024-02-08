//
//  MediaSummaryView.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/1/24.
//

import UIKit
import SnapKit

final class MediaSummaryView: BaseView {
  
  
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
  private let broadcasterLogoImageView = UIImageView().configured {
    $0.contentMode = .scaleAspectFit
  }
  private let overviewLabel = SecondaryLabel().configured { $0.numberOfLines = 0 }
  private let showTrailerButton = UIButton().configured { button in
    button.configuration = .gray().configured {
      $0.title = "예고편 보기"
      $0.image = UIImage(systemName: "play.tv")
      $0.imagePadding = 10
      $0.buttonSize = .medium
      $0.cornerStyle = .medium
    }
  }
  
  
  // MARK: - Property
  private let commonVerticalPadding = 12
  private let showTrailerAction: () -> Void
  
  
  // MARK: - Initializer
  init(showTrailerAction: @escaping () -> Void) {
    self.showTrailerAction = showTrailerAction
    
    super.init(frame: .zero)
  }
  
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    addSubviews(
      backgroundImageView,
      posterImageView,
//      titleLabel,
      startDateLabel,
      genreLabel,
      runningTimeLabel,
      broadcasterLogoImageView,
      showTrailerButton,
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
    
//    titleLabel.snp.makeConstraints {
//      $0.top.equalToSuperview().offset(commonVerticalPadding)
//      $0.leading.equalTo(posterImageView.snp.trailing).offset(16)
//      $0.trailing.equalToSuperview().offset(-16)
//    }
    
    startDateLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(commonVerticalPadding)
      $0.leading.equalTo(posterImageView.snp.trailing).offset(16)
      $0.trailing.equalToSuperview().offset(-16)
    }
    
    genreLabel.snp.makeConstraints {
      $0.top.equalTo(startDateLabel.snp.bottom).offset(commonVerticalPadding)
      $0.horizontalEdges.equalTo(startDateLabel)
    }
    
    runningTimeLabel.snp.makeConstraints {
      $0.top.equalTo(genreLabel.snp.bottom).offset(commonVerticalPadding)
      $0.horizontalEdges.equalTo(startDateLabel)
    }
    
    broadcasterLogoImageView.snp.makeConstraints {
      $0.top.equalTo(runningTimeLabel.snp.bottom).offset(commonVerticalPadding)
      $0.leading.equalTo(startDateLabel.snp.leading)
      $0.trailing.lessThanOrEqualTo(startDateLabel)
      $0.height.equalTo(20)
      $0.width.equalTo(broadcasterLogoImageView.snp.height).multipliedBy(2.5)
    }
    
    showTrailerButton.snp.makeConstraints {
      $0.top.greaterThanOrEqualTo(broadcasterLogoImageView.snp.bottom).offset(commonVerticalPadding)
      $0.horizontalEdges.equalTo(startDateLabel)
      $0.bottom.equalTo(posterImageView.snp.bottom)
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
    
    startDateLabel.text = data.startDate
    genreLabel.text = data.genres.joined(separator: " · ").replaceEmptyByDash
    runningTimeLabel.text = data.runningTime.replaceEmptyByDash + " 분"
    overviewLabel.text = data.overview.replaceEmptyByDash
    showTrailerButton.addTarget(self, action: #selector(showTrailerButtonTapped), for: .touchUpInside)
  }
  
  @objc private func showTrailerButtonTapped() {
    showTrailerAction()
  }
}
