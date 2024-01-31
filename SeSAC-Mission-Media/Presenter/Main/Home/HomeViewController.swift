//
//  HomeViewController.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

import UIKit
import SnapKit

enum HomeTVCollection: Int, CaseIterable {
  
  case trend = 0
  case topRated
  case popular
  
  var title: String {
    switch self {
      case .trend:
        return "트렌디한 TV 프로그램"
        
      case .topRated:
        return "별점이 높은 TV 프로그램"
        
      case .popular:
        return "인기있는 TV 프로그램"
        
    }
  }
  
  var tag: Int {
    return self.rawValue
  }
}

final class HomeViewController: BaseViewController {
  
  
  // MARK: - UI
  private lazy var tvTableView = UITableView().configured {
    $0.delegate = self
    $0.dataSource = self
    $0.register(TVTableViewCell.self, forCellReuseIdentifier: TVTableViewCell.identifier)
  }
  
  // MARK: - Property
  private var tvListDictionary: [HomeTVCollection: [TV]] = [:] {
    didSet {
      tvTableView.reloadData()
    }
  }
  
  
  // MARK: - Initializer
  
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubview(tvTableView)
  }
  
  override func setAttribute() {
    HomeTVCollection.allCases.forEach { collection in
      RouterManager.shared.callTVRequest(collection: collection) { models in
        self.tvListDictionary[collection] = models
      }
    }
  }
  
  override func setConstraint() {
    tvTableView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  
  // MARK: - Method
}

extension HomeViewController: TableControllable {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return HomeTVCollection.allCases.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TVTableViewCell.identifier, for: indexPath) as! TVTableViewCell
    
    guard let collection = HomeTVCollection(rawValue: indexPath.row) else {
      return cell
    }
    
    cell.setDelegate(with: self)
    cell.setData(tvCollection: collection)
    // 이거 외부에서 주입하면 reload 연산량이 올라가서 비효율적인지 확인 필요함
    cell.setCollectionLayout(with: makeCollectionLayout())
    cell.reload()
    
    return cell
  }
}

extension HomeViewController: CollectionControllable {
  func makeCollectionLayout() -> UICollectionViewFlowLayout {
    return UICollectionViewFlowLayout().configured {
      $0.itemSize = .init(width: 120, height: 160)
      $0.minimumLineSpacing = 10
      $0.minimumInteritemSpacing = 0
      $0.scrollDirection = .horizontal
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let collection = HomeTVCollection(rawValue: collectionView.tag) else {
      return 0
    }
    
    return tvListDictionary[collection]?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TVCollectionViewCell.identifier, for: indexPath) as! TVCollectionViewCell
    
    guard 
      let collection = HomeTVCollection(rawValue: collectionView.tag),
      let data = tvListDictionary[collection]?[indexPath.row]
    else {
      return cell
    }
    
    cell.setData(with: data)
    
    return cell
  }
}
