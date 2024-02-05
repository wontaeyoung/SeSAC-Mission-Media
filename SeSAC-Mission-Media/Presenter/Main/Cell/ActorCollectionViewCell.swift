//
//  ActorCollectionViewCell.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/4/24.
//

import UIKit
import SnapKit
import Kingfisher

/// 출연진 이미지와 본명, 배역 이름을 표시하는 컬렉션 셀
final class ActorCollectionViewCell: BaseCollectionViewCell {
  
  // MARK: - UI
  private let profileImageView = PosterImageView(samplingHeight: 160)
  private let nameLabel = SecondaryLabel()
  private let characterLabel = TertiaryLabel().configured {
    $0.textColor = .systemGray
  }
  
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    contentView.addSubviews(
      profileImageView,
      nameLabel,
      characterLabel
    )
  }
  
  override func setConstraint() {
    profileImageView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
    }
    
    nameLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView.snp.bottom).offset(4)
      $0.horizontalEdges.equalToSuperview().inset(4)
      $0.height.equalTo(20)
    }
    
    characterLabel.snp.makeConstraints {
      $0.top.equalTo(nameLabel.snp.bottom).offset(4)
      $0.horizontalEdges.bottom.equalToSuperview().inset(4)
      $0.height.equalTo(20)
    }
  }
  
  
  // MARK: - Method
  func setData(with data: Actor) {
    self.profileImageView.setImage(from: data.profileURL, with: profileImageView.samplingSize)
    self.nameLabel.text = data.name.replaceEmptyByDash
    self.characterLabel.text = data.character.replaceEmptyByDash
  }
}
