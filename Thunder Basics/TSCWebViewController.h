//
//  TSCWebViewController.h
//  ThunderStorm
//
//  Created by Phillip Caudell on 27/09/2013.
//  Copyright (c) 2013 3 SIDED CUBE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSCWebViewController : UIViewController <UIWebViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIBarButtonItem *backButtonItem;
@property (nonatomic, strong) UIBarButtonItem *forwardButtonItem;
@property (nonatomic, strong) NSURL *pendingURL;
@property (nonatomic, assign) BOOL automaticallySetTitle;

- (id)initWithURL:(NSURL *)url;

@end
