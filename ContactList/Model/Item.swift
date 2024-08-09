//
//  Item.swift
//  ContactList
//
//  Created by Ho Le Minh Thach on 3/8/24.
//

import SwiftUI
import SwiftData

@Model
final class Item {

    public var timestamp: Date
    public var username: String
    public var avatar: Avatar?
    public var phoneNumber: String
    public var email: String
    public var linkedInName: String

    init(timestamp: Date) {
        self.timestamp = timestamp
        self.username = ""
        self.avatar = nil
        self.phoneNumber = ""
        self.email = ""
        self.linkedInName = ""
    }

    init(timestamp: Date, username: String, avatar: Avatar?, phoneNumber: String, email: String, linkedInName: String) {
        self.timestamp = timestamp
        self.username = username
        self.avatar = avatar
        self.phoneNumber = phoneNumber
        self.email = email
        self.linkedInName = linkedInName
    }

    public struct Avatar: Codable {
        var icon: String
        var background: ColorComponents
    }

}

struct ColorComponents: Codable {

    let red: Float
    let green: Float
    let blue: Float

    var color: Color {
        Color(red: Double(red), green: Double(green), blue: Double(blue))
    }

    static func fromColor(_ color: Color) -> ColorComponents {
        let resolved = color.resolve(in: EnvironmentValues())
        return ColorComponents(
            red: resolved.red,
            green: resolved.green,
            blue: resolved.blue
        )
    }

}
