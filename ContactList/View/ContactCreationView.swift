//
//  ContactCreationView.swift
//  ContactList
//
//  Created by Ho Le Minh Thach on 3/8/24.
//

import SwiftUI
import SFSafeSymbols
import EmojiPicker
import iPhoneNumberField

struct ContactCreationView: View {

    enum PushedView: Hashable {
        case username(isPop: Bool)
        case avatar(isPop: Bool)
        case phoneNumber(isPop: Bool)
        case review
    }

    @Environment(\.dismiss) private var dismiss

    @State private var path = NavigationPath()
    @State private var item: Item = .init(timestamp: .now)

    var body: some View {
        NavigationStack(path: $path) {
            ContactNameCreation(isEdit: false) {
                path.append(PushedView.avatar(isPop: false))
            }
            .toolbar {
                ToolbarItem {
                    Button(role: .cancel) {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }

                }
            }
            .navigationDestination(for: Self.PushedView.self) { pushedView in
                switch pushedView {
                case .username(let isPop):
                    ContactNameCreation(isEdit: isPop) {
                        if isPop {
                            path.removeLast()
                        } else {
                            path.append(PushedView.avatar(isPop: false))
                        }
                    }
                case .avatar(let isPop):
                    ContactAvatarCreation(isEdit: isPop) {
                        if isPop {
                            path.removeLast()
                        } else {
                            path.append(PushedView.phoneNumber(isPop: false))
                        }
                    }
                case .phoneNumber(let isPop):
                    ContactPhoneNumberCreation(isEdit: isPop) {
                        if isPop {
                            path.removeLast()
                        } else {
                            path.append(PushedView.review)
                        }
                    }
                case .review:
                    ContactReviewCreation {
                        dismiss()
                    }
                }
            }
        }
        .environment(item)
    }

}

private struct ContactNameCreation: View {

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

private struct ContactAvatarCreation: View {

    @Environment(Item.self) private var item

    @FocusState private var focusedField: Bool

    @State private var selectedEmoji: Emoji?

    @State private var displayEmojiPicker: Bool = true

    @State private var selectedColor: Color = .red

    private let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .indigo, .purple]

    let isEdit: Bool

    let action: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            Text("Choose an Emoji")
                .font(.title.bold())

            Button {
                displayEmojiPicker = true
            } label: {
                Text(selectedEmoji?.value ?? "?")
                    .font(.system(size: 50))
                    .foregroundStyle(selectedColor)
                    .multilineTextAlignment(.center)
                    .frame(width: 100, height: 100, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundStyle(selectedColor.secondary)
                    )
            }
            .sensoryFeedback(.impact(flexibility: .soft), trigger: selectedEmoji)

            HStack {
                ForEach(colors, id: \.hashValue) { color in
                    Button {
                        withAnimation(.bouncy) {
                            selectedColor = color
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .scaledToFit()
                            .foregroundStyle(color.secondary)
                            .overlay {
                                if selectedColor == color {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.foreground)
                                }
                            }
                    }
                }
            }

            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                guard let selectedEmoji else { return }
                item.avatar = .init(icon: selectedEmoji.value, background: .fromColor(selectedColor))
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
        .navigationTitle("Avatar")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $displayEmojiPicker) {
            NavigationView {
                EmojiPickerView(selectedEmoji: $selectedEmoji)
                    .navigationTitle("Emojis")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .presentationDetents([.medium, .large])
        }
        .onAppear {
            if let avatar = item.avatar {
                selectedEmoji = .init(value: avatar.icon, name: "")
                selectedColor = avatar.background.color
            }
        }
    }

    private var isDisable: Bool {
        guard let avatar = item.avatar else { return false }
        return isEdit && selectedEmoji?.value ?? "" == avatar.icon && selectedColor == avatar.background.color || selectedEmoji == nil
    }

}

private struct ContactPhoneNumberCreation: View {

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

private struct ContactReviewCreation: View {

    @Environment(\.dismiss) private var dismiss

    @Environment(\.modelContext) private var modelContext

    @Environment(Item.self) private var item

    let isEdit: Bool = false

    let action: () -> Void

    var body: some View {
        @Bindable var item = item
        VStack(spacing: 16) {
            Text("You can tap the tile to edit the details.")
                .font(.headline.weight(.regular))
                .listStyle(.plain)
                .padding(.vertical)

            NavigationLink(value: ContactCreationView.PushedView.username(isPop: true)) {
                LabeledContent {
                    Text(item.username)
                        .padding(.vertical, 8)
                } label: {
                    Label {
                        Text("User Name")
                    } icon: {
                        Image(systemSymbol: .personTextRectangle)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.background.quinary)
                    .stroke(.black.opacity(0.1))
            )

            NavigationLink(value: ContactCreationView.PushedView.avatar(isPop: true)) {
                LabeledContent {
                    if let avatar = item.avatar {
                        Text(avatar.icon)
                            .foregroundStyle(avatar.background.color)
                            .multilineTextAlignment(.center)
                            .frame(width: 40, height: 40, alignment: .center)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(avatar.background.color.secondary)
                            )
                    }
                } label: {
                    Label {
                        Text("Avatar")
                    } icon: {
                        Image(systemSymbol: .personCropCircle)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.background.quinary)
                    .stroke(.black.opacity(0.1))
            )

            NavigationLink(value: ContactCreationView.PushedView.phoneNumber(isPop: true)) {
                LabeledContent {
                    Text(item.phoneNumber)
                        .padding(.vertical, 8)
                } label: {
                    Label {
                        Text("Contact")
                    } icon: {
                        Image(systemSymbol: .phone)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.background.quinary)
                    .stroke(.black.opacity(0.1))
            )

            Spacer()

        }
        .padding(.horizontal)
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(uiColor: .systemGroupedBackground), ignoresSafeAreaEdges: .all)
        .safeAreaInset(edge: .bottom) {
            Button {
                withAnimation {
                    modelContext.insert(item)
                }
                action()
            } label: {
                Text("Create")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.extraLarge)
            .padding()
        }
        .navigationTitle("Review")
        .navigationBarTitleDisplayMode(.inline)
    }

}

#Preview {
    ContactCreationView()
}

#Preview("Name") {
    ContactNameCreation(isEdit: false) {}
        .environment(Item(timestamp: .now))
}


#Preview("Avatar") {
    ContactAvatarCreation(isEdit: false) {}
        .environment(Item(timestamp: .now))
}

#Preview("Phone Number") {
    ContactPhoneNumberCreation(isEdit: false) {}
        .environment(Item(timestamp: .now))
}

#Preview("Contact Review") {
    ContactReviewCreation {}
        .environment(
            Item(
                timestamp: .now,
                username: "Michael Ho",
                avatar: .init(icon: "😂", background: .fromColor(.red)),
                phoneNumber: "01234567890"
            )
        )
        .modelContainer(for: Item.self, inMemory: true)
}
