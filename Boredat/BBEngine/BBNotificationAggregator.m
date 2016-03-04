//
//  BBNotificationAggregator.m
//  BoredAt
//
//  Created by David Pickart on 7/17/15.
//
//

#import "BBNotification.h"
#import "BBNotificationAggregate.h"
#import "BBNotificationAggregator.h"
#import "BBNotificationRetriever.h"
#import "BBPost.h"

@implementation BBNotificationAggregator

+ (NSArray *)notificationAggregatesFromRetriever:(BBNotificationRetriever *)retriever
{
    NSMutableArray *notifications = [NSMutableArray new];
    NSMutableDictionary *notificationsWithPosts = [NSMutableDictionary new];
    for (int i = 0; i < [retriever numberOfObjects]; i ++)
    {
        BBNotification *notification = [retriever objectAtIndex:i];
        BBPost *post = notification.entity;
        
        if ([post isKindOfClass:[BBPost class]] == NO || post.UID == nil)
        {
            // Create new aggregate without a post
            BBNotificationAggregate *newAggregate = [BBNotificationAggregate new];
            newAggregate = [self addToAggregate:newAggregate withNotification:notification];
            [notifications addObject:newAggregate];
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
        [notifications addObject:value];
    }
    
    // Order aggregates chronologically
    [notifications sortUsingComparator:^NSComparisonResult(BBNotificationAggregate *obj1, BBNotificationAggregate *obj2){
        return [obj2.lastChanged compare:obj1.lastChanged];
    }];

    
    return [NSArray arrayWithArray:notifications];
}

// Private
+ (BBNotificationAggregate *)addToAggregate:(BBNotificationAggregate *)aggregate withNotification:(BBNotification *)notification
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
