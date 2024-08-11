//
//  ItemRow.swift
//  ContactList
//
//  Created by Ho Le Minh Thach on 3/8/24.
//

import SwiftUI

struct ItemRow: View {

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    let item: Item

    var body: some View {
        HStack {
            if let avatar = item.avatar, dynamicTypeSize.isAccessibilitySize == false {
                Text(avatar.icon)
                    .font(.title)
                    .scaledToFit()
                    .foregroundStyle(avatar.background.color)
                    .multilineTextAlignment(.center)
                    .frame(width: 50, height: 50, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(avatar.background.color.secondary)
                    )
                    .accessibilityLabel("Avatar")
                    .accessibilityValue(item.username)
            }

            VStack(alignment: .leading) {
                Text(item.username)
                    .font(.headline)

                Text("Created on: \(item.timestamp.formatted(date: .abbreviated, time: .omitted))")
                    .font(.subheadline)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityInputLabels([item.username])
    }

}

#Preview(traits: .sizeThatFitsLayout) {
    ItemRow(item: .init(
        timestamp: .now,
        username: "Michael Ho",
        avatar: .init(icon: "😂", background: .fromColor(.red)),
        phoneNumber: "098 765 432 10",
        email: "thach.holeminh@gmail.com",
        linkedInName: "thach-ho"
    ))
    .padding()
}
