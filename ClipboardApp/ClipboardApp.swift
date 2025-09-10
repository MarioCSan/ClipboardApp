//
//  ClipboardApp.swift
//  ClipboardApp
//
//  Created by Mario Canales on 9/9/25.
//

import SwiftUI

@main
struct ClipboardApp: App {
    @StateObject private var monitor = ClipboardMonitor()
    let hotkey = GlobalHotkey()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(monitor)
                .onAppear {
                    hotkey.start()
                }
        }
    }
}

