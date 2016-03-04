//
//  BBPersonalityMessage.m
//  Boredat
//
//  Created by Dmitry Letko on 3/20/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBPersonalityMessage.h"
#import "BBPersonalityResponse.h"

#import "MgmtUtils.h"


static NSString *const kQueryName = @"name";
static NSString *const kQueryUID = @"id";


@implementation BBPersonalityMessage


#pragma mark -
#pragma mark NSMutableCopying callbacks

- (id)mutableCopyWithZone:(NSZone *)zone
{
	BBPersonalityMessage *copy = [super mutableCopyWithZone:zone];
	copy.name = _name;
	copy.UID = _UID;
	
	return copy;
}


#pragma mark -
#pragma mark BBHTTPProtocol required methods

- (NSString *)pathComponent
{
    return @"/personality";
}

- (NSDictionary *)URLQueries
{
	NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
	[parameters setValue:_name forKey:kQueryName];
	[parameters setValue:_UID forKey:kQueryUID];
	
	return parameters;
}


#pragma mark -
#pragma mark BBMessageProtocol required methods

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBPersonalityResponse class];
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
		if ([message isKindOfClass:[BBPersonalityMessage class]] == YES)
		{
			return [self isEqualToPersonalityMessage:(BBPersonalityMessage *)message];
		}
	
	return NO;
}

- (NSUInteger)hash
{
	const NSUInteger superHash = super.hash;
	const NSUInteger nameHash = _name.hash;
	const NSUInteger UIDEqual = _UID.hash;
	const NSUInteger hash = (superHash ^ nameHash ^ UIDEqual);
    
	return hash;
}


#pragma mark -
#pragma mark public

- (BOOL)isEqualToPersonalityMessage:(BBPersonalityMessage *)message
{
    if ([super isEqualToMessage:message] == YES)
    {
        const BOOL isNameEqual = (_name == message.name || [_name isEqualToString:message.name]);
        const BOOL isUIDEqual = (_UID == message.UID || [_UID isEqualToString:message.UID]);
        const BOOL isEqual = (isNameEqual && isUIDEqual);
        
        return isEqual;
    }	
	
	return NO;
}

@end
