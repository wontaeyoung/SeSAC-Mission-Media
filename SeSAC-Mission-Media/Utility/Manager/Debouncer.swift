//
//  Debouncer.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/5/24.
//

import Foundation

/// 싱글톤으로 구현해도 런루프 관리는 할 수 있지만 타이머 참조가 해제되지 않고 남아있게 됨
/// => 스케쥴 타이머에서 액션이 실행된 후에 명시적으로 timer에 nil을 전달해서 해제할 수는 있음
@MainActor
final class Debouncer {
  private var timer: Timer?
  private let delay: TimeInterval
  
  init(delay: TimeInterval) {
    self.delay = delay
  }
  
  enum Thread {
    case main
    case global
  }
  
  func excute(in thread: Thread, action: @escaping () -> Void) {
    /// 이전에 설정된 스케쥴 작업 취소
    timer?.invalidate()
    
    /// 반복 여부가 false로 되어있으면, 명시적으로 해제하지 않아도 스케쥴 작업 실행 후 런루프에서 해제됨
    timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
      switch thread {
        case .main:
          GCD.main { action() }
          
        case .global:
          GCD.global { action() }
      }
    }
  }
}
