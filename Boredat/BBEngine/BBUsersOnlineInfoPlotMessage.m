//
//  BBUsersOnlineInfoPlotMessage.m
//  Boredat
//
//  Created by Anton Kolosov on 1/16/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBUsersOnlineInfoPlotMessage.h"
#import "BBUsersOnlineInfoPlotResponse.h"


static NSString *const kUIDQuery = @"hours";
static NSString *const kFieldsQuery = @"fields";

@implementation BBUsersOnlineInfoPlotMessage

#pragma mark -
#pragma mark BBHTTPProtocol required methods

- (NSString *)pathComponent
{
//    NSString *path = [NSString stringWithFormat:@"/statistics/users/online?hours=5", _periodOfTime];
    return @"/statistics/users/online";
//    return @"/statistics/actions?hours=5";
}

#pragma mark -
#pragma mark BBMessageProtocol required methods

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBUsersOnlineInfoPlotResponse class];
}

#pragma mark -
#pragma mark NSMutableCopy callbacks

- (id)mutableCopyWithZone:(NSZone *)zone
{
	BBUsersOnlineInfoPlotMessage *copy = [super mutableCopyWithZone:zone];
	copy.periodOfTime = _periodOfTime;
	
	return copy;
}

#pragma mark -
#pragma mark BBHTTPProtocol required methods

- (NSDictionary *)URLQueries
{
    NSString *fields = [_fields.allObjects componentsJoinedByString:@","];
    
	NSMutableDictionary *queries = [NSMutableDictionary dictionaryWithCapacity:2];
	[queries setValue:[NSNumber numberWithInteger:_periodOfTime] forKey:kUIDQuery];
	[queries setValue:fields forKey:kFieldsQuery];
	
	return queries;
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
		if ([message isKindOfClass:[BBUsersOnlineInfoPlotMessage class]] == YES)
		{
			return [self isEqualToRepliesMessage:(BBUsersOnlineInfoPlotMessage *)message];
		}
	
	return NO;
}

- (NSUInteger)hash
{
	const NSUInteger superHash = super.hash;
//	const NSUInteger pageHash = _periodOfTime.hash;
	const NSUInteger fieldsHash = _fields.hash;
	const NSUInteger hash = (superHash ^ fieldsHash);
	
	return hash;
}


#pragma mark -
#pragma mark public

- (BOOL)isEqualToRepliesMessage:(BBUsersOnlineInfoPlotMessage *)message
{
	if ([super isEqualToMessage:message] == YES)
    {
        const BOOL isPageEqual = (_periodOfTime == message.periodOfTime);
        const BOOL isFieldsEqual = (_fields == message.fields || [_fields isEqualToSet:message.fields]);
        const BOOL isEqual = (isPageEqual && isFieldsEqual);
        
        return isEqual;
    }
    
    return NO;
}


@end
