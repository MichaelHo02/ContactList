//
//  ReviewItemRow.swift
//  ContactList
//
//  Created by Ho Le Minh Thach on 7/8/24.
//

import SwiftUI
import SFSafeSymbols

struct ReviewItemRow: View {

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    @ScaledMetric(wrappedValue: 20, relativeTo: .body) var scale

    let navigationValue: any Hashable
    let title: LocalizedStringKey
    let icon: SFSymbol?
    let image: ImageResource?
    let content: AnyView

    init<T: View>(navigationValue: any Hashable, title: LocalizedStringKey, icon: SFSymbol, @ViewBuilder content: @escaping () -> T) {
        self.navigationValue = navigationValue
        self.title = title
        self.icon = icon
        self.image = nil
        self.content = AnyView(content())
    }

    init<T: View>(navigationValue: any Hashable, title: LocalizedStringKey, image: ImageResource, @ViewBuilder content: @escaping () -> T) {
        self.navigationValue = navigationValue
        self.title = title
        self.icon = nil
        self.image = image
        self.content = AnyView(content())
    }

    var body: some View {
        NavigationLink(value: navigationValue) {
            if dynamicTypeSize.isAccessibilitySize {
                VStack {
                    Text(title)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    content
                }
                .frame(maxWidth: .infinity)
            } else {
                HStack {
                    if let icon {
                        Image(systemSymbol: icon)
                    } else if let image {
                        Image(image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: scale)
                    }

                    Text(title)
                    Spacer()
                    content
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.background.quinary)
        )
        .accessibilityElement(children: .combine)
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
