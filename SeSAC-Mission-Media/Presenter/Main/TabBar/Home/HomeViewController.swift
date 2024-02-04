//
//  HomeViewController.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

import UIKit
import SnapKit

final class HomeViewController: BaseViewController {
  
  
  // MARK: - UI
  private lazy var tvTableView = UITableView().configured {
    $0.delegate = self
    $0.dataSource = self
    $0.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
  }
  
  // MARK: - Property
  weak var coordinator: HomeCoordinator?
  private var tvListDictionary: [Collection.Home: [TV]] = [:] {
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
    
    Collection.Home.allCases.forEach { collection in
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
    return Collection.Home.allCases.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let collection = Collection.Home.allCases[indexPath.row]
    
    let cell = tableView.dequeueReusableCell(
      withIdentifier: CollectionTableViewCell.identifier,
      for: indexPath
    ) as! CollectionTableViewCell
    cell.setDelegate(with: self)
    cell.setData(collection: collection)
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
    guard
      let collection = Collection.Home.allCases[at: collectionView.tag],
      let list = tvListDictionary[collection]
    else {
      return 0
    }
    
    return list.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: TVCollectionViewCell.identifier,
      for: indexPath
    ) as! TVCollectionViewCell
    
    guard
      let collection = Collection.Home.allCases[at: collectionView.tag],
      let list = tvListDictionary[collection],
      let data = list[at: indexPath.row]
    else {
      return cell
    }
    
    cell.setData(with: data)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard
      let collection = Collection.Home.allCases[at: collectionView.tag],
      let list = tvListDictionary[collection],
      let data = list[at: indexPath.row]
    else {
      return
    }
    
    coordinator?.combineTVDetailFlow(with: data.id)
  }
}
