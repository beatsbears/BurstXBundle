//
//  Logger.swift
//  BurstXBundle
//
//  Created by Andrew Scott on 2/13/18.
//
import Foundation

enum LogEvent: String {
    case error = "[🔴]" // error
    case info = "[🔵]" // info
    case debug = "[⚪️]" // debug
    case warn = "[⚫️]" // warning
}

class Logger {

    static var logBaseDir: URL = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
    static var logsPath = logBaseDir.appendingPathComponent("BurstXBundle")
    static var logFile: URL = logsPath.appendingPathComponent("burstxbundle.log")
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    init() {
        do {
            try FileManager.default.createDirectory(atPath: Logger.logsPath.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
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
        let fileurl =  Logger.logFile
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
