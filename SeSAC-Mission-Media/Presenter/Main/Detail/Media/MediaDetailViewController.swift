//
//  MediaDetailViewController.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/1/24.
//

import UIKit
import SnapKit

final class MediaDetailViewController: BaseViewController {
  
  // MARK: - UI
  private let summaryView = MediaSummaryView()
  private lazy var tableView = UITableView().configured {
    $0.dataSource = self
    $0.delegate = self
    $0.separatorStyle = .none
    $0.register(
      CollectionTableViewCell.self,
      forCellReuseIdentifier: CollectionTableViewCell.identifier
    )
  }
  
  // MARK: - Property
  weak var coordinator: MediaDetailCoordinator?
  private var recommendationList: [Media] = []
  private var castList: [Actor] = []
  
  init(seriesID: Int) {
    super.init()
    
    fetchDatas(with: seriesID)
    hideBackTitle()
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
      responseType: MediaDetailDTO.self,
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

extension MediaDetailViewController: TableControllable {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Collection.MediaDetail.allCases.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let collection = Collection.MediaDetail.allCases[indexPath.row]
    
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

extension MediaDetailViewController: CollectionControllable {
  
  func makeCollectionLayout() -> UICollectionViewFlowLayout {
    return UICollectionViewFlowLayout().configured {
      $0.itemSize = .init(width: 120, height: Constant.UI.collectionHeight)
      $0.minimumLineSpacing = 10
      $0.minimumInteritemSpacing = 0
      $0.scrollDirection = .horizontal
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let collection = Collection.MediaDetail.allCases[collectionView.tag]
    
    return collection == .recommend ? recommendationList.count : castList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let collection = Collection.MediaDetail.allCases[collectionView.tag]
    
    switch collection {
      case .recommend:
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: MediaCollectionViewCell.identifier,
          for: indexPath
        ) as! MediaCollectionViewCell
        
        let data = recommendationList[indexPath.row]
        cell.setData(with: data)
        
        return cell
        
      case .cast:
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: ActorCollectionViewCell.identifier,
          for: indexPath
        ) as! ActorCollectionViewCell
        
        let data = castList[indexPath.row]
        cell.setData(with: data)
        
        return cell
    }
  }
  
  // TODO: - 작품 / 배우 모두 탭해서 Detail 가능하도록
  /// 현재 작품 / 배우 Coordinator가 분리되어있는데, 서로의 화면으로 중첩이 가능해서 통합이 필요할수도 있을 것 같음
  /// Coordinator 분리를 하려면 중첩으로 Coordinator가 combine 된 상황에서 다 비우고 나올 수 있게 해야함
  ///
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let collection = Collection.MediaDetail.allCases[collectionView.tag]
    
    switch collection {
      case .recommend:
        let data = recommendationList[indexPath.row]
        coordinator?.showMediaDetailViewController(with: data.id)
        
      case .cast:
        let data = castList[indexPath.row]
        coordinator?.combineActorDetailFlow(with: data)
    }
  }
}
