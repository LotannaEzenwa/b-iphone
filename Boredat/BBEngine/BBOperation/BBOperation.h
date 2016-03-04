//
//  BBOperation.h
//  Boredat
//
//  Created by Dmitry Letko on 5/16/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBCompletionTypes.h"


@protocol BBMessageProtocol;

/**
 Class to perform sending of Server messages and retrieving the corresponded responses.
 
 @see	NSOperation
 */
@interface BBOperation : NSOperation

/**
 The block to execute when main task is complete.
 By default block executes on the main queue.
 
 @see	BBCompletionTypes
 */
@property (copy, nonatomic, readwrite) completion_block_t completion;
/**
 Creates and returns an initialized operation for message.
 
 @param		message		The object that conforms to BBMessageProtocol.
 @return				An operation object.
 */
+ (id)operationWithMessage:(id<BBMessageProtocol>)message;

/**
 Returns an initialized operation for message.
 
 @param		message		The object that conforms to BBMessageProtocol.
 @return				An initialized operation object.
 */
- (id)initWithMessage:(id<BBMessageProtocol>)message;

@end
