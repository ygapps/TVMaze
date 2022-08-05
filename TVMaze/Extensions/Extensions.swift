//
//  Extensions.swift
//  TVMaze
//
//  Created by Youssef on 8/5/22.
//

import Foundation

extension String {
    
    public var removingHTMLOccurrences: String {
        return self.replacingOccurrences(of: "<[^>]*>", with: "", options: .regularExpression, range: self.startIndex ..< self.endIndex)
    }
}
