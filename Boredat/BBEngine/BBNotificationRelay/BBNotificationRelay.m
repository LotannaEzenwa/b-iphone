//
//  BBNotificationRelay.m
//  Boredat
//
//  Created by Dmitry Letko on 5/13/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBNotificationRelay.h"
#import "BBNotificationRelaySubscriber.h"

#import "BBFacade.h"

#import "MgmtUtils.h"
#import "GCDUtils.h"


@interface BBNotificationRelay ()
{
@private
    dispatch_source_t _timerSource;
}

@property (strong, nonatomic, readonly) NSMutableSet *subscribers;
@property (strong, nonatomic, readwrite) NSOperation *operation;
@property (nonatomic, readwrite) NSUInteger countOfNotifications;

- (void)handleTimer;

@end


@implementation BBNotificationRelay


#pragma mark -
#pragma mark public

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        _facade = [BBFacade sharedInstance];
    }
    
    return self;
}


- (void)subscribe:(id<BBNotificationRelaySubscriber>)subscriber
{
    if (subscriber != nil)
    {
        if (_subscribers == nil)
        {
            _subscribers = (NSMutableSet *)CFBridgingRelease(CFSetCreateMutable(NULL, 1, NULL));
        }
        
        [_subscribers addObject:subscriber];
     
        if (_timerSource == NULL)
        {
            const uint64_t interval = 15 * NSEC_PER_SEC;
            const uint64_t leeway = 5 * NSEC_PER_SEC;
            
            _timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());            
            dispatch_source_set_timer(_timerSource, DISPATCH_TIME_NOW, interval, leeway);
            dispatch_source_set_event_handler(_timerSource, ^{
                BBNotificationRelay *relay = (__bridge BBNotificationRelay *)(dispatch_get_context(_timerSource));
                [relay handleTimer];
            });
            dispatch_set_context(_timerSource, (__bridge void *)(self));
            dispatch_resume(_timerSource);
        }
    }
}

- (void)unsubscribe:(id<BBNotificationRelaySubscriber>)subscriber
{
    if (subscriber != nil && _subscribers != nil)
    {
        [_subscribers removeObject:subscriber];
    }
}

- (void)updateCountOfNotifications
{
    // Only update if logged in
    if (_facade.user != nil)
    {
        __block __weak NSOperation *operation = [_facade countOfNotifications:^(NSUInteger count, NSError *error) {
            if (operation != nil && operation.isCancelled == NO)
            {
                if (error == nil)
                {
                    [self setCountOfNotifications:count];
                }
            }
        }];
        
        _operation = operation;
    }
}

- (void)updateCountOfNotificationsIfNeeded
{
    if (_operation == nil || _operation.isFinished)
    {
        [self updateCountOfNotifications];
    }
}


#pragma mark -
#pragma mark private

- (void)setCountOfNotifications:(NSUInteger)countOfNotifications
{
    _countOfNotifications = countOfNotifications;
    
    [_subscribers enumerateObjectsUsingBlock:^(id<BBNotificationRelaySubscriber> subscriber, BOOL *stop) {
        if ([subscriber respondsToSelector:@selector(notificationRelayDidUpdateCount:)] == YES)
        {
            [subscriber notificationRelayDidUpdateCount:self];
        }
    }];
}

- (void)handleTimer
{    
    [self updateCountOfNotificationsIfNeeded];
}

@end
