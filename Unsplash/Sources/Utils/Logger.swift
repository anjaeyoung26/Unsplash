//
//  Logger.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/27.
//

import Foundation


struct Logger {

  // MARK: - Defines

  enum Level: CustomStringConvertible {
    case verbose
    case debug
    case info
    case warning
    case error

    // MARK: - Properties

    var description: String {
      switch self {
      case .verbose:
        return "📢 [VERBOSE]"
      case .debug:
        return "🛠 [DEBUG]"
      case .info:
        return "💡 [INFO]"
      case .warning:
        return "⚠️ [WARNING]"
      case .error:
        return "🚨 [ERROR]"
      }
    }
  }


  // MARK: - Methods

  static func log(
    level: Logger.Level,
    object: Any = "",
    file: String = #file,
    line: Int = #line,
    function: String = #function
  ) {
    #if DEBUG
    print("\(Date()) \(level.description) \(file.components(separatedBy: "/").last ?? ""):(\(line)) \(function) ▷ \(object)")
    #endif
  }
}
