//
//  Navigation.swift
//  GNAH
//
//  Created by Simon Mitchell on 14/08/2017.
//  Copyright © 2017 3sidedcube. All rights reserved.
//

import UIKit

public extension UIViewController {
	
	/// Pops to the most recent view controller in the stack which is of a particular class
	///
	/// - Parameters:
	///   - viewControllerClass: The class of view controller to pop to
	///   - animated: Whether to animate the transition
	/// - Returns: A boolean as to whether a view controller of this class was popped to or not
	public func popToLastViewController(of viewControllerClass: AnyClass, allowSubclasses: Bool = false, animated: Bool = true) -> Bool {
		
		guard let previousViewController = navigationController?.viewControllers.filter({ (viewController) -> Bool in
			return (allowSubclasses ? viewController.isKind(of: viewControllerClass) : viewController.isMember(of: viewControllerClass))  && viewController != self
		}).last else { return false }
		
		navigationController?.popToViewController(previousViewController, animated: animated)
		return true
	}
	
	/// Pops to the most recent view controller which isn't a member of any of the classes we don't want to pop to
	///
	/// - Parameters:
	///   - classes: Classes of view controller to avoid popping to
	///   - animated: Whether to animate the transition
	/// - Returns: A boolean as to whether a valid view controller was found and popped to or not
	@discardableResult public func popToLastViewController(excluding classes: [AnyClass], allowSubclasses: Bool = false, animated: Bool = true) -> Bool {
		
		guard let previousViewController = navigationController?.viewControllers.filter({ (viewController) -> Bool in
			// If there is a class which this view controller is a member of, then don't allow popping to it
			let isOneOfClass = classes.first(where: { (vcClass) -> Bool in
				return allowSubclasses ? viewController.isKind(of: vcClass) : viewController.isMember(of: vcClass)
			}) != nil
			
			return !isOneOfClass && viewController != self
		}).last else { return false }
		
		navigationController?.popToViewController(previousViewController, animated: animated)
		return true
	}
}
