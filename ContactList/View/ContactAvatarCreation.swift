//
//  ContactAvatarCreation.swift
//  ContactList
//
//  Created by Ho Le Minh Thach on 7/8/24.
//

import SwiftUI
import EmojiPicker

struct ContactAvatarCreation: View {

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
                    .avatarStyle(background: selectedColor)
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

#Preview {
    ContactAvatarCreation(isEdit: false) {}
        .environment(Item(timestamp: .now))
}
