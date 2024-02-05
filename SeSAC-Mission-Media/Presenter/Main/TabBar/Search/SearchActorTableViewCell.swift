//
//  SearchActorTableViewCell.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/5/24.
//

import UIKit
import SnapKit

final class SearchActorTableViewCell: BaseTableViewCell {
  
  // MARK: - UI
  private let profileImageView = PosterImageView(samplingHeight: 160)
  private let nameLabel = PrimaryLabel()
  
  
  // MARK: - Initializer
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.selectionStyle = .none
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    contentView.addSubviews(profileImageView, nameLabel)
  }
  
  override func setConstraint() {
    profileImageView.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview().inset(8)
      $0.height.equalTo(160)
      $0.width.equalTo(profileImageView.snp.height).multipliedBy(0.75)
    }
    
    nameLabel.snp.makeConstraints {
      $0.top.trailing.equalToSuperview().inset(16)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
      $0.height.equalTo(20)
    }
  }
  
  
  // MARK: - Method
  func setData(with data: Actor) {
    profileImageView.setImage(from: data.profileURL, with: profileImageView.samplingSize)
    nameLabel.text = data.name
  }
}

