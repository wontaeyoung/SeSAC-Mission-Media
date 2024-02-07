//
//  ProfileViewController.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/7/24.
//

import UIKit

enum ProfileItem: String, CaseIterable {
  case name = "이름"
  case nickname = "사용자 이름"
  case gender = "성별 대명사"
  case intro = "소개"
  case link = "링크"
  
  var title: String {
    return self.rawValue
  }
}

final class ProfileViewController: BaseViewController {
  
  // MARK: - UI
  private let profileView = ProfileView()
  
  
  // MARK: - Property
  weak var coordinator: ProfileCoordinator?
  private var profileItemDict: [ProfileItem: String] = [:]
  
  // MARK: - Life Cycle
  override func loadView() {
    self.view = profileView
  }
  
  override func setAttribute() {
    self.profileView.setDelegate(with: self)
    ProfileItem.allCases.forEach {
      profileItemDict.updateValue("", forKey: $0)
    }
  }
}

extension ProfileViewController: TableControllable {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ProfileItem.allCases.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = ProfileItem.allCases[indexPath.row]
    
    let cell = tableView.dequeueReusableCell(
      withIdentifier: ProfileItemTableViewCell.identifier,
      for: indexPath
    ) as! ProfileItemTableViewCell
    
    guard let content = profileItemDict[item] else { return cell }
    
    cell.setData(with: item.title, content: content)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = ProfileItem.allCases[indexPath.row]
    
    guard let text = profileItemDict[item] else { return }
    
    coordinator?.showUpdateProfileViewController(profileItem: item, currentText: text) { [weak self] in
      guard let self else { return }
      
      profileItemDict.updateValue($0, forKey: item)
      tableView.reloadRows(at: [indexPath], with: .automatic)
      coordinator?.pop()
    }
  }
}
