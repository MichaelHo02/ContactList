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
            Text("You can always change this later.")
                .font(.title3.weight(.light))

            TextField("Type contact name", text: $name)
                .textFieldStyle(.plain)
                .font(.title)
                .focused($focusedField)

            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                item.username = name.trimmingCharacters(in: .whitespacesAndNewlines)
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
        .navigationTitle("Contact Name")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            name = item.username
            focusedField = true
        }
    }

    private var isDisable: Bool {
        isEdit && item.username == name || name.isEmpty
    }

}

#Preview {
    ContactNameCreation(isEdit: false) {}
        .environment(Item(timestamp: .now))
}
