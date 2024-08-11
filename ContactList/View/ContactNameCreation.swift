//
//  ContactNameCreation.swift
//  ContactList
//
//  Created by Ho Le Minh Thach on 7/8/24.
//

import SwiftUI

struct ContactNameCreation: View {

    @Environment(Item.self) private var item

    @FocusState private var focusedField: Bool

    @State private var name = ""

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
            Button {
                handleButtonPressed()
            } label: {
                Text(buttonLabel)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.extraLarge)
            .disabled(isDisable)
        }
        .padding()
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            handleOnAppear()
        }
    }

    // MARK: - Logic

    private var isDisable: Bool {
        isEdit && item.username == name || name.isEmpty
    }

    private func handleOnAppear() {
        name = item.username
        focusedField = true
    }

    private func handleButtonPressed() {
        item.username = name.trimmingCharacters(in: .whitespacesAndNewlines)
        action()
    }


}

// MARK: - Attributes

private extension ContactNameCreation {

    var description: LocalizedStringKey {
        "You can always change this later."
    }

    var placeholder: LocalizedStringKey {
        "Type contact name"
    }

    var buttonLabel: LocalizedStringKey {
        isEdit ? "Save" : "Continue"
    }

    var navigationTitle: LocalizedStringKey {
        "Contact Name"
    }

}

#Preview {
    ContactNameCreation(isEdit: false) {}
        .environment(Item(timestamp: .now))
}
