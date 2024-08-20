//
//  ContactReviewCreation.swift
//  ContactList
//
//  Created by Ho Le Minh Thach on 7/8/24.
//

import SwiftUI
import SFSafeSymbols

struct ContactReviewCreation: View {

    @Environment(\.dismiss) private var dismiss

    @Environment(\.modelContext) private var modelContext

    @Environment(Item.self) private var item

    @ScaledMetric var scale = 20

    let isEdit: Bool

    let action: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text(headline)
                    .font(.headline.weight(.regular))
                    .listStyle(.plain)
                    .padding(.vertical, 20)

                ReviewItemRow(
                    navigationValue: ContactCreationView.PushedView.username(isPop: true),
                    title: usernameLabel,
                    icon: .personTextRectangle
                ) {
                    Text(item.username)
                        .padding(.vertical, 8)
                }

                ReviewItemRow(
                    navigationValue: ContactCreationView.PushedView.avatar(isPop: true),
                    title: avatarLabel,
                    icon: .personCropCircle
                ) {
                    if let avatar = item.avatar {
                        Text(avatar.icon)
                            .avatarStyle(background: avatar.background.color, fontSize: scale, length: scale * 2, cornerRadius: 8)
                    }
                }

                ReviewItemRow(
                    navigationValue: ContactCreationView.PushedView.phoneNumber(isPop: true),
                    title: contactLabel,
                    icon: .phone
                ) {
                    Text(item.phoneNumber)
                        .padding(.vertical, 8)
                }

                ReviewItemRow(
                    navigationValue: ContactCreationView.PushedView.email(isPop: true),
                    title: emailLabel,
                    icon: .squareAndArrowUpFill
                ) {
                    Text(item.email)
                        .padding(.vertical, 8)
                }

                ReviewItemRow(
                    navigationValue: ContactCreationView.PushedView.linkedIn(isPop: true),
                    title: linkedInLabel,
                    image: .linkedIn
                ) {
                    Text(item.linkedInName)
                        .padding(.vertical, 8)
                }

                Spacer()

            }
            .padding(.horizontal)
            .buttonStyle(.plain)
        }
        .background(Color(uiColor: .systemGroupedBackground), ignoresSafeAreaEdges: .all)
        .safeAreaInset(edge: .bottom) {
            Button {
                withAnimation {
                    modelContext.insert(item)
                }
                if isEdit {
                    dismiss()
                }
                action()
            } label: {
                Text(buttonLabel)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.extraLarge)
            .padding()
        }
        .toolbar {
            if isEdit {
                ToolbarItem {
                    Button(role: .cancel) {
                        dismiss()
                    } label: {
                        Text(cancelLabel)
                    }
                }
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }

}

// MARK: - Attributes

private extension ContactReviewCreation {

    var headline: LocalizedStringKey {
        "You can tap the tile to edit the details."
    }

    var usernameLabel: LocalizedStringKey {
        "User Name"
    }

    var avatarLabel: LocalizedStringKey {
        "Avatar"
    }

    var contactLabel: LocalizedStringKey {
        "Contact"
    }

    var emailLabel: LocalizedStringKey {
        "Email"
    }

    var linkedInLabel: LocalizedStringKey {
        "LinkedIn"
    }

    var buttonLabel: LocalizedStringKey {
        isEdit ? "Save" : "Create"
    }

    var cancelLabel: LocalizedStringKey {
        "Cancel"
    }

    var navigationTitle: LocalizedStringKey {
        "Review"
    }

}

#Preview {
    ContactReviewCreation(isEdit: false) {}
        .environment(
            Item(
                timestamp: .now,
                username: "Michael Ho",
                avatar: .init(icon: "😂", background: .fromColor(.red)),
                phoneNumber: "01234567890",
                email: "thach.holeminh@gmail.com",
                linkedInName: "thach-ho"
            )
        )
        .modelContainer(for: Item.self, inMemory: true)
}
