//
//  ActorSummaryView.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/6/24.
//

import UIKit
import SnapKit

final class ActorSummaryView: BaseView {
  
  // MARK: - UI
  private let profileImageView = PosterImageView(samplingHeight: Constant.UI.collectionHeight)
  private let nameLabel = PrimaryLabel().configured { $0.numberOfLines = 2 }
  private let birthdayLabel = SecondaryLabel()
  private let biographyLabel = SecondaryLabel().configured { $0.numberOfLines = 0 }
  
  
  // MARK: - Property
  private let commonVerticalPadding = 12
  
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    addSubviews(
      profileImageView,
      nameLabel,
      birthdayLabel,
      biographyLabel
    )
  }
  
  override func setConstraint() {
    self.snp.makeConstraints {
      $0.width.equalTo(UIScreen.main.bounds.width)
      $0.height.lessThanOrEqualTo(UIScreen.main.bounds.height * 0.5)
    }
    
    profileImageView.snp.makeConstraints {
      $0.top.leading.equalToSuperview().inset(commonVerticalPadding)
      $0.width.equalTo(profileImageView.samplingSize.width)
      $0.height.equalTo(profileImageView.samplingSize.height)
    }
    
    nameLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(commonVerticalPadding)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
      $0.trailing.equalToSuperview().offset(-16)
    }
    
    birthdayLabel.snp.makeConstraints {
      $0.top.equalTo(nameLabel.snp.bottom).offset(commonVerticalPadding)
      $0.horizontalEdges.equalTo(nameLabel)
    }
    
    biographyLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView.snp.bottom).offset(commonVerticalPadding)
      $0.horizontalEdges.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Method
  func setData(with data: Actor) {
    profileImageView.setImage(
      from: data.profileURL,
      with: profileImageView.samplingSize
    )
    
    nameLabel.text = data.name.replaceEmptyByDash
    
    guard let bioInfo = data.bioInfo else { return }
    
    birthdayLabel.text = bioInfo.birthday
    biographyLabel.text = bioInfo.biography.replaceEmptyByDash
  }
}

