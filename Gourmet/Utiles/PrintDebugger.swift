//
//  PrintDebugger.swift
//  Gourmet
//
//  Created by 최승범 on 8/27/24.
//

import Foundation

class PrintDebugger {
    static func logError(_ error: Error,
                         file: String = #file,
                         line: Int = #line,
                         function: String = #function) {
        let fileName = (file as NSString).lastPathComponent
        print("🔴 [Error] \(error)")
        print("📂 File: \(fileName)")
        print("📍 Line: \(line)")
        print("🔧 Function: \(function)\n")
    }
}
