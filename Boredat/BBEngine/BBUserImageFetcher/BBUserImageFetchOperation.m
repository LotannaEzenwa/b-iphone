//
//  BBUserImageFetchOperation.m
//  Boredat
//
//  Created by Dmitry Letko on 3/19/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBUserImageFetchOperation.h"
#import "BBUserImage.h"

#import "MgmtUtils.h"


@interface BBUserImageFetchOperation ()
{
    BOOL _isExecuting;
    BOOL _isFinished;
    NSURLSessionDataTask *_task;
}

- (void)completeWithData:(NSData *)data;
- (void)finish;

@end


@implementation BBUserImageFetchOperation


#pragma mark -
#pragma mark NSOperation overload

- (BOOL)isConcurrent
{
    return YES;
}

- (void)start
{
    if (self.isCancelled == NO && _isExecuting == NO && _isFinished == NO)
    {
        self.isExecuting = YES;
        
        // Build request, queue in the URL session
        NSURL *sourceURL = [[NSURL alloc] initWithString:[_pathToImage stringByExpandingTildeInPath]];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:sourceURL];
        
        // Avoid a retain cycle
        __weak id weakSelf = self;
    
        _task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                completionHandler:
                 ^(NSData *data, NSURLResponse *response, NSError *error) {
                     [weakSelf completeWithData:data];
                 }];
        [_task resume];
    }
    else
    {
        [self finish];
    }
}

#pragma mark -
#pragma mark private

- (void)finish
{
    // Lets NSOperationQueue know to remove operation from the queue
    self.isExecuting = NO;
    self.isFinished = YES;
}

- (void)completeWithData:(NSData *)data
{
    // Save image
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directory = [_localPathOfImage stringByDeletingLastPathComponent];
    
    if ([fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil])
    {
        _success = [data writeToFile:_localPathOfImage atomically:YES];
    }
    
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
