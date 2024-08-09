//
//  Avatar.swift
//  ContactList
//
//  Created by Ho Le Minh Thach on 7/8/24.
//

import SwiftUI

extension View {

    func avatarStyle(
        background: Color,
        fontSize: CGFloat = 50,
        length: CGFloat = 100,
        cornerRadius: CGFloat = 25
    ) -> some View {
        self
            .foregroundStyle(background)
            .font(.system(size: fontSize))
            .multilineTextAlignment(.center)
            .frame(width: length, height: length, alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundStyle(background.secondary)
            )
    }

    func detailRowStyle() -> some View {
        self
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .background(.background.tertiary, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

}
