//
//  ContactAvatarCreation.swift
//  ContactList
//
//  Created by Ho Le Minh Thach on 7/8/24.
//

import SwiftUI
import SFSafeSymbols
import EmojiPicker

struct ContactAvatarCreation: View {

    @Environment(Item.self) private var item

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    @FocusState private var focusedField: Bool

    @State private var selectedEmoji: Emoji?
    @State private var displayEmojiPicker: Bool = true
    @State private var selectedColor: Color = .red

    private let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .indigo, .purple]

    let isEdit: Bool

    let action: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            Text(description)
                .font(.title.bold())

            Button {
                displayEmojiPicker = true
            } label: {
                Text(avatarLabel)
                    .avatarStyle(background: selectedColor)
            }
            .accessibilityLabel("Avatar")
            .sensoryFeedback(.impact(flexibility: .soft), trigger: selectedEmoji)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columnsCount)) {
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
                                    Image(systemSymbol: .checkmark)
                                        .foregroundStyle(.foreground)
                                }
                            }
                    }
                    .accessibilityLabel(color.description)
                }
                .accessibilityValue("Select \(selectedColor.description)")
            }

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
        .navigationTitle(navigationTitleParent)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $displayEmojiPicker) {
            NavigationView {
                EmojiPickerView(selectedEmoji: $selectedEmoji)
                    .navigationTitle(navigationTitleChild)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .presentationDetents([.medium, .large])
        }
        .onAppear {
            handleOnAppear()
        }
    }

    // MARK: - Logic

    private var columnsCount: Int {
        dynamicTypeSize.isAccessibilitySize ? 4 : 7
    }

    private var isDisable: Bool {
        guard let avatar = item.avatar else { return false }
        return isEdit && selectedEmoji?.value ?? "" == avatar.icon && selectedColor == avatar.background.color || selectedEmoji == nil
    }

    private func handleButtonPressed() {
        guard let selectedEmoji else {
            return
        }
        item.avatar = .init(icon: selectedEmoji.value, background: .fromColor(selectedColor))
        action()
    }

    private func handleOnAppear() {
        if let avatar = item.avatar {
            selectedEmoji = .init(value: avatar.icon, name: "")
            selectedColor = avatar.background.color
        }
    }

}

// MARK: - Attributes

private extension ContactAvatarCreation {

    var description: LocalizedStringKey {
        "Choose an Emoji"
    }

    var avatarLabel: String {
        selectedEmoji?.value ?? "?"
    }

    var buttonLabel: LocalizedStringKey {
        isEdit ? "Save" : "Continue"
    }

    var navigationTitleParent: LocalizedStringKey {
        "Avatar"
    }

    var navigationTitleChild: LocalizedStringKey {
        "Emojis"
    }

}

#Preview {
    ContactAvatarCreation(isEdit: false) {}
        .environment(Item(timestamp: .now))
}
