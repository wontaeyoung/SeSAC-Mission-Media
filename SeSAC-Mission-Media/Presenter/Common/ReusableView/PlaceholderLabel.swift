//
//  PlaceholderLabel.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/7/24.
//

import UIKit

final class PlaceholderLabel: UILabel {
  
  // MARK: - Property
  var placeholder: String?
  private var isEmpty: Bool {
    return self.text?.isEmpty ?? true
  }
  
  private var tempText: String?
  override var text: String? {
    didSet {
      updateTextVisibility()
    }
  }
  
  // MARK: - Initializer
  init(placeholder: String?, font: UIFont = .systemFont(ofSize: 13, weight: .semibold)) {
    self.placeholder = placeholder
    super.init(frame: .zero)
    
    configureView(font: font)
    updateTextVisibility()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Method
  private func configureView(font: UIFont) {
    self.font = font
    self.textAlignment = .left
  }
  
  func updateTextVisibility() {
    guard let placeholder else { return }
    guard self.text != placeholder else { return }
    guard self.text != self.tempText else { return }
    
    self.textColor = isEmpty ? .secondaryLabel : .label
    self.tempText = self.text
    self.text = isEmpty ? placeholder : self.text
  }
}
