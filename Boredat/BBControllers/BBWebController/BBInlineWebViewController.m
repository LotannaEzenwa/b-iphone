//
//  BBInlineWebViewController.m
//  Boredat
//
//  Created by Anton Kolosov on 9/23/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBInlineWebViewController.h"
#import "BBApplicationSettings.h"
#import <MessageUI/MessageUI.h>

@interface BBInlineWebViewController () <UIWebViewDelegate>

@property (strong, nonatomic, readwrite) UIWebView *webView;
@property (strong, nonatomic, readwrite) UIBarButtonItem *goForwardButtonItem;
@property (strong, nonatomic, readwrite) UIBarButtonItem *goBackButtonItem;
@property (strong, nonatomic, readwrite) UIBarButtonItem *refreshButtonItem;

@end

@implementation BBInlineWebViewController


#pragma mark -
#pragma mark Initialization

- (id)initWithUrl:(NSURL *)url
{
    self = [super init];
    if (self != nil)
    {
        self.linkUrl = url;
    }
    
    return self;
}


#pragma mark -
#pragma mark View lifecycle

- (void)loadView
{
    _webView = [UIWebView new];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    
    self.view = _webView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.navigationController setToolbarHidden:NO];
//    [self assembleNavigationBar];
    [self assembleToolBar];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:_linkUrl]];
    
    [self checkLoadingPagesList];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.toolbarItems = nil;
    [self.navigationController setToolbarHidden:YES];
    [_webView stopLoading];
}

#pragma mark -
#pragma mark Navigation bar and toolbar creation

- (void)assembleNavigationBar
{
    NSString *title = [NSString stringWithFormat:@"%@", _linkUrl];
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setTitle: title forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:[BBApplicationSettings fontForKey:kFontTitle]];
    [titleButton sizeToFit];
    
    [self.navigationItem setTitleView:titleButton];
}

- (void)assembleToolBar
{
    _goForwardButtonItem = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:102 // forward arrow enum
                                       target:self action:@selector(goToNextPage)];
  
    _goBackButtonItem = [[UIBarButtonItem alloc]
                            initWithBarButtonSystemItem:101 // backward arrow enum
                            target:self action:@selector(goToPreviousPage)];
    
    _refreshButtonItem = [[UIBarButtonItem alloc]
                         initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                         target:self action:@selector(goToPreviousPage)];

    UIBarButtonItem *flexibleButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *toolbarButtons = [[NSArray alloc] initWithObjects:flexibleButtonItem, _goBackButtonItem,
                                                               flexibleButtonItem, _goForwardButtonItem,
                                                               flexibleButtonItem, _refreshButtonItem,
                                                               flexibleButtonItem, nil];
    
    
    self.toolbarItems = toolbarButtons;
    self.navigationController.toolbar.barTintColor = self.navigationController.navigationBar.barTintColor;
    self.navigationController.toolbar.tintColor = [UIColor whiteColor];
}

#pragma mark -
#pragma mark Toolbar buttons methods

- (void)refreshPage
{
    [_webView reload];
}

- (void)goToPreviousPage
{
    [_webView goBack];
    [self checkLoadingPagesList];
}

- (void)goToNextPage
{
    [_webView goForward];
    [self checkLoadingPagesList];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self checkLoadingPagesList];
    return YES;
}

#pragma mark -
#pragma mark 

- (void)checkLoadingPagesList
{
    _goBackButtonItem.enabled = _webView.canGoBack;
    _goForwardButtonItem.enabled = _webView.canGoForward;
}

@end
