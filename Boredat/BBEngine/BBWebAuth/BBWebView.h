//
//  BBWebView.h
//  Boredat
//
//  Created by Dmitry Letko on 5/24/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBWebViewDelegate.h"


@protocol BBWebViewPluginProtocol;


@interface BBWebView : UIWebView <UIWebViewDelegate>
@property (weak, nonatomic, readwrite) id<BBWebViewDelegate> delegate;
@property (strong, nonatomic, readwrite) id<BBWebViewPluginProtocol> plugin;

- (void)loadPlugin;

- (void)retry;

@end
