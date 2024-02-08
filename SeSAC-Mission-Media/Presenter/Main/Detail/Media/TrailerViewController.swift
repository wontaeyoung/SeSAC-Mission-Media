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
  private lazy var trailerWebView = WKWebView().configured {
    $0.navigationDelegate = self
  }
  private lazy var loadingIndicator = UIActivityIndicatorView().configured {
    $0.style = .large
    $0.center = view.center
    $0.hidesWhenStopped = true
  }
  
  // MARK: - Property
  weak var coordinator: MediaDetailCoordinator?
  
  
  // MARK: - Initializer
  init(media: Media) {
    super.init()
    
    fetchData(with: media)
  }
  
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(trailerWebView, loadingIndicator)
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

// MARK: - Loading Indicator
extension TrailerViewController {
  func startLoading() {
    loadingIndicator.startAnimating()
  }
  
  func stopLoading() {
    loadingIndicator.stopAnimating()
  }
}

// MARK: - WebView Delegate
extension TrailerViewController: WKNavigationDelegate {
  // 로드 시작 시
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    startLoading()
  }
  
  // 로드 완료 시
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    stopLoading()
  }
}
