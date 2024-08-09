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
                            path.append(PushedView.email(isPop: false))
                        }
                    }
                case .email(let isPop):
                    ContactEmailCreationView(isEdit: isPop) {
                        if isPop {
                            path.removeLast()
                        } else {
                            path.append(PushedView.linkedIn(isPop: false))
                        }
                    }
                case .linkedIn(let isPop):
                    ContactLinkedInCreation(isEdit: isPop) {
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

#Preview("Contact Review") {
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
