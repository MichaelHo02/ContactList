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
            Text("Pleaes provide the contact email.")
                .font(.title3.weight(.light))

            TextField("Type contact email", text: $email)
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
                Text(isEdit ? "Save" : "Continue")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.extraLarge)
            .disabled(isDisable)
        }
        .padding()
        .navigationTitle("Contact Email")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            email = item.email
            focusedField = true
        }
    }

    private var isDisable: Bool {
        isEdit && item.email == email || email.isEmpty
    }

}

#Preview {
    ContactEmailCreationView(isEdit: false) {}
        .environment(Item(timestamp: .now))
}
