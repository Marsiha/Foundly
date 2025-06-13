//
//  Colors.swift
//  Foundly
//
//  Created by mars uzhanov on 19.02.2025.
//

import UIKit

public extension UIColor {
    convenience init(hex: UInt32) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        guard let intHex = UInt32(hexSanitized, radix: 16) else {
            fatalError("Incorrect string hex")
        }

        self.init(hex: intHex)
    }
}

extension UIColor {
    static let foundlyPrimaryDark = UIColor(hex: "3D0066")
    static let foundlySecondary = UIColor(hex: "5C0099")
    static let foundlyAccent = UIColor(hex: "C86BFA")
    static let foundlySuccess = UIColor(hex: "28A745")
    static let foundlyWarning = UIColor(hex: "FFC107")
    static let foundlyError = UIColor(hex: "DC3545")
    static let foundlyBlack = UIColor(hex: "E5E5E5")
    static let foundlyBlack800 = UIColor(hex: "4B4B4B")
    static let foundlyBlack700 = UIColor(hex: "777777")
    static let foundlyBlack300 = UIColor(hex: "AFAFAF")
    static let foundlySwan = UIColor(hex: "E5E5E5")
    static let foundlyPolar = UIColor(hex: "F7F7F7")
}
