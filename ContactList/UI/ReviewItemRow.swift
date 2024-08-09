//
//  ReviewItemRow.swift
//  ContactList
//
//  Created by Ho Le Minh Thach on 7/8/24.
//

import SwiftUI
import SFSafeSymbols

struct ReviewItemRow: View {
    let navigationValue: any Hashable
    let title: String
    let icon: SFSymbol?
    let image: ImageResource?
    let content: AnyView

    init<T: View>(navigationValue: any Hashable, title: String, icon: SFSymbol, @ViewBuilder content: @escaping () -> T) {
        self.navigationValue = navigationValue
        self.title = title
        self.icon = icon
        self.image = nil
        self.content = AnyView(content())
    }

    init<T: View>(navigationValue: any Hashable, title: String, image: ImageResource, @ViewBuilder content: @escaping () -> T) {
        self.navigationValue = navigationValue
        self.title = title
        self.icon = nil
        self.image = image
        self.content = AnyView(content())
    }

    var body: some View {
        NavigationLink(value: navigationValue) {
            LabeledContent {
                content
            } label: {
                Label {
                    Text(title)
                } icon: {
                    if let icon {
                        Image(systemSymbol: icon)
                    } else if let image {
                        Image(image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.background.quinary)
        )
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ReviewItemRow(
        navigationValue: ContactCreationView.PushedView.username(isPop: true),
        title: "User Name",
        icon: .personTextRectangle
    ) {
        Text("Test")
            .padding(.vertical, 8)
    }
    .padding()
    .background(Color(uiColor: .systemGroupedBackground))
}

#Preview(traits: .sizeThatFitsLayout) {
    ReviewItemRow(
        navigationValue: ContactCreationView.PushedView.username(isPop: true),
        title: "User Name",
        image: .linkedIn
    ) {
        Text("Test")
            .padding(.vertical, 8)
    }
    .padding()
    .background(Color(uiColor: .systemGroupedBackground))
}
