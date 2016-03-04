//
//  BBWebViewDelegate.h
//  Boredat
//
//  Created by Dmitry Letko on 5/25/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@class BBWebView;


@protocol BBWebViewDelegate <UIWebViewDelegate>
@optional

- (void)webViewDidFindCallback:(BBWebView *)webView;

@end
