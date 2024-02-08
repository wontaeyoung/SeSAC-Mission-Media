//
//  TrailerViewController.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/7/24.
//

import UIKit
import SnapKit
import WebKit

final class TrailerViewController: BaseViewController {
  
  // MARK: - UI
  private let trailerWebView = WKWebView()
  
  
  // MARK: - Property
  weak var coordinator: MediaDetailCoordinator?
  
  
  // MARK: - Initializer
  init(media: Media) {
    super.init()
    
    fetchData(with: media)
  }
  
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubview(trailerWebView)
  }
  
  override func setConstraint() {
    trailerWebView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  
  // MARK: - Method
  private func fetchData(with media: Media) {
    APIManager.shared.callRequest(
      responseType: VideoResponseDTO.self,
      router: media.type == .tv ? TVRouter.videos(seriesID: media.id) : MovieRouter.videos(movieID: media.id)
    ) { response in
      
      self.loadWebView(response: response, mediaType: media.type)
    }
  }
  
  private func loadWebView(response: VideoResponse, mediaType: MediaType) {
    guard let video = response.results.first else {
      self.coordinator?.showAlert(
        title: "트레일러가 준비되어있지 않은 \(mediaType == .tv ? "TV 프로그램" : "영화")입니다.",
        message: "확인을 누르면 뒤로 돌아가요."
      ) {
        self.coordinator?.pop()
      }
      
      return
    }
    
    guard let url = URL(string: APIKey.Youtube.baseURL + video.key) else {
      self.coordinator?.handle(error: SessionError.invalidURL)
      return
    }
    
    self.trailerWebView.load(URLRequest(url: url))
  }
}

