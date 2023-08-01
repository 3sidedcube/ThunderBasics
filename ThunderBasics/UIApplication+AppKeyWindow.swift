//
//  UIApplication+AppKeyWindow.swift
//  ThunderBasics-iOS
//
//  Created by Marliza on 01/08/2023.
//  Copyright © 2023 threesidedcube. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    /// Get key window for application
    /// - Returns `UIWindow?`
    var appKeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first { $0.isKeyWindow }
    }
}
