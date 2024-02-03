//
//  TVTableViewCell.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

import UIKit
import SnapKit

final class TVTableViewCell: BaseTableViewCell {
  
  // MARK: - UI
  private let titleLabel = PrimaryLabel()
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).configured {
    $0.showsHorizontalScrollIndicator = false
    $0.register(TVCollectionViewCell.self, forCellWithReuseIdentifier: TVCollectionViewCell.identifier)
  }
  
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    contentView.addSubviews(titleLabel, collectionView)
  }
  
  override func setAttribute() {
    
  }
  
  override func setConstraint() {
    titleLabel.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview().offset(8)
      $0.height.equalTo(20)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom)
      $0.horizontalEdges.bottom.equalToSuperview()
      $0.height.equalTo(196)
    }
  }
  
  
  // MARK: - Method
  func setDelegate(with controller: CollectionControllable) {
    self.collectionView.delegate = controller
    self.collectionView.dataSource = controller
  }
  
  func setData(tvCollection: TVCollection) {
    titleLabel.text = tvCollection.title
    collectionView.tag = tvCollection.tag
  }
  
  func setCollectionLayout(with layout: UICollectionViewFlowLayout) {
    self.collectionView.collectionViewLayout = layout
  }
  
  func reload() {
    self.collectionView.reloadData()
  }
}
