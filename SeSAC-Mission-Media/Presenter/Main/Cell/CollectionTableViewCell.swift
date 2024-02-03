//
//  CollectionTableViewCell.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

import UIKit
import SnapKit

/// 카테고리 타이틀과 해당하는 데이터를 컬렉션으로 보여주는 테이블 셀
final class CollectionTableViewCell: BaseTableViewCell {
  
  // MARK: - UI
  private let titleLabel = PrimaryLabel()
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).configured {
    $0.showsHorizontalScrollIndicator = false
    $0.register(TVCollectionViewCell.self, forCellWithReuseIdentifier: TVCollectionViewCell.identifier)
    $0.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.identifier)
  }
  
  
  // MARK: - Initializer
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.selectionStyle = .none
  }
  
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    contentView.addSubviews(titleLabel, collectionView)
  }
  
  override func setConstraint() {
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(20)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
      $0.horizontalEdges.bottom.equalToSuperview()
      $0.height.equalTo(Constant.UI.collectionHeight)
      $0.bottom.equalToSuperview().inset(20)
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
