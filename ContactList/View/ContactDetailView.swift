//
//  ContactDetailView.swift
//  ContactList
//
//  Created by Ho Le Minh Thach on 6/8/24.
//

import SwiftUI

struct ContactDetailView: View {

    @Environment(\.modelContext) private var modelContext

    @Environment(\.dismiss) private var dismiss

    @ScaledMetric(wrappedValue: 20, relativeTo: .body) var scale

    let item: Item

    @State private var animateGradient = false

    @State private var showConfirmationDialog = false

    @State private var presentedView: Bool = false

    @State private var path = NavigationPath()

    var body: some View {
        ScrollView {
            if let avatar = item.avatar {
                Text(avatar.icon)
                    .avatarStyle(background: avatar.background.color)
                    .accessibilityLabel("Avatar")
            }

            Text(item.username)
                .font(.largeTitle.bold())

            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Label(phoneNumberLabel, systemSymbol: .phoneFill)
                    Text(item.phoneNumber)
                        .font(.headline)
                }
                .detailRowStyle()
                .contextMenu {
                    Button {
                        UIPasteboard.general.string = item.phoneNumber
                    } label: {
                        Label(copyLabel, systemSymbol: .docOnDoc)
                    }

                    Button {
                        guard let url = URL(string: "tel://\(item.phoneNumber)") else { return }
                        UIApplication.shared.open(url)
                    } label: {
                        Label(callLabel, systemSymbol: .phoneFill)
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityHint("Triple tap to see the context menu")
                .accessibilityAddTraits(.allowsDirectInteraction)
                .accessibilityInputLabels([phoneNumberLabel])

                VStack(spacing: 16) {
                    Label(emailLabel, systemSymbol: .envelope)
                    Text(item.email)
                        .font(.headline)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                }
                .detailRowStyle()
                .contextMenu {
                    Button {
                        UIPasteboard.general.string = item.email
                    } label: {
                        Label(copyLabel, systemSymbol: .docOnDoc)
                    }

                    Button {
                        guard let url = URL(string: "mailto:\(item.email)") else { return }
                        UIApplication.shared.open(url)
                    } label: {
                        Label(sendEmailLabel, systemSymbol: .envelope)
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityHint("Triple tap to see the context menu")
                .accessibilityAddTraits(.allowsDirectInteraction)
                .accessibilityInputLabels([emailLabel])

                VStack(spacing: 16) {
                    Label {
                        Text(linkedInLabel)
                    } icon: {
                        Image(.linkedIn)
                            .resizable()
                            .scaledToFit()
                            .frame(width: scale)
                    }
                    Text(item.linkedInName)
                        .font(.headline)
                }
                .detailRowStyle()
                .contextMenu {
                    Button {
                        UIPasteboard.general.string = item.linkedInName
                    } label: {
                        Label(copyLabel, systemSymbol: .docOnDoc)
                    }

                    Button {
                        guard let url = URL(string: "linkedin://profile/\(item.linkedInName)") else {
                            guard let webURL = URL(string: "https://www.linkedin.com/in/\(item.linkedInName)") else { return }
                            UIApplication.shared.open(webURL)
                            return
                        }
                        UIApplication.shared.open(url)
                    } label: {
                        Label(openLabel, image: .linkedIn)
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityHint("Triple tap to see the context menu")
                .accessibilityAddTraits(.allowsDirectInteraction)
                .accessibilityInputLabels([linkedInLabel])

                Button(role: .destructive) {
                    showConfirmationDialog = true
                } label: {
                    Text(deleteButtonLabel)
                        .fontWeight(.medium)
                }
                .padding()
            }
            .padding(.horizontal)
        }
        .scrollBounceBehavior(.basedOnSize)
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                presentedView = true
            } label: {
                Text(editButtonLabel)
                    .padding(.horizontal, 4)
            }
            .buttonStyle(.bordered)
            .controlSize(.mini)
            .tint(.accentColor)
        }
        .sheet(isPresented: $presentedView) {
            NavigationStack(path: $path) {
                ContactReviewCreation(isEdit: true) {}
                .navigationDestination(for: ContactCreationView.PushedView.self, destination: navigateDestination)
            }
            .environment(item)
        }
        .confirmationDialog(confirmationTitle, isPresented: $showConfirmationDialog, titleVisibility: .visible) {
            Button(confirmationButtonLabel, role: .destructive) {
                modelContext.delete(item)
                dismiss()
            }
            Button(confirmationButtonCancelLabel, role: .cancel) { }
        }
    }

    // MARK: - Logic

    @ViewBuilder
    private func navigateDestination(pushedView: ContactCreationView.PushedView) -> some View {
        switch pushedView {
        case .username(let isPop):
            ContactNameCreation(isEdit: isPop) {
                if isPop {
                    path.removeLast()
                } else {
                    path.append(ContactCreationView.PushedView.avatar(isPop: false))
                }
            }
        case .avatar(let isPop):
            ContactAvatarCreation(isEdit: isPop) {
                if isPop {
                    path.removeLast()
                } else {
                    path.append(ContactCreationView.PushedView.phoneNumber(isPop: false))
                }
            }
        case .phoneNumber(let isPop):
            ContactPhoneNumberCreation(isEdit: isPop) {
                if isPop {
                    path.removeLast()
                } else {
                    path.append(ContactCreationView.PushedView.email(isPop: false))
                }
            }
        case .email(let isPop):
            ContactEmailCreationView(isEdit: isPop) {
                if isPop {
                    path.removeLast()
                } else {
                    path.append(ContactCreationView.PushedView.email(isPop: false))
                }
            }
        case .linkedIn(isPop: let isPop):
            ContactLinkedInCreation(isEdit: isPop) {
                if isPop {
                    path.removeLast()
                } else {
                    path.append(ContactCreationView.PushedView.linkedIn(isPop: false))
                }
            }
        case .review:
            ContactReviewCreation(isEdit: false) {
                dismiss()
            }
        }
    }

}

// MARK: - Attributes

private extension ContactDetailView {

    var description: LocalizedStringKey {
        "Please provide the contact number."
    }

    var placeholder: LocalizedStringKey {
        "+61 123 567 890"
    }

    var editButtonLabel: LocalizedStringKey {
        "Edit"
    }

    var navigationTitle: LocalizedStringKey {
        "Contact Detail"
    }

    var deleteButtonLabel: LocalizedStringKey {
        "Delete Contact"
    }

    var confirmationTitle: LocalizedStringKey {
        "Are you sure you want to delete this contact?"
    }

    var confirmationButtonLabel: LocalizedStringKey {
        "Delete"
    }

    var confirmationButtonCancelLabel: LocalizedStringKey {
        "Cancel"
    }

    var phoneNumberLabel: LocalizedStringKey {
        "Phone Number"
    }

    var copyLabel: LocalizedStringKey {
        "Copy"
    }

    var callLabel: LocalizedStringKey {
        "Call"
    }

    var emailLabel: LocalizedStringKey {
        "Email"
    }

    var sendEmailLabel: LocalizedStringKey {
        "Send Email"
    }

    var linkedInLabel: LocalizedStringKey {
        "LinkedIn"
    }

    var openLabel: LocalizedStringKey {
        "Open"
    }

}

#Preview {
    ContactDetailView(
        item: .init(
            timestamp: .now,
            username: "Michael Ho",
            avatar: .init(icon: "😂", background: .fromColor(.red)),
            phoneNumber: "0866116174",
            email: "thach.holeminh@gmail.com", 
            linkedInName: "thach-ho"
        )
    )
}
