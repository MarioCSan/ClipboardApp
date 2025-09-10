//
//  ContentView.swift
//  ClipboardApp
//
//  Created by Mario Canales on 9/9/25.
//
import SwiftUI
import AppKit

struct ContentView: View {
    @EnvironmentObject var monitor: ClipboardMonitor
    @State private var copiedFeedback = false

    var body: some View {
        VStack {
            Text("Historial del Portapapeles")
                .font(.headline)
                .padding()

            List {
                ForEach(monitor.history) { item in
                    HStack {
                        Text(item.content)
                            .lineLimit(1)
                            .truncationMode(.tail)

                        Spacer()

                        Button(action: { monitor.pin(item: item) }) {
                            Image(systemName: item.pinned ? "pin.fill" : "pin")
                        }
                        .buttonStyle(BorderlessButtonStyle())

                        Button(action: { monitor.remove(item: item) }) {
                            Image(systemName: "trash")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(item.content, forType: .string)

                        withAnimation {
                            copiedFeedback = true
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation {
                                copiedFeedback = false
                            }
                        }
                    }
                }
            }

            if copiedFeedback {
                Text("Texto copiado")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(6)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(6)
                    .transition(.opacity.combined(with: .scale))
                    .animation(.easeInOut, value: copiedFeedback)
            }
        }
        .frame(minWidth: 400, minHeight: 500)
        .environmentObject(monitor)
    }
}
