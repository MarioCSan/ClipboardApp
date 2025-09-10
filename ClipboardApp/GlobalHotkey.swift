//
//  GlobalHotkey.swift
//  ClipboardApp
//

//
//  GlobalHotkey.swift
//  ClipboardApp
//

import Cocoa
import HotKey

class GlobalHotkey {
    private var hotKey: HotKey?

    func start() {
        hotKey = HotKey(key: .v, modifiers: [.option, .command]) // Option + Command + V
        hotKey?.keyDownHandler = { [weak self] in
            DispatchQueue.main.async {
                if let button = StatusBarController.shared.statusItem.button {
                    ClipboardPopover.shared.toggle(
                        relativeTo: button.bounds,
                        of: button,
                        preferredEdge: .minY
                    )
                }
            }
        }
    }

    func stop() {
        hotKey = nil
    }
}
