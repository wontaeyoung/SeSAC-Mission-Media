//
//  TVDetailViewController.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/1/24.
//

import UIKit
import SnapKit

final class TVDetailViewController: BaseViewController {
  
  // MARK: - UI
  private let summaryView = TVSummaryView()
  private lazy var tableView = UITableView().configured {
    $0.dataSource = self
    $0.delegate = self
    $0.separatorStyle = .none
    $0.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
  }
  
  // MARK: - Property
  weak var coordinator: TVDetailCoordinator?
  private var recommendationList: [Media] = []
  private var castList: [Actor] = []
  
  init(seriesID: Int) {
    super.init()
    
    hideBackTitle()
    fetchDatas(with: seriesID)
    setEmtpyOutBarButton()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(summaryView, tableView)
  }
  
  override func setConstraint() {
    summaryView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(summaryView.snp.bottom).offset(32)
      $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  
  // MARK: - Method
  private func fetchDatas(with seriesID: Int) {
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
      responseType: MediaResponseDTO.self,
      router: TVRouter.seriesRecommandation(seriesID: seriesID)
    ) { [weak self] response in
      guard let self else { return }
      
      recommendationList = response.results
      group.leave()
    }
    
    group.enter()
    APIManager.shared.callRequest(
      responseType: ActorResponseDTO.self,
      router: TVRouter.seriesAggregateCredits(seriesID: seriesID)
    ) { [weak self] response in
      guard let self else { return }
      
      castList = response.results
      group.leave()
    }
    
    group.notify(queue: .main) {
      self.tableView.reloadData()
    }
  }
  
  private func setEmtpyOutBarButton() {
    self.navigationItem.rightBarButtonItem = UIBarButtonItem().configured {
      $0.title = "처음으로"
      $0.style = .plain
      $0.target = self
      $0.action = #selector(emptyOut)
    }
  }
  
  @objc private func emptyOut() {
    coordinator?.end()
  }
}

extension TVDetailViewController: TableControllable {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Collection.Search.allCases.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let collection = Collection.Search.allCases[indexPath.row]
    
    let cell = tableView.dequeueReusableCell(
      withIdentifier: CollectionTableViewCell.identifier,
      for: indexPath
    ) as! CollectionTableViewCell
    cell.setDelegate(with: self)
    cell.setData(collection: collection)
    cell.setCollectionLayout(with: makeCollectionLayout())
    cell.reload()
    
    return cell
  }
}

extension TVDetailViewController: CollectionControllable {
  
  func makeCollectionLayout() -> UICollectionViewFlowLayout {
    return UICollectionViewFlowLayout().configured {
      $0.itemSize = .init(width: 120, height: Constant.UI.collectionHeight)
      $0.minimumLineSpacing = 10
      $0.minimumInteritemSpacing = 0
      $0.scrollDirection = .horizontal
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionView.tag == .zero ? recommendationList.count : castList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch collectionView.tag == .zero {
      case true:
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: TVCollectionViewCell.identifier,
          for: indexPath
        ) as! TVCollectionViewCell
        
        let data = recommendationList[indexPath.row]
        cell.setData(with: data)
        
        return cell
        
      case false:
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: ActorCollectionViewCell.identifier,
          for: indexPath
        ) as! ActorCollectionViewCell
        
        let data = castList[indexPath.row]
        cell.setData(with: data)
        
        return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard 
      Collection.Search.recommend.tag == collectionView.tag,
      let data = recommendationList[at: indexPath.row]
    else {
      return
    }
    
    coordinator?.showTVDetailViewController(with: data.id)
  }
}
