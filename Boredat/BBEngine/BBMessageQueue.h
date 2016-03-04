//
//  BBMessageQueue.h
//  Boredat
//
//  Created by Dmitry Letko on 5/21/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBCompletionTypes.h"


@protocol BBMessageProtocol;



/**
 Creates operation for a given message and provides operation queue to process it.
 */

@interface BBMessageQueue : NSObject

/**
 Sends given message.
 
 @param		message		The message object which conforms to BBMessageProtocol.
 
 @see		BBOperation
 */
- (NSOperation *)sendMessage:(id<BBMessageProtocol>)message;

/**
 Sends given message and calls completion block after the operation is completed.
 
 @param		message		The message object which conforms to BBMessageProtocol.
 @param		completion	Completion block called after the operation is completed.
						
 @see		BBOperation
 */
- (NSOperation *)sendMessage:(id<BBMessageProtocol>)message completion:(completion_block_t)completion;

- (void)invalidateAllMessages;
- (NSInteger)numPendingMessages;

@end
