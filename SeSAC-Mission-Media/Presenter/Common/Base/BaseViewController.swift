//
//  BaseViewController.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

import UIKit

class BaseViewController: UIViewController {
  
  // MARK: - Property
  var finishableKeyboardEditing: Bool
  
  
  // MARK: - Initializer
  init(finishableKeyboardEditing: Bool = false) {
    self.finishableKeyboardEditing = finishableKeyboardEditing
    
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Life Cycle
  func setHierarchy() { }
  func setAttribute() { }
  func setConstraint() { }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    
    setHierarchy()
    setAttribute()
    setConstraint()
    makeViewFinishableEditing()
  }
  
  
  // MARK: - Method
  private func makeViewFinishableEditing() {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
    
    view.addGestureRecognizer(gesture)
  }
  
  @objc private func viewDidTap(_ sender: UIGestureRecognizer) {
    if finishableKeyboardEditing {
      view.endEditing(true)
    } else {
      view.removeGestureRecognizer(sender)
    }
  }
}
