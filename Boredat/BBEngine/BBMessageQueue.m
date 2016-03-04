//
//  BBMessageQueue.m
//  Boredat
//
//  Created by Dmitry Letko on 5/21/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBMessageQueue.h"
#import "BBMessageProtocol.h"
#import "BBOperation.h"

#import "MgmtUtils.h"


@interface BBMessageQueue ()
@property (strong, nonatomic, readwrite) NSOperationQueue *operationQueue;

@end


@implementation BBMessageQueue

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        _operationQueue = [NSOperationQueue new];
		_operationQueue.name = @"app.BBMessageQueue.operationQueue";
        [_operationQueue setMaxConcurrentOperationCount:5];
    }
    
    return self;
}


#pragma mark -
#pragma mark public

- (NSOperation *)sendMessage:(id<BBMessageProtocol>)message
{
	return [self sendMessage:message completion:nil];
}

- (NSOperation *)sendMessage:(id<BBMessageProtocol>)message completion:(completion_block_t)completion
{
	BBOperation *operation = [BBOperation operationWithMessage:message];
	operation.completion = completion;
	
	[_operationQueue addOperation:operation];
    
    return operation;
}

- (void)invalidateAllMessages
{    
    [_operationQueue cancelAllOperations];
}

- (NSInteger)numPendingMessages
{
    return [_operationQueue operationCount];
}

@end
