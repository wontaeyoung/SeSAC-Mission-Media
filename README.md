# 디바운싱과 쓰로틀링

서버에 HTTP 요청을 과도하게 보내지 않도록 클라이언트에서 조절하는 기술

- 디바운싱: 연속적인 함수 실행 요청 중, 가장 마지막 요청만 수행
- 쓰로틀링: 현재 실행 중인 함수가 있으면, 다른 요청을 무시함

## 필요성

- 실시간 타이핑 검색, 네트워크 요청 버튼 연속 탭과 같은 상황에서 매 번 서버에 HTTP 요청을 보내면 서버의 부담이 발생
- 사용자의 요청 경험을 저하시키지 않는 선에서, 클라이언트 단계에서 요청 횟수를 조절할 필요성이 있음

 
## 디바운싱 동작 원리

DispatchQueue, Timer, Sleep 등 다양한 방법으로 구현할 수 있는데, 목적은 같기 때문에 기본적으로 아래와 같은 순서로 동작한다. 

1. 예약되어있거나 실행 중인 작업을 취소한다.
2. 지정된 시간동안 대기한다. 
3. 작업을 수행한다.

위의 순서대로 동작하면 사용자의 다음 요청이 아직 완료되지 않은 이전 요청을 계속 캔슬시키기 때문에, 결과적으로 가장 마지막 요청만 정상적으로 수행된다.


## 디바운싱 구현


```swift
import Foundation

/// 싱글톤으로 구현해도 런루프 관리는 할 수 있지만 타이머 참조가 해제되지 않고 남아있게 됨
/// => 스케쥴 타이머에서 액션이 실행된 후에 명시적으로 timer에 nil을 전달해서 해제할 수는 있음
@MainActor
final class Debouncer {
  
  enum Thread {
    case main
    case global
  }
  
  // MARK: - Property
  private var timer: Timer?
  private let delay: TimeInterval
  
  
  // MARK: - Initializer
  init(delay: TimeInterval) {
    self.delay = delay
  }
  
  deinit {
    self.timer?.invalidate()
  }
  
  
  // MARK: - Method
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

```

# Run Loop

입력 이벤트, 타이머 이벤트, 네트워크 이벤트와 같은 다양한 이벤트를 처리하는 루프 구조

## 동작 원리

- 하나 이상의 이벤트 소스를 감시함
- 이벤트 발생 시 지정된 Handler나 함수 실행
- 적절한 처리 후 대기 상태로 돌입

위의 사이클은 앱 생명주기동안, 런루프를 명시적으로 종료시킬 때까지 반복

### 이벤트 소스

크게 두 가지 유형으로 구분

- Timer Event Source: 특정 시간 경과 시 이벤트 발생
  - 예약된 시간 또는 반복 간격으로 발생하는 **동기 이벤트**를 전달
- Input Event Source: 외부 이벤트 (ex. 사용자 입력)을 감지하여 이벤트 발생
  - 다른 스레드로부터 온 **비동기 이벤트**를 전달

## 스레드와의 관계

- 각 스레드가 최대 1개 가질 수 있음
- 스레드가 작동할 때 함께 작동하고, 작업이 없을 때 대기 상태로 돌입해서 리소스를 효율적으로 관리함

### 메인 스레드

- 기본적으로 메인 런루프를 실행함
- UI 이벤트 처리 및 UI 업데이트 수행

### 백그라운드 스레드

- 백그라운드 런루프를 기본적으로 실행하지 않음
- 이벤트 기반 작업을 처리하려고 할 때 명시적으로 구성하고 실행해야 함
  - current라는 타입 프로퍼티에 처음 접근할 때, 해당 스레드에 런루프가 없으면 생성함
  - 생성과 실행은 별개이기 때문에, 실행 역시 별도로 호출해야 함

#### 런루프 생성
``` swift
class var current: RunLoop { get }

/// 호출 스레드에 대한 런루프 생성
let runLoop = RunLoop.current
```

#### 런루프 실행

##### run()

[공식문서]
Receiver를 영구 루프에 추가하고, 이 시점까지 부착된 모든 Input Source 데이터를 영구히 처리한다.

- run()을 호출하기 전까지 부착된 이벤트 소스에 대해서만 처리한다.
- 아래 코드에서 run()을 실행한 후에 부착된 Timer 2는 처리되지 않는다.

```swift
Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
  print("Global Thread Timer 1")
}

runLoop.run()

Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
  print("Global Thread Timer 2")
}
```

##### run(until:)

[공식문서]
특정한 날짜까지 루프를 실행, 이 기간동안 부착되어있는 모든 Input Source 데이터를 처리한다.

- 일반적으로 런루프를 반복 실행할 때, 이 함수를 사용함
- 함수 실행 전/후로 부착된 모든 이벤트 소스를 지정 날짜까지는 계속 처리함
- 루프의 실행 시간을 직접 지정할 수 있음
- 보통 0.1 ~ 1초 정도 런루프를 실행시킴 -> 원할 때까지 반복문으로 유지함
- 루프 처리가 동시성으로 돌아가야한다면, 반복문이 sync로 작동하지 않도록 스레드 관리가 필요함

```swift
while isRunning {
  runLoop.run(until: Date().addingTimeInterval(0.1))
}
```

## 정리

- 런루프는 Timer, Input과 같은 이벤트를 처리하는 객체
- 모든 스레드가 최대 1개의 런루프를 가질 수 있음
- 메인 스레드는 기본적으로 자동 생성 및 실행되는 런루프를 가지고 있음
- 백그라운드 스레드는 직접 생성 및 실행해주어야 함
- 다음과 같을 때 사용함
  - Input Source를 통해 다른 스레드와 통신할 때
  - Timer를 사용할 때
  - 주기적인 반복 작업을 계속 수행해야할 때
- Timer는 메인 스레드에서 돌리는게 안전하다고 함!!!
