//
//  AccessibilityRefreshingViewController.swift
//  ThunderBasics-iOS
//
//  Created by Simon Mitchell on 21/08/2019.
//  Copyright © 2019 threesidedcube. All rights reserved.
//

import UIKit

/// A UIViewController which subscribes to accessibility setting change notifications such as `darkerSystemColorsStatusDidChangeNotification` and calls an overrideable function whenever they do change.
open class AccessibilityRefreshingViewController: UIViewController, UIContentSizeCategoryAdjusting {
    
    /// Observer listening to dynamic font changes
    private var dynamicChangeObserver: NSObjectProtocol?
    
    /// Observer listening to accessibility setting changed notifications
    private var accessibilityObservers: [Any] = []

    public var adjustsFontForContentSizeCategory: Bool = true
    
    /// A list of notification names that should cause the table view to redraw itself
    public var accessibilityRedrawNotificationNames: [Notification.Name] = [
        UIAccessibility.darkerSystemColorsStatusDidChangeNotification,
        UIAccessibility.boldTextStatusDidChangeNotification,
        UIAccessibility.grayscaleStatusDidChangeNotification,
        UIAccessibility.invertColorsStatusDidChangeNotification,
        UIAccessibility.reduceTransparencyStatusDidChangeNotification
    ]
    
    open override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        dynamicChangeObserver = NotificationCenter.default.addObserver(forName: UIContentSizeCategory.didChangeNotification, object: self, queue: .main) { [weak self] (notification) in
            guard let strongSelf = self, strongSelf.adjustsFontForContentSizeCategory else { return }
            strongSelf.accessibilitySettingsDidChange()
        }
        
        // Notification names that it makes sense to redraw on
        let accessibilityNotifications: [Notification.Name] = [
            UIAccessibility.darkerSystemColorsStatusDidChangeNotification,
            UIAccessibility.assistiveTouchStatusDidChangeNotification,
            UIAccessibility.boldTextStatusDidChangeNotification,
            UIAccessibility.grayscaleStatusDidChangeNotification,
            UIAccessibility.guidedAccessStatusDidChangeNotification,
            UIAccessibility.invertColorsStatusDidChangeNotification,
            UIAccessibility.reduceMotionStatusDidChangeNotification,
            UIAccessibility.reduceTransparencyStatusDidChangeNotification
        ]
        
        accessibilityObservers = accessibilityNotifications.map({ (notificationName) -> Any in
            return NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: .main, using: { [weak self] (notification) in
                guard let strongSelf = self, strongSelf.accessibilityRedrawNotificationNames.contains(notification.name) else {
                    return
                }
                strongSelf.accessibilitySettingsDidChange()
            })
        })
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        accessibilityObservers.forEach { (observer) in
            NotificationCenter.default.removeObserver(observer)
        }
        accessibilityObservers = []
        guard let dynamicChangeObserver = dynamicChangeObserver else { return }
        NotificationCenter.default.removeObserver(dynamicChangeObserver)
    }
    
    /// A function called when accessibility settings on-device changed. Has no default implementation.
    open func accessibilitySettingsDidChange() {
        
    }
}
