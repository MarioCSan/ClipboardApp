//
//  ClipboardMonitor.swift
//  ClipboardApp
//
//  Created by Mario Canales on 9/9/25.
//

import Cocoa
import SwiftUI

class ClipboardMonitor: ObservableObject {
    @Published var history: [ClipboardItem] = []

    private var changeCount = NSPasteboard.general.changeCount
    private let maxItems = 25
    private let pinnedKey = "PinnedClipboardItems"

    init() {
        loadPinnedItems()
        startMonitoring()
    }

    func startMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
            let pb = NSPasteboard.general
            if pb.changeCount != self.changeCount {
                self.changeCount = pb.changeCount
                if let copiedText = pb.string(forType: .string) {
                    if !self.history.contains(where: { $0.content == copiedText }) {
                        let newItem = ClipboardItem(content: copiedText)
                        self.history.insert(newItem, at: 0)
                        if self.history.count > self.maxItems {
                            self.history.removeLast()
                        }
                    }
                }
            }
        }
    }

    func pin(item: ClipboardItem) {
        if let index = history.firstIndex(of: item) {
            history[index].pinned.toggle()
            savePinnedItems()
        }
    }

    func remove(item: ClipboardItem) {
        history.removeAll { $0.id == item.id }
        savePinnedItems()
    }

    func savePinnedItems() {
        let pinnedItems = history.filter { $0.pinned }
        if let encoded = try? JSONEncoder().encode(pinnedItems) {
            UserDefaults.standard.set(encoded, forKey: pinnedKey)
        }
    }

    func loadPinnedItems() {
        if let data = UserDefaults.standard.data(forKey: pinnedKey),
           let decoded = try? JSONDecoder().decode([ClipboardItem].self, from: data) {
            history.append(contentsOf: decoded)
        }
    }
}
