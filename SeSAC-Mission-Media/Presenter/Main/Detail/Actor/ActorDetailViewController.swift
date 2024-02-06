//
//  ActorDetailViewController.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/6/24.
//

import UIKit
import SnapKit

final class ActorDetailViewController: BaseViewController {
  
  // MARK: - UI
  private let summaryView = ActorSummaryView()
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
  weak var coordinator: ActorDetailCoordinator?
  private var actor: Actor
  
  
  // MARK: - Initializer
  init(actor: Actor) {
    self.actor = actor
    
    super.init()
    
    fetchData(with: actor.id)
    hideBackTitle()
    setEmtpyOutBarButton()
    navigationTitle(with: actor.name)
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
  private func fetchData(with personID: Int) {
    APIManager.shared.callRequest(
      responseType: ActorBioDTO.self,
      router: PersonRouter.personDetails(personID: personID)
    ) { [weak self] response in
      guard let self else { return }
      
      actor.combineMoreInfo(with: response)
      summaryView.setData(with: actor)
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

extension ActorDetailViewController: TableControllable {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Collection.PersonDetail.allCases.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let collection = Collection.PersonDetail.allCases[indexPath.row]
    
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

extension ActorDetailViewController: CollectionControllable {
  
  func makeCollectionLayout() -> UICollectionViewFlowLayout {
    return UICollectionViewFlowLayout().configured {
      $0.itemSize = .init(width: 120, height: Constant.UI.collectionHeight)
      $0.minimumLineSpacing = 10
      $0.minimumInteritemSpacing = 0
      $0.scrollDirection = .horizontal
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let mediaType: MediaType = collectionView.tag == .zero ? .tv : .movie
    
    return actor.filteredFilmography(by: mediaType).count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: MediaCollectionViewCell.identifier,
      for: indexPath
    ) as! MediaCollectionViewCell
    
    let mediaType: MediaType = collectionView.tag == .zero ? .tv : .movie
    let filmography: [Media] = mediaType == .tv ? self.actor.tvFilmography : self.actor.movieFilmography
    let data: Media = filmography[indexPath.row]
    
    cell.setData(with: data)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let mediaType: MediaType = collectionView.tag == .zero ? .tv : .movie
    let filmography: [Media] = mediaType == .tv ? self.actor.tvFilmography : self.actor.movieFilmography
    let data: Media = filmography[indexPath.row]
    
    coordinator?.showMediaDetailViewController(with: data.id)
  }
}

