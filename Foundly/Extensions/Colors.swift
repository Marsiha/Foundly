//
//  Colors.swift
//  Foundly
//
//  Created by mars uzhanov on 19.02.2025.
//

import UIKit

public extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let b = CGFloat(rgb & 0x0000FF) / 255

        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}


extension UIColor {
    static let foundlyPrimaryDark: UIColor = UIColor { trait in
        return trait.userInterfaceStyle == .dark ?
            UIColor(hex: "#3D0066") : // light mode value
            UIColor(hex: "#C86BFA")   // dark mode value
    }

    static let foundlySecondary: UIColor = UIColor { trait in
        return trait.userInterfaceStyle == .dark ?
            UIColor(hex: "#5C0099") :
            UIColor(hex: "#C86BFA")
    }

    static let foundlyAccent: UIColor = UIColor { trait in
        return trait.userInterfaceStyle == .dark ?
            UIColor(hex: "#C86BFA") :
            UIColor(hex: "#3D0066")
    }

    static let foundlySuccess = UIColor(hex: "#28A745")
    static let foundlyWarning = UIColor(hex: "#FFC107")
    static let foundlyError   = UIColor(hex: "#DC3545")

    static let foundlyBlack: UIColor = UIColor { trait in
        return trait.userInterfaceStyle == .dark ?
            UIColor(hex: "#E5E5E5") :
            UIColor(hex: "#F7F7F7")
    }

    static let foundlyBlack800 = UIColor { trait in
        return trait.userInterfaceStyle == .dark ?
            UIColor(hex: "#4B4B4B") :
            UIColor(hex: "#AFAFAF")
    }
    
    static let foundlyBlack700 = UIColor { trait in
        return trait.userInterfaceStyle == .dark ?
            UIColor(hex: "#777777") :
            UIColor(hex: "#AFAFAF")
    }
    
    static let foundlyBlack300 = UIColor { trait in
        return trait.userInterfaceStyle == .dark ?
            UIColor(hex: "#AFAFAF") :
            UIColor(hex: "#4B4B4B")
    }

    static let foundlySwan: UIColor = UIColor { trait in
        return trait.userInterfaceStyle == .dark ?
            UIColor(hex: "#E5E5E5") :
            UIColor(hex: "#261C31")
    }

    static let foundlyPolar: UIColor = UIColor { trait in
        return trait.userInterfaceStyle == .dark ?
            UIColor(hex: "#F7F7F7") :
            UIColor(hex: "#1A1025")
    }
}

