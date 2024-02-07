//
//  UpdateProfileViewController.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/7/24.
//

import UIKit
import SnapKit

final class UpdateProfileViewController: BaseViewController {
  
  // MARK: - UI
  private let placeholderLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 13)
    $0.textColor = .secondaryLabel
    $0.textAlignment = .left
  }
  
  private let inputField = UITextField().configured {
    $0.autocapitalizationType = .none
    $0.autocorrectionType = .no
    $0.spellCheckingType = .no
  }
  
  private lazy var applyButton = UIButton().configured { button in
    button.configuration = .filled().configured {
      $0.title = "수정하기"
      $0.baseForegroundColor = .black
      $0.buttonSize = .large
      $0.cornerStyle = .medium
    }
    
    button.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
  }
  
  // MARK: - Property
  private let applyAction: (String) -> Void
  
  // MARK: - Initializer
  init(profileItem: ProfileItem, currentText: String, applyAction: @escaping (String) -> Void) {
    self.placeholderLabel.text = profileItem.title
    self.inputField.placeholder = profileItem.title
    self.inputField.text = currentText
    self.applyAction = applyAction
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(placeholderLabel, inputField, applyButton)
  }
  
  override func setConstraint() {
    placeholderLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
      $0.horizontalEdges.equalToSuperview().inset(16)
      $0.height.equalTo(20)
    }
    
    inputField.snp.makeConstraints {
      $0.top.equalTo(placeholderLabel.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview().inset(16)
    }
    
    applyButton.snp.makeConstraints {
      $0.top.equalTo(inputField.snp.bottom).offset(16)
      $0.horizontalEdges.equalToSuperview().inset(16)
    }
  }
  
  @objc private func applyButtonTapped() {
    guard let text = inputField.text else { return }
    
    self.applyAction(text)
  }
}

