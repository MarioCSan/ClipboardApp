//
//  ClipboardPopover.swift
//  ClipboardApp
//
//  Created by Mario Canales on 9/9/25.
//

import Cocoa
import SwiftUI

class ClipboardPopover {
    static let shared = ClipboardPopover()

    private let popover: NSPopover
    private let monitor: ClipboardMonitor

    private init() {
        // Usamos un monitor global
        self.monitor = AppGlobals.clipboardMonitor

        popover = NSPopover()
        popover.behavior = .transient
        popover.contentSize = NSSize(width: 400, height: 500)
        popover.contentViewController = NSHostingController(
            rootView: ContentView().environmentObject(monitor)
        )
    }

    func toggle(relativeTo rect: NSRect, of view: NSView, preferredEdge edge: NSRectEdge) {
        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: rect, of: view, preferredEdge: edge)
            popover.contentViewController?.view.window?.makeKey()
        }
    }

    func close() {
        popover.performClose(nil)
    }
}
