//
//  BBCompletionQueue.m
//  Boredat
//
//  Created by Dmitry Letko on 5/26/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBCompletionQueue.h"


@interface BBCompletionQueue ()
{
@private
	dispatch_queue_t queue;
}

- (id)initMainCompletionQueue;

- (dispatch_queue_t)queue;

@end


@implementation BBCompletionQueue


static id mainCompletionQueue = nil;

+ (void)initialize
{
	static dispatch_once_t initialized;
	
	dispatch_once(&initialized, ^{
		mainCompletionQueue = [[self alloc] initMainCompletionQueue];
	});
}

+ (id)mainCompletionQueue
{
	return mainCompletionQueue;
}


- (id)initMainCompletionQueue
{
	self = [super init];
	
	if (self != nil)
	{
		queue = dispatch_queue_create("app.BBCompletionQueue.queue", DISPATCH_QUEUE_CONCURRENT);
		dispatch_set_target_queue(queue, dispatch_get_main_queue());
	}
	
	return self;
}



#pragma mark -
#pragma mark BBCompletionQueueProtocol required methods

- (void)callBlock:(completion_block_t)block response:(id<BBResponseProtocol>)response error:(NSError *)error
{
	if (block != nil)
	{
		dispatch_async(self.queue, ^{			
			block(response, error);
		});	
	}
}


#pragma mark -
#pragma mark private

- (dispatch_queue_t)queue
{
	return queue;
}

@end
