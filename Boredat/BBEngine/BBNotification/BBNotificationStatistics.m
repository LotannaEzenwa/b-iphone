//
//  BBNotificationStatistics.m
//  Boredat
//
//  Created by Dmitry Letko on 5/8/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBNotificationStatistics.h"

#import "MgmtUtils.h"

#import "NSObject+NULL.h"
#import "NSFoundation+Extensions.h"


NSString *const kNotificationsTotalCount = @"total_notifications";
NSString *const kNotificationsLastID = @"notification_last_id";


static inline void parseStringWithStatistics(NSString *string, NSUInteger *count, NSUInteger *points);


@implementation BBNotificationStatistics

@synthesize replyUpdates = _replyUpdates;
@synthesize replyUpdatesPoints = _replyUpdatesPoints;

- (BOOL)isEqual:(id)object
{
    if (self == object)
    {
        return YES;
    }
    else
        if ([object isKindOfClass:[BBNotificationStatistics class]] == YES)
        {
            return [self isEqualToNotificationStatistics:(BBNotificationStatistics *)object];
        }
    
    return NO;
}

- (NSUInteger)hash
{
    return [_json hash];
}


#pragma mark -
#pragma mark public

- (BOOL)isEqualToNotificationStatistics:(BBNotificationStatistics *)statistics
{
    return (_json == statistics.json || [_json isEqualToDictionary:statistics.json]);
}

@end


@implementation BBNotificationStatistics (JSONObject)

static NSString *const kUrlClicks = @"url_click_received";
static NSString *const kAgrees = @"agree_received";
static NSString *const kDisagrees = @"disagree_received";
static NSString *const kNewsworthies = @"newsworthy_received";
static NSString *const kReplies = @"reply_received";
static NSString *const kReputations = @"reputation_received";
static NSString *const kPosts = @"post_recovery";
static NSString *const kProfile = @"profile_view";
static NSString *const kMessage = @"message_reply_received";

static NSString * const kReplyUpdate = @"reply_update";

- (id)initWithJSONObject:(id)JSONObject
{
    self = [super init];
    
    if (self != nil)
    {
        NSDictionary *JSONDictionary = NSDictionaryObject(JSONObject);
        
        if (JSONDictionary.count > 0)
        {
            parseStringWithStatistics([JSONDictionary objectForKey:kUrlClicks], &_urlClicks, &_urlClickPoints);
            parseStringWithStatistics([JSONDictionary objectForKey:kAgrees], &_agrees, &_agreesPoints);
            parseStringWithStatistics([JSONDictionary objectForKey:kDisagrees], &_disagrees, &_disagreesPoints);
            parseStringWithStatistics([JSONDictionary objectForKey:kNewsworthies], &_newsworthies, &_newsworthiesPoints);
            parseStringWithStatistics([JSONDictionary objectForKey:kReplies], &_replies, &_repliesPoints);
            parseStringWithStatistics([JSONDictionary objectForKey:kReputations], &_reputations, &_reputationsPoints);
            parseStringWithStatistics([JSONDictionary objectForKey:kPosts], &_posts, &_postsPoints);
            parseStringWithStatistics([JSONDictionary objectForKey:kProfile], &_profile, &_profilePoints);
            parseStringWithStatistics([JSONDictionary objectForKey:kMessage], &_messages, &_messagesPoints);
            
            parseStringWithStatistics([JSONDictionary objectForKey:kReplyUpdate], &_replyUpdates, &_replyUpdatesPoints);
            
            //
            _countOfNotifications = (_urlClicks + _agrees + _disagrees + _newsworthies + _replies + _reputations + _posts + _profile + _messages + _replyUpdates);
            _totalCountOfNotifications = [[JSONDictionary objectForKey:kNotificationsTotalCount] integerValue];
            _lastID = [[JSONDictionary objectForKey:kNotificationsLastID] copy];
            _json = [JSONDictionary copy];
        }
    }
    
    return self;
}

@end


static inline void parseStringWithStatistics(NSString *string, NSUInteger *count, NSUInteger *points)
{
    NSArray *components = [string componentsSeparatedByString:@","];
    
    if (components.count == 2)
    {
        (*count) = [[components objectAtIndex:0] integerValue];
        (*points) = [[components objectAtIndex:1] integerValue];
    }
}