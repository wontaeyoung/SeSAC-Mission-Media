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
  private let titleLabel = PrimaryLabel(text: nil)
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
  
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    contentView.addSubviews(titleLabel, collectionView)
  }
  
  override func setAttribute() {
    collectionView.collectionViewLayout = UICollectionViewFlowLayout().configured {
      $0.itemSize = .init(width: 120, height: 160)
      $0.minimumLineSpacing = 10
      $0.minimumInteritemSpacing = 0
      $0.scrollDirection = .horizontal
    }
  }
  
  override func setConstraint() {
    titleLabel.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview().offset(8)
      $0.height.equalTo(20)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
      $0.horizontalEdges.bottom.equalToSuperview()
      $0.height.equalTo(196)
    }
  }
  
  
  // MARK: - Method
  func setDelegate(with controller: CollectionControllable) {
    self.collectionView.delegate = controller
    self.collectionView.dataSource = controller
  }
  
  func register(with cellType: BaseTableViewCell.Type) {
    self.collectionView.register(cellType, forCellWithReuseIdentifier: cellType.identifier)
  }
  
  func setData(tvCollection: TVCollection) {
    titleLabel.text = tvCollection.title
    collectionView.tag = tvCollection.tag
  }
  
  func reload() {
    self.collectionView.reloadData()
  }
}
