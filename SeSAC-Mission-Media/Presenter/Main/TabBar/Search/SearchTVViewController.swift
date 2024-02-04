//
//  SearchTVViewController.swift
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
final class SearchTVViewController: BaseViewController {
  
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
  
  private lazy var resultTableView = UITableView().configured {
    $0.delegate = self
    $0.dataSource = self
    $0.register(SearchTVTableViewCell.self, forCellReuseIdentifier: SearchTVTableViewCell.identifier)
  }
  
  
  // MARK: - Property
  weak var coordinator: SearchCoordinator?
  private var tvList: [TV] = [] {
    didSet {
      resultTableView.reloadData()
    }
  }
  
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(searchBar, resultTableView)
  }
  
  override func setAttribute() {
    hideBackTitle()
    navigationTitle(with: "검색")
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
}

extension SearchTVViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let text = searchBar.text else { return }
    
    view.endEditing(true)
    
    APIManager.shared.callRequest(
      responseType: TVResponseDTO.self,
      router: SearchRouter.tv(query: text)
    ) { response in
      
      self.tvList = response.results
      searchBar.text?.removeAll()
    }
  }
}

extension SearchTVViewController: TableControllable {
  
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
