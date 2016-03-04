//
//  BBVoteMessage.m
//  Boredat
//
//  Created by Dmitry Letko on 5/23/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBVoteMessage.h"
#import "BBStatusResponse.h"

#import "MgmtUtils.h"


static NSString *const kVoteUID = @"id";


@implementation BBVoteMessage


#pragma mark -
#pragma mark NSMutableCopying callbacks

- (id)mutableCopyWithZone:(NSZone *)zone
{
	BBVoteMessage *copy = [super mutableCopyWithZone:zone];
	copy.UID = _UID;
	
	return copy;
}


#pragma mark -
#pragma mark BBMessageProtocol required methods

- (NSString *)HTTPMethod
{
	return cHTTPMethodPOST;
}

- (NSDictionary *)HTTPBodyParameters
{	
	NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:1];
	[parameters setValue:_UID forKey:kVoteUID];
	
	return parameters;
}

- (Class<BBResponseProtocol>)BBResponseClass
{
    return [BBStatusResponse class];
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
		if ([message isKindOfClass:[BBVoteMessage class]] == YES)
		{
			return [self isEqualToVoteMessage:(BBVoteMessage *)message];
		}
	
	return NO;
}

- (NSUInteger)hash
{
	const NSUInteger superHash = super.hash;
	const NSUInteger UIDHash = _UID.hash;
	const NSUInteger hash = (superHash ^ UIDHash);
	
	return hash;
}


#pragma mark -
#pragma mark piblic

- (BOOL)isEqualToVoteMessage:(BBVoteMessage *)message
{	    
    if ([super isEqualToMessage:message] == YES)
    {
        return (_UID == message.UID || [_UID isEqualToString:message.UID]);
    }
    
    return NO;
}

@end
