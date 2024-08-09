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
            Text("Please provide the contact number.")
                .font(.title3.weight(.light))

            iPhoneNumberField("+84 123 567 890", text: $phoneNumber, formatted: true)
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
                item.phoneNumber = phoneNumber
                action()
            } label: {
                Text(isEdit ? "Save" : "Continue")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.extraLarge)
            .disabled(isDisabled)
        }
        .padding()
        .navigationTitle("Phone Number")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            phoneNumber = item.phoneNumber
            focusedField = true
        }
    }

    private var isDisabled: Bool {
        isEdit && phoneNumber == item.phoneNumber || phoneNumber.isEmpty
    }

}

#Preview {
    ContactPhoneNumberCreation(isEdit: false) {}
        .environment(Item(timestamp: .now))
}
