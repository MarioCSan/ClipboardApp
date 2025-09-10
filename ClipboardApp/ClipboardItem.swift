//
//  ClipboardItem.swift
//  ClipboardApp
//
//  Created by Mario Canales on 9/9/25.
//

import Foundation

struct ClipboardItem: Identifiable, Codable, Equatable {
    let id: UUID
    let content: String
    var pinned: Bool

    init(content: String, pinned: Bool = false) {
        self.id = UUID()
        self.content = content
        self.pinned = pinned
    }
}
