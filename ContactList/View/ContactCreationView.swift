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
        case email(isPop: Bool)
        case linkedIn(isPop: Bool)
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
                        Text(cancelLabel)
                    }
                }
            }
            .navigationDestination(for: Self.PushedView.self, destination: navigateDestination)
        }
        .environment(item)
    }

    // MARK: - Logic

    @ViewBuilder
    private func navigateDestination(pushedView: PushedView) -> some View {
        switch pushedView {
        case .username(let isPop):
            ContactNameCreation(isEdit: isPop) {
                isPop ? path.removeLast() : path.append(PushedView.avatar(isPop: false))
            }
        case .avatar(let isPop):
            ContactAvatarCreation(isEdit: isPop) {
                isPop ? path.removeLast() : path.append(PushedView.phoneNumber(isPop: false))
            }
        case .phoneNumber(let isPop):
            ContactPhoneNumberCreation(isEdit: isPop) {
                isPop ? path.removeLast() : path.append(PushedView.email(isPop: false))
            }
        case .email(let isPop):
            ContactEmailCreationView(isEdit: isPop) {
                isPop ? path.removeLast() : path.append(PushedView.linkedIn(isPop: false))
            }
        case .linkedIn(let isPop):
            ContactLinkedInCreation(isEdit: isPop) {
                isPop ? path.removeLast() : path.append(PushedView.review)
            }
        case .review:
            ContactReviewCreation(isEdit: false) {
                dismiss()
            }
        }
    }

}

// MARK: - Attributes

private extension ContactCreationView {

    var cancelLabel: String {
        "Cancel"
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

#Preview("Email") {
    ContactEmailCreationView(isEdit: false) {}
        .environment(Item(timestamp: .now))
}

#Preview("LinkedIn") {
    ContactLinkedInCreation(isEdit: false) {}
        .environment(Item(timestamp: .now))
}

#Preview("Contact Review") {
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
