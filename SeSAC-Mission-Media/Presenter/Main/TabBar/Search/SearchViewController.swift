//
//  SearchViewController.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/31/24.
//

import UIKit
import SnapKit

// TODO: -
/// 검색 결과 페이지네이션 적용
/// 워크쓰루 뷰 구현
/// Cast Detail API 연결해서 인물 탭하면 디테일 뷰 연결
/// 비슷한 TV 프로그램, 출연진 데이터 없을 때 hidden 처리
final class SearchViewController: BaseViewController {
  
  // MARK: - UI
  private lazy var searchBar = UISearchBar().configured {
    $0.placeholder = "TV 프로그램 이름을 검색하세요"
    $0.barTintColor = .clear
    $0.barStyle = .black
    $0.tintColor = .label
    $0.searchTextField.textColor = .label
    $0.autocorrectionType = .no
    $0.autocapitalizationType = .none
    $0.spellCheckingType = .no
    $0.delegate = self
  }
  
  private lazy var searchMenu = UIMenu(children: [
    makeAction(with: .content),
    makeAction(with: .person)
  ])
  
  private lazy var resultTableView = UITableView().configured {
    $0.delegate = self
    $0.dataSource = self
    $0.register(SearchTVTableViewCell.self, forCellReuseIdentifier: SearchTVTableViewCell.identifier)
  }
  
  
  // MARK: - Property
  weak var coordinator: SearchCoordinator?
  private let debouncer = Debouncer(delay: 0.5)
  private var tvList: [TV] = [] {
    didSet {
      resultTableView.reloadData()
    }
  }
  
  private var currentSearchMenu: SearchMenu = .content {
    didSet {
      updateNavigationTitle(with: currentSearchMenu)
      updateSearchBarPlaceholder(with: currentSearchMenu)
    }
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(searchBar, resultTableView)
  }
  
  override func setAttribute() {
    hideBackTitle()
    navigationTitle(with: currentSearchMenu.title)
    setSearchMenuBarButton()
  }
  
  override func setConstraint() {
    searchBar.snp.makeConstraints {
      $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
      $0.height.equalTo(44)
    }
    
    resultTableView.snp.makeConstraints {
      $0.top.equalTo(searchBar.snp.bottom).offset(8)
      $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  // MARK: - Method
  private func setSearchMenuBarButton() {
    let barButton = UIBarButtonItem(
      title: currentSearchMenu.title,
      image: UIImage(systemName: "ellipsis"),
      menu: searchMenu
    )
    
    navigationItem.setRightBarButton(barButton, animated: true)
  }
  
  private func updateNavigationTitle(with menu: SearchMenu) {
    navigationItem.title = menu.title
  }
  
  private func updateSearchBarPlaceholder(with menu: SearchMenu) {
    switch menu {
      case .content:
        searchBar.placeholder = "프로그램 이름을 검색하세요"
        
      case .person:
        searchBar.placeholder = "배우 이름을 검색하세요"
    }
  }
}

extension SearchViewController {
  
  enum SearchMenu: CaseIterable {
    
    case content
    case person
    
    var title: String {
      switch self {
        case .content:
          return "작품"
          
        case .person:
          return "배우"
      }
    }
    
    var image: UIImage? {
      switch self {
        case .content:
          return UIImage(systemName: "play.tv.fill")
          
        case .person:
          return UIImage(systemName: "person.fill")
      }
    }
  }
  
  func makeAction(with menu: SearchMenu) -> UIAction {
    return UIAction(title: menu.title, image: menu.image) { action in
      self.currentSearchMenu = menu
    }
  }
}

extension SearchViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    view.endEditing(true)
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    debouncer.excute(in: .global) {
      APIManager.shared.callRequest(
        responseType: TVResponseDTO.self,
        router: SearchRouter.tv(query: searchText)
      ) { response in
        
        self.tvList = response.results
      }
    }
  }
}

extension SearchViewController: TableControllable {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tvList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: SearchTVTableViewCell.identifier,
      for: indexPath
    ) as! SearchTVTableViewCell
    
    let data = tvList[indexPath.row]
    cell.setData(with: data)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let data = tvList[indexPath.row]
    
    coordinator?.combineTVDetailFlow(with: data.id)
    view.endEditing(true)
  }
}
