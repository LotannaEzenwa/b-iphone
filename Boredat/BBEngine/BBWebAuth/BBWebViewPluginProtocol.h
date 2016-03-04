//
//  BBWebViewPluginProtocol.h
//  Boredat
//
//  Created by Dmitry Letko on 5/26/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBCompletionTypes.h"


@protocol BBWebViewPluginProtocol <UIWebViewDelegate>
@required

@property (copy, nonatomic, readonly) NSURLRequest *URLRequest;
@property (copy, nonatomic, readonly) NSString *callback;
@property (copy, nonatomic, readwrite) result_block_t result;

@end
