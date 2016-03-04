//
//  BBOperation.m
//  Boredat
//
//  Created by Dmitry Letko on 5/16/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBOperation.h"
#import "BBMessageProtocol.h"
#import "BBRequestBuilder.h"
#import "BBRequest.h"
#import "BBResponseProtocol.h"
#import "BBResponseData.h"
#import "BBError.h"
#import "BBJSONSerialization.h"
#import "BBCompletionQueue.h"

#import "NSURLResponse+HTTPFields.h"
#import "NSObject+NULL.h"

#import "MgmtUtils.h"
#import "LogUtils.h"

#import "BBMessage.h"


@interface BBOperation ()
{
    BOOL _isExecuting;
    BOOL _isFinished;
    NSURLSessionDataTask *_task;
}

@property (strong, nonatomic, readwrite) id<BBMessageProtocol> message;

- (void)completeWithData:(NSData *)data error:(NSError *)error;
- (void)finish;

@end


@implementation BBOperation

+ (id)operationWithMessage:(id<BBMessageProtocol>)message
{	
	return [[self alloc] initWithMessage:message];
}

- (id)initWithMessage:(id<BBMessageProtocol>)message
{
	self = [super init];
	
	if (self != nil)
	{
		_message = [message mutableCopy];
        [self setQueuePriority:message.priority];
        
        return self;
	}
	return self;
}


#pragma mark -
#pragma mark NSOperation overload

- (BOOL) isConcurrent
{
    return YES;
}

- (void)start
{
    if (self.isCancelled == NO && _isFinished == NO && _isExecuting == NO)
    {
        self.isExecuting = YES;
        
        // Avoid a retain cycle
        __weak id weakSelf = self;

        // Build request, queue in the URL session
        BBRequest *request = [BBRequestBuilder requestWithMessage:_message];
        
        _task = [[NSURLSession sharedSession] dataTaskWithRequest:request.URLRequest
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          [weakSelf completeWithData:data error:error];
                                      }];
        [_task resume];
    }
    else
    {
        [self finish];
    }
}

#pragma mark -
#pragma mark public

- (void)setCompletion:(completion_block_t)completion
{
    _completion = [completion copy];
}


#pragma mark -
#pragma mark private

- (void)finish
{
    // Lets NSOperationQueue know to remove operation from the queue
    self.isExecuting = NO;
    self.isFinished = YES;
}

- (void)completeWithData:(NSData *)data error:(NSError *)error
{
    id JSONObject = [BBJSONSerialization JSONObjectWithData:data error:nil];
    id<BBResponseProtocol> URLResponse = nil;
    
    if (JSONObject != nil)
    {
        BBResponseData *responseData = [BBResponseData new];
        responseData.JSONObject = JSONObject;
        
        Class<BBResponseProtocol> BBResponseClass = _message.BBResponseClass;
        URLResponse = [BBResponseClass responseWithData:responseData];
        
        BBError *errorFromServer = [BBError errorWithJSONObject:JSONObject];
        if (errorFromServer != nil)
        {
            error = errorFromServer.NSErrorRepresentation;
        }
    }
        
    // Call completion with data
    [[BBCompletionQueue mainCompletionQueue] callBlock:_completion response:URLResponse error:error];
    
    [self finish];
}

# pragma mark Subclass getters and setters

// Necessary to maintain KVO for NSOperation
// These properties let the NSOperationQueue know when to remove operations from the queue

- (BOOL) isExecuting
{
    return _isExecuting;
}
- (void) setIsExecuting:(BOOL)isExecuting
{
    if (_isExecuting != isExecuting)
    {
        [self willChangeValueForKey:@"isExecuting"];
        _isExecuting = isExecuting;
        [self didChangeValueForKey:@"isExecuting"];
    }
}

- (BOOL) isFinished
{
    return _isFinished;
}
- (void) setIsFinished:(BOOL)isFinished
{
    if (_isFinished != isFinished)
    {
        [self willChangeValueForKey:@"isFinished"];
        _isFinished = isFinished;
        [self didChangeValueForKey:@"isFinished"];
    }
}

@end
