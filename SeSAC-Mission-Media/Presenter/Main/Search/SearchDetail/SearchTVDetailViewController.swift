//
//  SearchTVDetailViewController.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/1/24.
//

import UIKit
import SnapKit

final class SearchTVDetailViewController: BaseViewController {
  
  // MARK: - UI
  private let summaryView = TVSummaryView()
  private lazy var tableView = UITableView().configured {
    $0.dataSource = self
    $0.delegate = self
    $0.register(TVTableViewCell.self, forCellReuseIdentifier: TVTableViewCell.identifier)
  }
  
  // MARK: - Property
  weak var coordinator: SearchCoordinator?
  private var recommendationList: [TV] = []
  private var castList: [TV] = []
  
  init(seriesID: Int) {
    super.init()
    
    hideBackTitle()
    fetchDatas(with: seriesID)
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(summaryView, tableView)
  }
  
  override func setConstraint() {
    summaryView.snp.makeConstraints {
      $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
      $0.height.equalTo(300)
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(summaryView.snp.bottom).offset(10)
      $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  
  // MARK: - Method
  func fetchDatas(with seriesID: Int) {
    let group = DispatchGroup()
    
    APIManager.shared.callRequest(
      responseType: TVDetailDTO.self,
      router: TVRouter.seriesDetails(seriesID: seriesID)
    ) { [weak self] response in
      guard let self else { return }
      
      navigationTitle(with: response.name)
      summaryView.setData(with: response)
    }
    
    group.enter()
    APIManager.shared.callRequest(
      responseType: TVResponseDTO.self,
      router: TVRouter.seriesRecommandation(seriesID: seriesID)
    ) { [weak self] response in
      guard let self else { return }
      
      recommendationList = response.results
      group.leave()
    }
    
    group.notify(queue: .main) {
      self.tableView.reloadData()
    }
  }
}

extension SearchTVDetailViewController: TableControllable {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TVTableViewCell.identifier, for: indexPath) as! TVTableViewCell
    
    let collection = TVCollection.searchCollections[indexPath.row]
    
    cell.setDelegate(with: self)
    cell.setData(tvCollection: collection)
    cell.setCollectionLayout(with: makeCollectionLayout())
    cell.reload()
    
    return cell
  }
}

extension SearchTVDetailViewController: CollectionControllable {
  func makeCollectionLayout() -> UICollectionViewFlowLayout {
    return UICollectionViewFlowLayout().configured {
      $0.itemSize = .init(width: 120, height: 160)
      $0.minimumLineSpacing = 10
      $0.minimumInteritemSpacing = 0
      $0.scrollDirection = .horizontal
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    return collectionView.tag - TVCollection.homeCollections.count == .zero
    ? recommendationList.count
    : castList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TVCollectionViewCell.identifier, for: indexPath) as! TVCollectionViewCell
    
    let data = recommendationList[indexPath.row]
    cell.setData(with: data)
    
    return cell
  }
}

