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
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let pb = NSPasteboard.general
            if pb.changeCount != self.changeCount {
                self.changeCount = pb.changeCount
                if let copiedText = pb.string(forType: .string) {
                    // Evitar duplicados inmediatos (por contenido)
                    if !self.history.contains(where: { $0.content == copiedText }) {
                        let newItem = ClipboardItem(content: copiedText)
                        DispatchQueue.main.async {
                            self.history.insert(newItem, at: 0)
                            if self.history.count > self.maxItems {
                                self.history.removeLast()
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - UI actions
    func pin(item: ClipboardItem) {
        if let index = history.firstIndex(where: { $0.id == item.id }) {
            history[index].pinned.toggle()
            history.sort { $0.pinned && !$1.pinned }
            savePinnedItems()
        }
    }

    func remove(item: ClipboardItem) {
        history.removeAll { $0.id == item.id }
        savePinnedItems()
    }

    // MARK: - Persistencia
    func savePinnedItems() {
        let pinnedItems = history.filter { $0.pinned }
        if let encoded = try? JSONEncoder().encode(pinnedItems) {
            UserDefaults.standard.set(encoded, forKey: pinnedKey)
        }
    }

    func loadPinnedItems() {
        if let data = UserDefaults.standard.data(forKey: pinnedKey),
           let decoded = try? JSONDecoder().decode([ClipboardItem].self, from: data) {
            // Insert pinned items at top preserving order
            DispatchQueue.main.async {
                self.history.insert(contentsOf: decoded, at: 0)
            }
        }
    }
}
