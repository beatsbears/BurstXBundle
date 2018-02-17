//
//  Logger.swift
//  BurstXBundle
//
//  Created by Andrew Scott on 2/13/18.
//  Copyright © 2018 Drowned Coast. All rights reserved.
//
import Foundation

enum LogEvent: String {
    case error = "[🔴]" // error
    case info = "[🔵]" // info
    case debug = "[⚪️]" // debug
    case warn = "[⚫️]" // warning
}

class Logger {

    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }

    class func log(message: String,
                   event: LogEvent,
                   fileName: String = #file,
                   line: Int = #line,
                   column: Int = #column,
                   funcName: String = #function) {

        #if DEBUG
            print("\(Date().toString()) \(event.rawValue)[\(sourceFileName(filePath: fileName))]:\(line) \(column) \(funcName) -> \(message)")
        #endif
    }
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}

internal extension Date {
    func toString() -> String {
        return Logger.dateFormatter.string(from: self as Date)
    }
}
