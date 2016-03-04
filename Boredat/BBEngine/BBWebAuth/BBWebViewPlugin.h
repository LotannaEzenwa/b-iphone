//
//  BBWebViewPlugin.h
//  Boredat
//
//  Created by Dmitry Letko on 5/24/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBWebViewPluginProtocol.h"


@protocol BBMessageProtocol;


@interface BBWebViewPlugin : NSObject <BBWebViewPluginProtocol>
@property (copy, nonatomic, readwrite) completion_block_t completion;

+ (id)plugin;
+ (id)pluginWithMessage:(id<BBMessageProtocol>)message;

- (id)initWithMessage:(id<BBMessageProtocol>)message;

@end
