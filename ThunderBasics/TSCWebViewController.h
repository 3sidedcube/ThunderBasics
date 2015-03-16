//
//  TSCWebViewController.h
//  ThunderStorm
//
//  Created by Phillip Caudell on 27/09/2013.
//  Copyright (c) 2013 3 SIDED CUBE. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 An ease of use subclass of `UIViewController` for displaying web pages.
 By default the `TSCWebViewController` has:
 - Back and forward buttons.
 - Pull to refresh.
 */
@interface TSCWebViewController : UIViewController <UIWebViewDelegate, UIScrollViewDelegate>

/**
 @abstract The UIWebView which is being displayed by the `TSCWebViewController`.
 */
@property (nonatomic, strong) UIWebView *webView;

/**
 @abstract The current url which is loaded by the `TSCWebViewController`.
 */
@property (nonatomic, strong) NSURL *url;

/**
 @abstract The refresh control of the `TSCWebViewController`.
 */
@property (nonatomic, strong) UIRefreshControl *refreshControl;

/**
 @abstract The back button of the `TSCWebViewController`.
 */
@property (nonatomic, strong) UIBarButtonItem *backButtonItem;

/**
 @abstract The forward button of the `TSCWebViewController`.
 */
@property (nonatomic, strong) UIBarButtonItem *forwardButtonItem;

/**
 @abstract The currently loading url of the `TSCWebViewController`.
 */
@property (nonatomic, strong) NSURL *pendingURL;

/**
 @abstract Whether the `TSCWebViewController` should automatically set the title.
 @discussion If the `TSCWebViewController` is embedded in a `UINavigationController` this will set the navigation bar's title to the title of the webpage.
 */
@property (nonatomic, assign) BOOL automaticallySetTitle;

/**
 Initializes a `TSCWebViewController` with a certain url.
 @param url The url which the `TSCWebViewController` will display.
 */
- (instancetype)initWithURL:(NSURL *)url;

@end
