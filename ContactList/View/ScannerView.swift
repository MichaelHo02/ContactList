//
//  ScannerView.swift
//  ContactList
//
//  Created by Ho Le Minh Thach on 9/8/24.
//

import CodeScanner
import SwiftUI

struct ScanView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var showErrorView: Bool = false

    @Binding var name: String

    var body: some View {
        CodeScannerView(codeTypes: [.qr], showViewfinder: true) { result in
            switch result {
            case .success(let result):
                print(result.string)
                name = String(result.string.split(separator: "/").last?.split(separator: "?").first ?? "")
                dismiss()
            case .failure(let error):
                showErrorView = true
                print("Scanning failed: \(error.localizedDescription)")
            }
        }
        .ignoresSafeArea(.all)
        .safeAreaInset(edge: .bottom) {
            Button {
                dismiss()
            } label: {
                Text("Cancel")
                    .frame(maxWidth: .infinity)
            }
            .tint(.primary)
            .buttonStyle(.bordered)
            .controlSize(.extraLarge)
            .padding(.horizontal)
        }
        .overlay {
            if showErrorView {
                ContentUnavailableView(label: {
                    Label("No Mail", systemImage: "tray.fill")
                }, description: {
                    Text("New mails you receive will appear here.")
                }, actions: {
                    Button {
                        showErrorView = false
                    } label: {
                        Text("Try again!")
                    }
                })
            }
        }
    }
}

#Preview {
    @State var name = ""
    return ScanView(name: $name)
}
