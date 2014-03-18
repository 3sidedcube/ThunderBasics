//
//  TSCWebViewController.m
//  ThunderStorm
//
//  Created by Phillip Caudell on 27/09/2013.
//  Copyright (c) 2013 3 SIDED CUBE. All rights reserved.
//

#import "TSCWebViewController.h"

@interface TSCWebViewController ()

@end

@implementation TSCWebViewController

- (id)initWithURL:(NSURL *)url
{
    if (self = [super init]) {
        
        self.automaticallySetTitle = YES;
        
        if([url.absoluteString hasPrefix:@"www"]){
            self.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", url]];
        } else {
            self.url = url;
        }
        
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent": @"Mozilla/5.0 (iPhone; CPU iPhone OS 6_1_3 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10B329 Safari/8536.25"}];
    }
    
    return self;
}

- (void)loadView
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.delegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.view = self.webView;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
    
    [self.webView.scrollView addSubview:self.refreshControl];
    
    UIImage *navigationBackImage = [UIImage imageNamed:@"TSCBackButton"];
    UIImage *navigationForwardImage = [UIImage imageWithCGImage:navigationBackImage.CGImage scale:2.0 orientation: UIImageOrientationRight];
    
    self.backButtonItem = [[UIBarButtonItem alloc] initWithImage:navigationBackImage style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    self.backButtonItem.enabled = NO;
    self.forwardButtonItem = [[UIBarButtonItem alloc] initWithImage:navigationForwardImage style:UIBarButtonItemStylePlain target:self action:@selector(handleForward:)];
    self.forwardButtonItem.enabled = NO;
    
    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(handleShare:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.toolbarItems = @[self.backButtonItem, flexibleSpace, shareButtonItem, flexibleSpace, self.forwardButtonItem];
    } else {
        self.navigationItem.rightBarButtonItems = @[self.forwardButtonItem, shareButtonItem, self.backButtonItem];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleDone:)];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:NO animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

#pragma mark Refresh

- (void)handleRefresh:(id)sender
{
    [self.webView reload];
}

#pragma Actions

- (void)handleDone:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleShare:(id)sender
{
    UIActivityViewController *viewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.url] applicationActivities:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)handleBack:(id)sender
{
    [self.webView goBack];
}

- (void)handleForward:(id)sender
{
    [self.webView goForward];
}

#pragma mark Webview delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.refreshControl beginRefreshing];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.refreshControl endRefreshing];
    
    if (self.automaticallySetTitle) {
        self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    self.backButtonItem.enabled = self.webView.canGoBack;
    self.forwardButtonItem.enabled = self.webView.canGoForward;

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *address = request.URL.absoluteString;
    NSArray *blackList = @[@"donate"];
    
    BOOL isBlackListedAddress = NO;
    
    for (NSString *word in blackList){
        
        NSRange wordRange = [address rangeOfString:word];
        
        if (wordRange.location != NSNotFound){
            isBlackListedAddress = YES;
            break;
        }
    }
    
    if (isBlackListedAddress) {
        self.pendingURL = request.URL;
        [self presentLeavingWarning];
        return NO;
    }
    
    return YES;
}

- (void)presentLeavingWarning
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Continue" message:@"You now are leaving." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Open in Safari", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [[UIApplication sharedApplication] openURL:self.pendingURL];
    }
}

#pragma mark Scroll view delegate

/*
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView
 {
 NSLog(@"Gimme scroll");
 
 CGPoint offset = scrollView.contentOffset;
 UINavigationBar *navigationBar = self.navigationController.navigationBar;
 UIToolbar *toolbar = self.navigationController.toolbar;
 
 CGPoint barOffset = CGPointMake(0, - offset.y - navigationBar.frame.size.height - 20);
 
 if (barOffset.y >= 0) {
 barOffset.y = 0;
 }
 
 navigationBar.transform = CGAffineTransformMakeTranslation(barOffset.x, barOffset.y);
 toolbar.transform = CGAffineTransformMakeTranslation(-barOffset.x, -barOffset.y);
 
 }*/


@end
