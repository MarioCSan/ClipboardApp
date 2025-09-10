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
    @State private var selectedItemID: UUID? = nil
    @State private var showCopiedToast = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text("Historial del Portapapeles")
                    .font(.headline)
                    .padding(12)

                Divider()

                List {
                    ForEach(monitor.history) { item in
                        HStack(spacing: 8) {
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
                        .padding(.vertical, 6)
                        .contentShape(Rectangle())
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(selectedItemID == item.id ? Color.blue.opacity(0.25) : Color.clear)
                                .animation(.easeInOut(duration: 0.3), value: selectedItemID)
                        )
                        .onTapGesture {
                            // Resaltar
                            selectedItemID = item.id

                            // Copiar al portapapeles
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(item.content, forType: .string)

                            // Mostrar toast
                            withAnimation {
                                showCopiedToast = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation {
                                    showCopiedToast = false
                                }
                            }

                            // Cerrar popover
                            ClipboardPopover.shared.close()
                        }
                    }
                }
            }

            // Toast flotante
            if showCopiedToast {
                VStack {
                    Spacer()
                    Text(LocalizedStringKey("Texto copiado"))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.75))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 20)
                }
            }
        }
        .frame(minWidth: 400, minHeight: 400)
    }
}
