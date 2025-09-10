//
//  StatusBarController.swift
//  ClipboardApp
//
//  Created by Mario Canales on 10/9/25.
//

import Cocoa
import SwiftUI

class StatusBarController {
    static let shared = StatusBarController()

    private(set) var statusItem: NSStatusItem!

    private init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "doc.on.doc", accessibilityDescription: "Clipboard")
            button.action = #selector(togglePopover)
            button.target = self
        }
    }

    @objc func togglePopover() {
        guard let button = statusItem.button else { return }
        ClipboardPopover.shared.toggle(relativeTo: button.bounds, of: button, preferredEdge: .minY)
    }
}

