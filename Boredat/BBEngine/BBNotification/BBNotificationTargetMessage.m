//
//  BBNotificationTargetMessage.m
//  Boredat
//
//  Created by Dmitry Letko on 5/15/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBNotificationTargetMessage.h"
#import "BBNotificationTargetResponse.h"

#import "MgmtUtils.h"


@implementation BBNotificationTargetMessage


#pragma mark -
#pragma mark NSMutableCopying callbacks

- (id)mutableCopyWithZone:(NSZone *)zone
{
	BBNotificationTargetMessage *copy = [super mutableCopyWithZone:zone];
    copy.notifications = _notifications;
	
	return copy;
}


#pragma mark -
#pragma mark BBMessage overload

- (NSString *)pathComponent
{
    return @"/notifications/fetch_target";
}


#pragma mark -
#pragma mark BBHTTPProtocol required methods

- (NSDictionary *)URLQueries
{
    NSString *notifications = [_notifications componentsJoinedByString:@","];
    
    NSMutableDictionary *queries = [NSMutableDictionary dictionaryWithCapacity:1];
    [queries setValue:notifications forKey:@"notifications"];
    
    return queries;
}


#pragma mark BBMessageProtocol required methods
#pragma mark -

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBNotificationTargetResponse class];
}


#pragma mark -
#pragma mark equality

- (BOOL)isEqualToMessage:(id<BBMessageProtocol>)message
{
	if (self == message)
	{
		return YES;
	}
	else
		if ([message isKindOfClass:[BBNotificationTargetMessage class]] == YES)
		{
			return [self isEqualToNotificationTargetMessage:(BBNotificationTargetMessage *)message];
		}
	
	return NO;
}

- (NSUInteger)hash
{
	const NSUInteger superHash = super.hash;
    const NSUInteger notificationsHash = _notifications.hash;
	
	return (superHash ^ notificationsHash);
}


#pragma mark -
#pragma mark public

- (BOOL)isEqualToNotificationTargetMessage:(BBNotificationTargetMessage *)message
{
    if ([super isEqualToMessage:message] == YES)
    {
        return (_notifications == message.notifications || [_notifications isEqualToArray:message.notifications]);
    }
    
    return NO;
}


@end
