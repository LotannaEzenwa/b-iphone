//
//  BBCompletionQueueProtocol.h
//  Boredat
//
//  Created by Dmitry Letko on 5/29/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBCompletionTypes.h"


@protocol BBCompletionQueueProtocol <NSObject>
@required

- (void)callBlock:(completion_block_t)block response:(id<BBResponseProtocol>)response error:(NSError *)error;

@end
