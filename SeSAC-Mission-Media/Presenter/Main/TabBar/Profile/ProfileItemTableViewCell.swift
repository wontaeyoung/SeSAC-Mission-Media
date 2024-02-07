//
//  ProfileItemTableViewCell.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/7/24.
//

import UIKit
import SnapKit

final class ProfileItemTableViewCell: BaseTableViewCell {
  
  // MARK: - UI
  private let itemTitleLabel = PrimaryLabel()
  private let itemContentLabel = PlaceholderLabel(placeholder: nil)
  
  
  // MARK: - Initializer
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    contentView.addSubviews(itemTitleLabel, itemContentLabel)
  }
  
  override func setConstraint() {
    itemTitleLabel.snp.makeConstraints {
      $0.leading.verticalEdges.equalToSuperview().inset(16)
      $0.width.equalTo(UIScreen.main.bounds.width * 0.2)
    }
    
    itemContentLabel.snp.makeConstraints {
      $0.centerY.equalTo(itemTitleLabel)
      $0.leading.equalTo(itemTitleLabel.snp.trailing).offset(24)
      $0.trailing.equalToSuperview().inset(16)
    }
  }
  
  
  // MARK: - Method
  func setData(with title: String, content: String) {
    self.itemTitleLabel.text = title
    self.itemContentLabel.placeholder = title
    self.itemContentLabel.text = content
    self.itemContentLabel.updateTextVisibility()
  }
}

