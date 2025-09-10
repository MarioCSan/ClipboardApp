//
//  ClipboardPopover.swift
//  ClipboardApp
//
//  Created by Mario Canales on 9/9/25.
//

import SwiftUI
import AppKit

class ClipboardPopover {
    static let shared = ClipboardPopover()

    private let popover: NSPopover

    private init() {
        popover = NSPopover()
        popover.behavior = .transient
        popover.contentSize = NSSize(width: 400, height: 500)
        // NO fijamos contentViewController aquí para evitar usar una instancia de monitor antigua/nil
    }

    func toggle() {
        if popover.isShown {
            popover.performClose(nil)
            return
        }

        guard let monitor = AppGlobals.clipboardMonitor else {
            // Si por alguna razón aún no se ha asignado el monitor, no hacemos nada
            print("ClipboardPopover: monitor todavía no disponible")
            return
        }

        // Actualizamos el contentViewController justo antes de mostrar
        popover.contentViewController = NSHostingController(rootView: ContentView().environmentObject(monitor))

        // Anchor dummy centrado en pantalla
        let rect = NSRect(x: 0, y: 0, width: 1, height: 1)
        let dummyView = NSView(frame: rect)
        if let screen = NSScreen.main {
            let screenRect = NSRect(x: screen.frame.midX, y: screen.frame.midY, width: 1, height: 1)
            dummyView.frame = screenRect
        }
        popover.show(relativeTo: dummyView.bounds, of: dummyView, preferredEdge: .maxY)
        popover.contentViewController?.view.window?.makeKey()
    }

    func close() {
        popover.performClose(nil)
    }
}
