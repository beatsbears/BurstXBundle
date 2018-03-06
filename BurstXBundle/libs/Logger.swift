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

    static var logDir: URL = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
    static var logFile: URL = logDir.appendingPathComponent("burstxbundle.log")
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

        let message = "\(Date().toString()) \(event.rawValue)[\(sourceFileName(filePath: fileName))]:\(line) \(column) \(funcName) -> \(message)"
        #if DEBUG
            print(message)
        #endif
        writeToLog(message: message)
    }

     private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }

    class func writeToLog(message: String) {
        let dir = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
        let fileurl =  dir.appendingPathComponent("burstxbundle.log")
        let logFormatMessage = message + "\n"
        let data = logFormatMessage.data(using: .utf8, allowLossyConversion: false)!

        if FileManager.default.fileExists(atPath: fileurl.path) {
            if let fileHandle = try? FileHandle(forUpdating: fileurl) {
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            }
        } else {
            do {
                try data.write(to: fileurl, options: Data.WritingOptions.atomic)
            } catch {}
        }
    }
}

internal extension Date {
    func toString() -> String {
        return Logger.dateFormatter.string(from: self as Date)
    }
}
