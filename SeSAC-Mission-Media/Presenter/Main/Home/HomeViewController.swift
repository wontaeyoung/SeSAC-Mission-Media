//
//  HomeViewController.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

import UIKit
import SnapKit

enum TVCollection: Int, CaseIterable {
  
  case trend = 0
  case topRated
  case popular
  case recommend
  case cast
  
  static let homeCollections: [Self] = [.trend, .topRated, .popular]
  static let searchCollections: [Self] = [.recommend, .cast]
  
  var title: String {
    switch self {
      case .trend:
        return "트렌디한 TV 프로그램"
        
      case .topRated:
        return "별점이 높은 TV 프로그램"
        
      case .popular:
        return "인기있는 TV 프로그램"
        
      case .recommend:
        return "비슷한 TV 프로그램"
        
      case .cast:
        return "출연자"
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
  private var tvListDictionary: [TVCollection: [TV]] = [:] {
    didSet {
      tvTableView.reloadData()
    }
  }
  
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubview(tvTableView)
  }
  
  override func setAttribute() {
    
    hideBackTitle()
    navigationTitle(with: "홈")
    
    TVCollection.homeCollections.forEach { collection in
      switch collection {
        case .trend:
          APIManager.shared.callRequest(
            responseType: TVResponseDTO.self,
            router: TrendRouter.trendTV(timeWindow: .week)
          ) { response in
            
            self.tvListDictionary[collection] = response.results
          }
          
        case .topRated:
          APIManager.shared.callRequest(
            responseType: TVResponseDTO.self,
            router: TVRouter.topRated
          ) { response in
            
            self.tvListDictionary[collection] = response.results
          }
          
        case .popular:
          APIManager.shared.callRequest(
            responseType: TVResponseDTO.self,
            router: TVRouter.popular
          ) { response in
            
            self.tvListDictionary[collection] = response.results
          }
          
        default: break
      }
    }
  }
  
  override func setConstraint() {
    tvTableView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

extension HomeViewController: TableControllable {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return TVCollection.homeCollections.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TVTableViewCell.identifier, for: indexPath) as! TVTableViewCell
    
    guard let collection = TVCollection(rawValue: indexPath.row) else {
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
      $0.itemSize = .init(width: 120, height: Constant.UI.collectionHeight)
      $0.minimumLineSpacing = 10
      $0.minimumInteritemSpacing = 0
      $0.scrollDirection = .horizontal
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let collection = TVCollection(rawValue: collectionView.tag) else {
      return 0
    }
    
    return tvListDictionary[collection]?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TVCollectionViewCell.identifier, for: indexPath) as! TVCollectionViewCell
    
    guard 
      let collection = TVCollection(rawValue: collectionView.tag),
      let data = tvListDictionary[collection]?[indexPath.row]
    else {
      return cell
    }
    
    cell.setData(with: data)
    
    return cell
  }
}
