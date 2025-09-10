//
//  ClipboardApp.swift
//  ClipboardApp
//
//  Created by Mario Canales on 9/9/25.
//

import SwiftUI

@main
struct ClipboardApp: App {
    init() {
        DispatchQueue.main.async {
            _ = StatusBarController.shared
        }
    }

    var body: some Scene {
        Settings { EmptyView() }
    }
}

