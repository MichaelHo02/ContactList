//
//  ContactEmailCreationView.swift
//  ContactList
//
//  Created by Ho Le Minh Thach on 9/8/24.
//

import SwiftUI

struct ContactEmailCreationView: View {

    @Environment(Item.self) private var item

    @FocusState private var focusedField: Bool

    @State private var email = ""

    let isEdit: Bool

    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(description)
                .font(.title3.weight(.light))

            TextField(placeholder, text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textFieldStyle(.plain)
                .font(.title)
                .focused($focusedField)

            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                item.email = email.trimmingCharacters(in: .whitespacesAndNewlines)
                action()
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
            email = item.email
            focusedField = true
        }
    }

    private var isDisable: Bool {
        isEdit && item.email == email || email.isEmpty
    }

    private func handleOnAppear() {
        email = item.email
        focusedField = true
    }

    private func handleButtonPressed() {
        item.email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        action()
    }

}

// MARK: - Attributes

private extension ContactEmailCreationView {

    var description: LocalizedStringKey {
        "Please provide the contact email."
    }

    var placeholder: LocalizedStringKey {
        "Type contact email"
    }

    var buttonLabel: LocalizedStringKey {
        isEdit ? "Save" : "Continue"
    }

    var navigationTitle: LocalizedStringKey {
        "Contact Email"
    }

}

#Preview {
    ContactEmailCreationView(isEdit: false) {}
        .environment(Item(timestamp: .now))
}
