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

    let item: Item

    @State private var animateGradient = false

    @State private var showConfirmationDialog = false

    @State private var presentedView: Bool = false

    @State private var path = NavigationPath()

    var body: some View {
        VStack {
            if let avatar = item.avatar {
                Text(avatar.icon)
                    .avatarStyle(background: avatar.background.color)
            }

            Text(item.username)
                .font(.largeTitle.bold())

            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Label("Phone Number", systemSymbol: .phoneFill)

                    Text(item.phoneNumber)
                        .font(.headline)
                }
                .detailRowStyle()
                .contextMenu {
                    Button {
                        UIPasteboard.general.string = item.phoneNumber
                    } label: {
                        Label("Copy", systemSymbol: .docOnDoc)
                    }

                    Button {
                        guard let url = URL(string: "tel://\(item.phoneNumber)") else { return }
                        UIApplication.shared.open(url)
                    } label: {
                        Label("Call", systemSymbol: .phoneFill)
                    }
                }

                VStack(spacing: 16) {
                    Label("Email", systemSymbol: .envelope)

                    Text(item.email)
                        .font(.headline)
                }
                .detailRowStyle()
                .contextMenu {
                    Button {
                        UIPasteboard.general.string = item.email
                    } label: {
                        Label("Copy", systemSymbol: .docOnDoc)
                    }

                    Button {
                        guard let url = URL(string: "mailto:\(item.email)") else { return }
                        UIApplication.shared.open(url)
                    } label: {
                        Label("Send Email", systemSymbol: .envelope)
                    }
                }

                VStack(spacing: 16) {
                    Label {
                        Text("LinkedIn")
                    } icon: {
                        Image(.linkedIn)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                    }

                    Text(item.linkedInName)
                        .font(.headline)
                }
                .detailRowStyle()
                .contextMenu {
                    Button {
                        UIPasteboard.general.string = item.linkedInName
                    } label: {
                        Label("Copy", systemSymbol: .docOnDoc)
                    }

                    Button {
                        guard let url = URL(string: "linkedin://profile/\(item.linkedInName)") else {
                            guard let webURL = URL(string: "https://www.linkedin.com/in/\(item.linkedInName)") else { return }
                            UIApplication.shared.open(webURL)
                            return
                        }
                        UIApplication.shared.open(url)
                    } label: {
                        Label("Open", image: .linkedIn)
                    }
                }

                Button {
                    presentedView = true
                } label: {
                    Text("Edit")
                        .padding(.horizontal, 4)
                }
                .buttonStyle(.bordered)
                .controlSize(.mini)
                .tint(.accentColor)
            }
            .padding(.horizontal)

            Spacer()

        }
        .frame(maxHeight: .infinity)
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Contact Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Button(role: .cancel) {
                    dismiss()
                } label: {
                    Text("Cancel")
                }

            }
        }
        .sheet(isPresented: $presentedView) {
            NavigationStack(path: $path) {
                ContactReviewCreation(isEdit: true) {
                    dismiss()
                }
                .navigationDestination(for: ContactCreationView.PushedView.self) { pushedView in
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
            .environment(item)
        }
        .safeAreaInset(edge: .bottom) {
            Button(role: .destructive) {
                showConfirmationDialog = true
            } label: {
                Text("Delete Contact")
                    .fontWeight(.medium)
            }
            .padding()
        }
        .confirmationDialog(
            "Are you sure you want to delete this contact?",
            isPresented: $showConfirmationDialog,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                modelContext.delete(item)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        }
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
