//
//  LogManager.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/31/24.
//

import Foundation
import os

final class LogManager {
  
  enum LogCategory: String {
    case network = "Network"
    case local = "Local"
    
    static let bundleID: String = Bundle.main.bundleIdentifier ?? ""
    
    var category: String {
      return self.rawValue
    }
  }
  
  // MARK: - Singleton
  static let shared = LogManager()
  private init() { }
  
  
  // MARK: - Property
  private lazy var networkLogger = Logger(subsystem: LogCategory.bundleID, category: LogCategory.network.category)
  private lazy var localLogger = Logger(subsystem: LogCategory.bundleID, category: LogCategory.local.category)
  
  func log(with error: AppError, to logTarget: LogCategory, level: OSLogType = .error) {
    let message = error.logDescription
        
    switch logTarget {
      case .network:
        networkLogger.log(level: level, "\(message)")
        
      case .local:
        localLogger.log(level: level, "\(message)")
    }
  }
}
