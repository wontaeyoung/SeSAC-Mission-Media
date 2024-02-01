//
//  UIImageView+.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/1/24.
//

import UIKit
import Kingfisher

extension UIImageView {
  func setImage(with url: Resource?, by samplingSize: CGSize) {
    let downsamplingProcessor = DownsamplingImageProcessor(size: samplingSize)
    self.kf.indicatorType = .activity
    
    self.kf.setImage(
      with: URL(string: "https://private-user-images.githubusercontent.com/45925685/283520994-13961845-486e-42d0-8798-b4fa57cdda1e.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDY3OTgzODQsIm5iZiI6MTcwNjc5ODA4NCwicGF0aCI6Ii80NTkyNTY4NS8yODM1MjA5OTQtMTM5NjE4NDUtNDg2ZS00MmQwLTg3OTgtYjRmYTU3Y2RkYTFlLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNDAyMDElMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjQwMjAxVDE0MzQ0NFomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTIyZGU3ZDNmYjdmZTU1ZDk4OGM4YjQxYTAzN2JhMTJjNTgyZTMxMzhjMGZlNDEyMGY5MDE3ZGM4YWIzZTg5YWEmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JmFjdG9yX2lkPTAma2V5X2lkPTAmcmVwb19pZD0wIn0.YtR0myaDqW9YOg3bAS4Ie2b6p0I3YhWR7mNujKlDNGE"),
//      placeholder: UIImage(systemName: "photo"),
      options: [
        .processor(downsamplingProcessor),
        .scaleFactor(UIScreen.main.scale),
        .transition(.fade(1)),
        .cacheOriginalImage
      ]
    )
  }
}
