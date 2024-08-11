//
//  ContactPhoneNumberCreation.swift
//  ContactList
//
//  Created by Ho Le Minh Thach on 7/8/24.
//

import SwiftUI
import iPhoneNumberField

struct ContactPhoneNumberCreation: View {

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    @Environment(Item.self) private var item

    @FocusState private var focusedField: Bool

    @State private var phoneNumber = ""

    let isEdit: Bool

    let action: () -> Void

    var body: some View {
        VStack(alignment: alignment) {
            Text(description)
                .font(.title3.weight(.light))

            iPhoneNumberField(placeholder, text: $phoneNumber, formatted: true)
                .font(UIFont.preferredFont(forTextStyle: .largeTitle))
                .flagHidden(false)
                .flagSelectable(true)
                .prefixHidden(false)
                .autofillPrefix(true)
                .maximumDigits(9)
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

    private var alignment: HorizontalAlignment {
        dynamicTypeSize.isAccessibilitySize ? .center : .leading
    }

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

    var description: LocalizedStringKey {
        "Please provide the contact number."
    }

    var placeholder: String {
        String(localized: "+61 123 567 890")
    }

    var buttonLabel: LocalizedStringKey {
        isEdit ? "Save" : "Continue"
    }

    var navigationTitle: LocalizedStringKey {
        "Phone Number"
    }

}

#Preview {
    ContactPhoneNumberCreation(isEdit: false) {}
        .environment(Item(timestamp: .now))
}
