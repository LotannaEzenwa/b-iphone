//
//  BBNotification.m
//  Boredat
//
//  Created by Dmitry Letko on 1/31/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBNotification.h"
#import "BBPersonality.h"
#import "BBPost.h"
#import "BBPrivatePost.h"

#import "MgmtUtils.h"

#import "NSObject+NULL.h"
#import "NSFoundation+Extensions.h"
#import "UIKit+Extensions.h"

NSString *const kNotificationUID = @"notificationId";
NSString *const kNotificationCreated = @"notificationCreated";
NSString *const kNotificationRead = @"notificationRead";
NSString *const kNotificationType = @"notificationType";
NSString *const kNotificationTarget = @"notificationTarget";
NSString *const kNotificationMoreInfo = @"notificationMoreInfo";
NSString *const kNotificationPoints = @"notificationPoints";
NSString *const kNotificationTargetType = @"notificationTargetType";
NSString *const kNotificationLastID = @"notification_last_id";

NSString *const kTarget = @"target";

NSString *const kNotificationTypeMessage = @"message";
NSString *const kNotificationTypePost = @"post";
NSString *const kNotificationTypeProfiles = @"profiles";

@interface BBNotification ()
{
@private
    NSDictionary *_cacheOfMessages;
    NSDictionary *_cacheOfColors;
}

@end


@implementation BBNotification


#pragma mark -
#pragma mark private methods

- (void)setPoints:(NSInteger)points
{
    if (_points != points)
    {
        _points = points;
        if ([_type isEqualToString:@"profile_view"])
        {
            if (_points == 5)
            {
                _message = [[_cacheOfMessages objectForKey:@"profile_view"] copy];
            }
            else
            {
                NSString *formatString = NSLocalizedString(@"%d people viewed your profile.", nil);
                _message = [[NSString stringWithFormat:formatString,_points / 5] copy];
            }
        }
    }
}


@end


@implementation BBNotification (JSONObject)

+ (NSDictionary *)entityClasses
{
    static NSDictionary *entityClasses = nil;
    static dispatch_once_t initialized;
    
    dispatch_once(&initialized, ^{
        entityClasses = [[NSDictionary alloc] initWithObjectsAndKeys:
                         [BBPrivatePost class], kNotificationTypeMessage,
                         [BBPost class], kNotificationTypePost,
                         [BBPersonality class], kNotificationTypeProfiles, nil];
    });
    
    return entityClasses;
}

- (id)initWithJSONObject:(id)JSONObject
{
    self = [super init];
    
    if (self != nil)
    {
        NSDictionary *JSONDictionary = NSDictionaryObject(JSONObject);
        
        if (JSONDictionary.count > 0)
        {
            NSString *created = [JSONDictionary objectForKey:kNotificationCreated];
            NSString *targetType = [JSONDictionary objectForKey:kNotificationTargetType];
            
            _UID = [[JSONDictionary objectForKey:kNotificationUID] copy];
            _created = [[NSDate dateWithString:created] copy];
            _type = [[JSONDictionary objectForKey:kNotificationType] copy];
            _target = [[JSONDictionary objectForKey:kNotificationTarget] copy];
            _targetType = [targetType copy];
            _lastID = [[JSONDictionary objectForKey:kNotificationLastID] copy];
            _moreInfo = [[JSONDictionary objectForKey:kNotificationMoreInfo] copy];
            _read = [[JSONDictionary objectForKey:kNotificationRead] boolValue];
            _points = [[JSONDictionary objectForKey:kNotificationPoints] integerValue];
            _message = [[self messageOfType:_type] copy];
            _color = [self colorOfType:_type];
            
            if (targetType != nil)
            {
                Class entityClass = [[BBNotification entityClasses] objectForKey:targetType];
                
                if (entityClass != nil)
                {
                    NSDictionary *targetDictionary = [JSONDictionary objectForKey:kTarget];
                                        
                    _entity = [[entityClass alloc] initWithJSONObject:targetDictionary];
                }
            }
        }
    }
    
    return self;
}


#pragma mark -
#pragma mark private methods

- (NSString *)messageOfType:(NSString *)type
{
    if (_cacheOfMessages == nil)
    {
        _cacheOfMessages = [[NSDictionary alloc] initWithObjectsAndKeys:
                            NSLocalizedString(@"Someone replied to your post.", nil), @"reply_received",
                            NSLocalizedString(@"Someone voted agree on your post.", nil), @"agree_received",
                            NSLocalizedString(@"Someone voted disagree on your post.", nil), @"disagree_received",
                            NSLocalizedString(@"Someone voted newsworthy on your post.", nil), @"newsworthy_received",
                            NSLocalizedString(@"Someone viewed your profile.", nil), @"profile_view",
                            NSLocalizedString(@"You received a new message.", nil), @"message_reply_received",
                            NSLocalizedString(@"A post you replied to has a new addition to the thread.", nil), @"reply_update",
                            NSLocalizedString(@"Someone clicked on your post.", nil), @"url_click_received",
                            NSLocalizedString(@"A post you are following has been updated.", nil), @"follow_update", nil];
    }
    
    NSString *message = [_cacheOfMessages objectForKey:type];
    
    return message;
}

- (UIColor *)colorOfType:(NSString *)type
{
    
    if (_cacheOfColors == nil)
    {
        _cacheOfColors = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [UIColor goldColor], @"reply_update",
                          [UIColor goldColor], @"reply_received",
                          [UIColor agreeColor], @"agree_received",
                          [UIColor disagreeColor], @"disagree_received",
                          [UIColor colorWithRGB:0x0033CC], @"newsworthy_received", nil];
    }
    
    return [_cacheOfColors objectForKey:type];
}
@end
