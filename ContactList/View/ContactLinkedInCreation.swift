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
            Text("You can always change this later.")
                .font(.title3.weight(.light))

            TextField("LinkededIn username", text: $name)
                .textFieldStyle(.plain)
                .font(.title)
                .focused($focusedField)

            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button {
                    item.linkedInName = name.trimmingCharacters(in: .whitespacesAndNewlines)
                    action()
                } label: {
                    Text(isEdit ? "Save" : "Continue")
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
        .navigationTitle("LinkedIn")
        .navigationBarTitleDisplayMode(.large)
        .fullScreenCover(isPresented: $isShowingScanner) {
            ScanView(name: $name)
        }
        .onAppear {
            name = item.linkedInName
            focusedField = true
        }
    }

    private var isDisable: Bool {
        isEdit && item.linkedInName == name || name.isEmpty
    }

}

#Preview {
    ContactLinkedInCreation(isEdit: false) {}
        .environment(Item.init(timestamp: .now))
}
