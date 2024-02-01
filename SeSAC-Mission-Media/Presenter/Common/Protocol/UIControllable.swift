//
//  UIControllable.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/1/24.
//

import UIKit

protocol SearchBarControllable: UISearchBarDelegate { }

protocol TableControllable: UITableViewDelegate, UITableViewDataSource { }

protocol CollectionControllable: UICollectionViewDelegate, UICollectionViewDataSource {
  func makeCollectionLayout() -> UICollectionViewFlowLayout
}
