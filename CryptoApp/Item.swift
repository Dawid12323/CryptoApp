//
//  Item.swift
//  CryptoApp
//
//  Created by Dawid Krakowski on 11/01/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
