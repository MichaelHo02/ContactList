//
//  ContactPhoneNumberCreation.swift
//  ContactList
//
//  Created by Ho Le Minh Thach on 7/8/24.
//

import SwiftUI
import iPhoneNumberField

struct ContactPhoneNumberCreation: View {

    @Environment(Item.self) private var item

    @FocusState private var focusedField: Bool

    @State private var phoneNumber = ""

    let isEdit: Bool

    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(description)
                .font(.title3.weight(.light))

            iPhoneNumberField(placeholder, text: $phoneNumber, formatted: true)
                .font(UIFont(size: 30, weight: .regular, design: .default))
                .flagHidden(false)
                .flagSelectable(true)
                .prefixHidden(false)
                .autofillPrefix(true)
                .maximumDigits(10)
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
            .disabled(isDisabled)
        }
        .padding()
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            handleOnAppear()
        }
    }

    // MARK: - Logic

    private var isDisabled: Bool {
        isEdit && phoneNumber == item.phoneNumber || phoneNumber.isEmpty
    }

    private func handleOnAppear() {
        phoneNumber = item.phoneNumber
        focusedField = true
    }

    private func handleButtonPressed() {
        item.phoneNumber = phoneNumber
        action()
    }

}

// MARK: - Attributes

private extension ContactPhoneNumberCreation {

    var description: String {
        "Please provide the contact number."
    }

    var placeholder: String {
        "+84 123 567 890"
    }

    var buttonLabel: String {
        isEdit ? "Save" : "Continue"
    }

    var navigationTitle: String {
        "Phone Number"
    }

}

#Preview {
    ContactPhoneNumberCreation(isEdit: false) {}
        .environment(Item(timestamp: .now))
}
