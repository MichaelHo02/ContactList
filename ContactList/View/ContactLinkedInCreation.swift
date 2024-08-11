//
//  ContactLinkedInCreation.swift
//  ContactList
//
//  Created by Ho Le Minh Thach on 9/8/24.
//

import SwiftUI

struct ContactLinkedInCreation: View {

    @Environment(Item.self) private var item

    @FocusState private var focusedField: Bool

    @State private var name = ""
    @State private var isShowingScanner = false


    let isEdit: Bool
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(description)
                .font(.title3.weight(.light))

            TextField(placeholder, text: $name)
                .textFieldStyle(.plain)
                .font(.title)
                .focused($focusedField)

            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button {
                    handleButtonPressed()
                } label: {
                    Text(buttonLabel)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.extraLarge)
                .disabled(isDisable)

                Button {
                    isShowingScanner = true
                } label: {
                    Image(systemSymbol: .qrcode)
                }
                .controlSize(.extraLarge)
                .buttonStyle(.bordered)
                .buttonBorderShape(.circle)
                .tint(.accentColor)
            }
        }
        .padding()
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.large)
        .fullScreenCover(isPresented: $isShowingScanner) {
            ScanView(name: $name)
        }
        .onAppear {
            handleOnAppear()
        }
    }

    // MARK: - Logic

    private var isDisable: Bool {
        isEdit && item.linkedInName == name || name.isEmpty
    }

    private func handleOnAppear() {
        name = item.linkedInName
        focusedField = true
    }

    private func handleButtonPressed() {
        item.linkedInName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        action()
    }

}

// MARK: - Attributes

private extension ContactLinkedInCreation {

    var description: LocalizedStringKey {
        "You can always change this later."
    }

    var placeholder: LocalizedStringKey {
        "LinkededIn username"
    }

    var buttonLabel: LocalizedStringKey {
        isEdit ? "Save" : "Continue"
    }

    var navigationTitle: LocalizedStringKey {
        "LinkedIn"
    }

}

#Preview {
    ContactLinkedInCreation(isEdit: false) {}
        .environment(Item.init(timestamp: .now))
}
