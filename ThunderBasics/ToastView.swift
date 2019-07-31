//
//  ToastView.swift
//  ThunderBasics
//
//  Created by Simon Mitchell on 02/11/2018.
//  Copyright © 2018 threesidedcube. All rights reserved.
//

import UIKit

/// A closure for when a toast view is tapped
public typealias ToastActionHandler = (_ toastView: ToastView) -> Void

/// A visual representation of a `Toast` that will be displayed to the user from the top of their screen
public class ToastView: UIView {
    
    /// The action to be called if the user taps the toast
    var action: ToastActionHandler?
    
    /// The colour of the text in the notification view
    @objc public dynamic var textColour: UIColor = .black {
        didSet {
            titleLabel.textColor = textColour
            messageLabel.textColor = textColour
        }
    }
    
    /// The colour of the text in the notification view
    @objc public dynamic var visibleDuration: CGFloat = 2.0
    
    private let titleLabel = UILabel()
    
    private let messageLabel = UILabel()
    
    private let imageView = UIImageView()
    
    @objc public dynamic var insets: UIEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

    /// Creates a toast view with a title, message and image
    ///
    /// - Parameters:
    ///   - title: The title text to display on the toast
    ///   - message: The message text to display on the toast
    ///   - image: The image to display on the left hand side of the toast
    ///   - action: The action to be called if the user taps the toast
    public init(title: String?, message: String?, image: UIImage?, action: ToastActionHandler?) {
        
        super.init(frame: .zero)
        
        if #available(iOS 11.0, *) {
            titleLabel.font = UIFont.dynamicSystemFont(ofSize: 18, withTextStyle: .headline, weight: .bold)
        } else {
            titleLabel.font = UIFont.preferredFont(forTextStyle: .headline, scaledBy: 18.0/17.0).withWeight(.bold)
        }
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.text = title
        titleLabel.textColor = textColour
        
        if #available(iOS 11.0, *) {
            messageLabel.font = UIFont.dynamicSystemFont(ofSize: 16, withTextStyle: .subheadline)
        } else {
            messageLabel.font = UIFont.preferredFont(forTextStyle: .subheadline, scaledBy: 16.0/16.0)
        }
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.text = message
        messageLabel.textColor = textColour
        
        imageView.image = image
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(messageLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private var coverWindow: UIWindow?
    
    private var animator: UIDynamicAnimator?
    
    private var gravity: UIGravityBehavior?
    
    private var completion: (() -> Void)?
    
    /// Shows the toast notification on the screen
    ///
    /// - Parameter completion: A completion block to be called when the toast notification has displayed and dismissed successfully
    public func show(completion: @escaping () -> Void) {
        
        frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44) // Add on 40 points so when it drops down you can't see the view behind it.
        layout()
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: bounds.height))
        
        transform = CGAffineTransform(translationX: 0, y: -frame.height)
        
        coverWindow = UIWindow(frame: bounds)
        coverWindow?.isHidden = false
        coverWindow?.windowLevel = UIWindow.Level.statusBar + 1
        
        let toastViewController = ToastViewController()
        toastViewController.statusBarStyle = window?.visibleViewController?.preferredStatusBarStyle ?? .default
        
        coverWindow?.rootViewController = toastViewController
        coverWindow?.backgroundColor = .clear
        coverWindow?.rootViewController?.view.addSubview(containerView)
        containerView.addSubview(self)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        coverWindow?.addGestureRecognizer(tapGesture)
        
        animator = UIDynamicAnimator(referenceView: containerView)
        
        let _gravity = UIGravityBehavior(items: [self])
        gravity = _gravity
        _gravity.gravityDirection = CGVector(dx: 0.0, dy: 1.0)
        animator?.addBehavior(_gravity)
        
        let elasticBehaviour = UIDynamicItemBehavior(items: [self])
        elasticBehaviour.elasticity = 0.3
        animator?.addBehavior(elasticBehaviour)
        
        let collisionBehaviour = UICollisionBehavior(items: [self])
        collisionBehaviour.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets(top: -self.frame.height-10, left: -10, bottom: 1, right: -10))
        animator?.addBehavior(collisionBehaviour)
        
        self.completion = completion
        
        let dismissTime = DispatchTime.now() + Double(visibleDuration) + 0.7
        DispatchQueue.main.asyncAfter(deadline: dismissTime) { [weak self] in
            guard let self = self else { return }
            self.dismiss()
        }
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        action?(self)
    }
    
    /// The size that the image provided to the toast view will be rendered at. Defaults to 38x38pts.
    public var imageSize: CGSize = CGSize(width: 38, height: 38)
    
    /// The amount of padding to add to the right of the image view when provided. Defaults to 12pts.
    public var imageViewRightMargin: CGFloat = 12.0
    
    private func layout() {
        
        var safeAreaInsets: UIEdgeInsets = .zero
        if #available(iOS 11.0, *) {
            safeAreaInsets = UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets ?? .zero
        }
        
        var labelContainerFrame = CGRect(
            x: insets.left + safeAreaInsets.left,
            y: insets.top + safeAreaInsets.top,
            width: frame.width - (insets.left + safeAreaInsets.left) - (insets.right + safeAreaInsets.right),
            height: .greatestFiniteMagnitude
        )
        
        // If we have an image adjust how much room we have for the labels.
        if imageView.image != nil {
            imageView.frame = CGRect(x: insets.left + safeAreaInsets.left, y: 0, width: imageSize.width, height: imageSize.height)
            labelContainerFrame.origin.x += imageViewRightMargin + imageSize.width
            labelContainerFrame.size.width -= imageViewRightMargin + imageSize.width
        }
        
        let titleSize = titleLabel.sizeThatFits(labelContainerFrame.size)
        titleLabel.frame = CGRect(origin: labelContainerFrame.origin, size: titleSize)
        
        let messageSize = messageLabel.sizeThatFits(labelContainerFrame.size)
        messageLabel.frame = CGRect(origin: labelContainerFrame.offsetBy(dx: 0, dy: titleLabel.frame.height).origin, size: messageSize)
        
        // Minimum height of 44pts
        let height = max(messageLabel.frame.maxY + insets.bottom, 44)
        frame = CGRect(x: 0, y: -height, width: frame.width, height: height)
        imageView.center.y = frame.height/2
    }
    
    private func dismiss() {
        
        if let gravity = gravity {
            animator?.removeBehavior(gravity)
        }
        animator?.removeAllBehaviors()
        
        let gravityBehaviour = UIGravityBehavior(items: [self])
        gravityBehaviour.gravityDirection = CGVector(dx: 0, dy: -2.4)
        animator?.addBehavior(gravityBehaviour)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            guard let self = self else { return }
            self.cleanUp()
        }
    }
    
    private func cleanUp() {
        
        coverWindow?.isHidden = true
        removeFromSuperview()
        completion?()
    }
}
