//
//  UIView+AutoLayout.swift
//  ThunderBasics
//
//  Created by Simon Mitchell on 05/02/2018.
//  Copyright © 2018 threesidedcube. All rights reserved.
//

import Foundation

extension UIView {
	
	@discardableResult
	func fromNib<T : UIView>() -> T? {
		guard let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as? T else {    // 3
			// xib not loaded, or it's top view is of the wrong type
			return nil
		}
		addSubview(view)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.attachEdges(to: self)
		return view
	}
	
	public func attachEdges(_ edges: [NSLayoutAttribute] = [.left, .right, .top, .bottom], to childView:UIView)
	{
		
		childView.translatesAutoresizingMaskIntoConstraints = false
		
		let constraints: [NSLayoutConstraint] = edges.map({
			return NSLayoutConstraint(item: childView, attribute: $0, relatedBy: .equal, toItem: self, attribute: $0, multiplier: 1.0, constant: 0)
		})
		
		childView.addConstraints(constraints)
	}
}
