//
//  CollectionControllable.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

import UIKit

protocol CollectionControllable: UICollectionViewDelegate, UICollectionViewDataSource {
  func makeCollectionLayout() -> UICollectionViewFlowLayout
}
