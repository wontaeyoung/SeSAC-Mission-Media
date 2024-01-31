//
//  CoordinatorError.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/31/24.
//

enum CoordinatorError: AppError {
  case undefiendError
  
  var logDescription: String {
    switch self {
      case .undefiendError:
        return "정의되지 않은 오류 발생"
    }
  }
  
  var alertDescription: (title: String, message: String) {
    switch self {
      case .undefiendError:
        return (title: "알 수 없는 오류가 발생했어요.",
                message: "문제가 계속 되면 잠시 후 다시 시도해주세요!")
    }
  }
}

