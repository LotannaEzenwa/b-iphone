//
//  BBNotificationModel.m
//  Boredat
//
//  Created by Dmitry Letko on 6/4/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBNotificationAggregate.h"
#import "BBNotificationModel.h"
#import "BBNotificationStatistics.h"
#import "BBFacade.h"
#import "BBPost.h"
#import "MgmtUtils.h"

static NSInteger const kNotificationBatchSize = 50;


@interface BBNotificationModel ()
{
    NSMutableArray *_notifications;
}

- (void)aggregateNotifications:(NSArray *)notifications;

@end


@implementation BBNotificationModel

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        self.facade = [BBFacade sharedInstance];
        [self clearData];
    }
    
    return self;
}


#pragma mark -
#pragma mark public

- (NSInteger)numberOfObjects
{
    return [_notifications count];
}

- (id)objectAtIndex:(NSInteger)index
{
    return [_notifications objectAtIndex:index];
}

- (void)replaceObjectAtIndex:(NSInteger)index withObject:(id)object
{
    [_notifications replaceObjectAtIndex:index withObject:object];
}

- (void)updateDataForced:(BOOL)forced
{
    [self updateDataWithCompletion:nil forced:forced];
}

- (void)updateDataWithCompletion:(void (^)())block forced:(BOOL)forced
{
    if (self.fetching && !forced)
    {
        if (block != nil)
        {
            block();
        }
        return;
    }

    if (forced)
    {
        [self fetchNotificationsWithBlock:block];
    }
    else
    {
        [self.facade executeInBackground:^(void) {
            [self fetchNotificationsWithBlock:block];
        }];
    }
}

- (void)fetchNotificationsWithBlock:(void (^)())block
{
    self.fetching = YES;

    NSInteger count = kNotificationBatchSize;
    [self.facade notificationsWithLastID:nil frame:BBFrameMake(0, count) block:^(NSArray *objects, NSError *error) {
        if (error == nil)
        {
            [self.facade notificationsWithEntities:objects block:^(NSArray *notifications, NSError *error1) {
                self.fetching = NO;
                if (error1 == nil)
                {
                    [self aggregateNotifications:notifications];
                    if (block != nil)
                    {
                        block();
                    }
                    [self.delegate modelDidUpdateData:self];
                }
                else
                {
                    [self.delegate modelDidRecieveError:self error:error1];
                }
            }];
        }
        else
        {
            self.fetching = NO;
            [self.delegate modelDidRecieveError:self error:error];
        }
    }];
}

- (void)clearData
{
    _notifications = [NSMutableArray new];
    self.fetching = NO;
}

- (void)completeAction:(BBPostAction)action forObjectAtIndex:(NSInteger)index
{
    
    BBNotificationAggregate *notification = [self objectAtIndex:index];
    BBPost *post = notification.post;
    [post updateForAction:action];
    notification.post = post;
    
    // Replace post array with updated post
    [self replaceObjectAtIndex:index withObject:notification];
    
    
    // Take action
    [self.facade completePostAction:action onPost:post completion:^(NSError *error) {
        if (error != nil)
        {
            [self.delegate modelDidRecieveError:self error:error];
        }
    }];
}

#pragma mark -
#pragma mark private

- (void)aggregateNotifications:(NSArray *)notifications
{
    _notifications = [NSMutableArray new];
    NSMutableDictionary *notificationsWithPosts = [NSMutableDictionary new];
    for (int i = 0; i < [notifications count]; i ++)
    {
        BBNotification *notification = [notifications objectAtIndex:i];
        BBPost *post = notification.entity;
        
        if ([post isKindOfClass:[BBPost class]] == NO || post.UID == nil)
        {
            // Discount badge notifications (for now)
            if (notification.type != nil)
            {
                // Create new aggregate without a post
                BBNotificationAggregate *newAggregate = [BBNotificationAggregate new];
                newAggregate = [self addToAggregate:newAggregate withNotification:notification];
                [_notifications addObject:newAggregate];
            }
        }
        else
        {
            // Create or add to aggregate with post
            BBNotificationAggregate *aggregate = [notificationsWithPosts objectForKey:post.UID];
            if (aggregate == nil)
            {
                aggregate = [BBNotificationAggregate new];
                aggregate.post = post;
            }
            aggregate = [self addToAggregate:aggregate withNotification:notification];
            [notificationsWithPosts setObject:aggregate forKey:post.UID];
        }
        
    }
    // Add all notifications with posts
    for (BBNotificationAggregate *value in [notificationsWithPosts allValues])
    {
        [_notifications addObject:value];
    }
    
    // Order aggregates chronologically
    [_notifications sortUsingComparator:^NSComparisonResult(BBNotificationAggregate *obj1, BBNotificationAggregate *obj2){
        return [obj2.lastChanged compare:obj1.lastChanged];
    }];
}

- (BBNotificationAggregate *)addToAggregate:(BBNotificationAggregate *)aggregate withNotification:(BBNotification *)notification
{
    // If notification is unread, check to see whether aggregate is unread
    if (notification.read == NO)
    {
        // Create new aggregate, which will hold only unread notifications
        if (aggregate.read == YES) {
            aggregate = [aggregate clearStats];
            aggregate.read = NO;
        }
    }
    
    // Only add to aggregate if it's also read / unread
    if (notification.read == aggregate.read)
    {
        NSString *type = notification.type;
        if ([type isEqualToString:@"agree_received"])
        {
            aggregate.agrees += 1;
        }
        else if ([type isEqualToString:@"disagree_received"])
        {
            aggregate.disagrees += 1;
        }
        else if ([type isEqualToString:@"newsworthy_received"])
        {
            aggregate.newsworthies += 1;
        }
        else if ([type isEqualToString:@"reply_update"])
        {
            aggregate.replyUpdates += 1;
        }
        else if ([type isEqualToString:@"reply_received"])
        {
            aggregate.replies += 1;
        }
        else if ([type isEqualToString:@"url_click_received"])
        {
            aggregate.urlClicks += 1;
        }
        else if ([type isEqualToString:@"message_reply_received"])
        {
            aggregate.messages += 1;
        }
        else if ([type isEqualToString:@"profile_view"])
        {
            aggregate.profileViews += 1;
        }
        
        // Update time to most recent
        if (aggregate.lastChanged == nil || [notification.created compare:aggregate.lastChanged] == NSOrderedAscending)
        {
            aggregate.lastChanged = notification.created;
        }
    }
    
    return aggregate;
}

@end
