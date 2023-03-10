//
//  Logger.swift
//  Unsplash
//
//  Created by ėėŽė on 2022/12/27.
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
        return "ðĒ [VERBOSE]"
      case .debug:
        return "ð  [DEBUG]"
      case .info:
        return "ðĄ [INFO]"
      case .warning:
        return "â ïļ [WARNING]"
      case .error:
        return "ðĻ [ERROR]"
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
    print("\(Date()) \(level.description) \(file.components(separatedBy: "/").last ?? ""):(\(line)) \(function) â· \(object)")
    #endif
  }
}
