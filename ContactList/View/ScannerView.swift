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
                handleSuccessScan(result)
            case .failure(let error):
                handleFailureScan(error)
            }
        }
        .ignoresSafeArea(.all)
        .safeAreaInset(edge: .bottom) {
            Button {
                dismiss()
            } label: {
                Text(buttonLabel)
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
                    Label(labelTitle, systemSymbol: .exclamationmarkBubble)
                }, description: {
                    Text(labelDescription)
                }, actions: {
                    Button {
                        showErrorView = false
                    } label: {
                        Text(labelAction)
                    }
                })
            }
        }
    }

    // MARK: - Logics

    private func handleSuccessScan(_ result: ScanResult) {
        print(result.string)
        name = String(result.string.split(separator: "/").last?.split(separator: "?").first ?? "")
        dismiss()
    }

    private func handleFailureScan(_ error: ScanError) {
        showErrorView = true
        print("Scanning failed: \(error.localizedDescription)")
    }

}

// MARK: - Attributes

private extension ScanView {

    var buttonLabel: String {
        "Cancel"
    }

    var labelTitle: String {
        "Something went wrong!"
    }

    var labelDescription: String {
        "Cannot regconize QR code."
    }

    var labelAction: String {
        "Try again!"
    }

}

#Preview {
    @State var name = ""
    return ScanView(name: $name)
}
