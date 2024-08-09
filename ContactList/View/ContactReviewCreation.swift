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

    let isEdit: Bool = false

    let action: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("You can tap the tile to edit the details.")
                .font(.headline.weight(.regular))
                .listStyle(.plain)
                .padding(.vertical, 20)

            ReviewItemRow(
                navigationValue: ContactCreationView.PushedView.username(isPop: true),
                title: "User Name",
                icon: .personTextRectangle
            ) {
                Text(item.username)
                    .padding(.vertical, 8)
            }
            ReviewItemRow(
                navigationValue: ContactCreationView.PushedView.avatar(isPop: true),
                title: "Avatar",
                icon: .personCropCircle
            ) {
                if let avatar = item.avatar {
                    Text(avatar.icon)
                        .avatarStyle(background: avatar.background.color, fontSize: 20, length: 40, cornerRadius: 8)
                }
            }

            ReviewItemRow(
                navigationValue: ContactCreationView.PushedView.phoneNumber(isPop: true),
                title: "Contact",
                icon: .phone) {
                    Text(item.phoneNumber)
                        .padding(.vertical, 8)
                }

            ReviewItemRow(
                navigationValue: ContactCreationView.PushedView.email(isPop: true),
                title: "Email",
                icon: .envelope
            ) {
                Text(item.email)
                    .padding(.vertical, 8)
            }

            ReviewItemRow(
                navigationValue: ContactCreationView.PushedView.linkedIn(isPop: true),
                title: "LinkedIn",
                image: .linkedIn
            ) {
                Text(item.linkedInName)
                    .padding(.vertical, 8)
            }

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
    ContactReviewCreation {}
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
