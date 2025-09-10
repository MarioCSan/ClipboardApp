//
//  GlobalHotkey.swift
//  ClipboardApp
//

//
//  GlobalHotkey.swift
//  ClipboardApp
//

import HotKey
import Cocoa

class GlobalHotkey {
    private var hotKey: HotKey?

    func start() {
        // Atajo global ⌘+Shift+V
        hotKey = HotKey(key: .v, modifiers: [.command, .shift])
        hotKey?.keyDownHandler = { [weak self] in
            // Abrir el popover en el hilo principal
            DispatchQueue.main.async {
                ClipboardPopover.shared.toggle()
            }
        }
    }

    func stop() {
        // HotKey se elimina automáticamente al liberar hotKey
        hotKey = nil
    }
}
