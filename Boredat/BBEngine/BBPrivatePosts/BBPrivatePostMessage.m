//
//  BBPrivatePostMessage.m
//  Boredat
//
//  Created by Dmitry Letko on 5/8/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBPrivatePostMessage.h"
#import "BBPrivatePostResponse.h"

#import "MgmtUtils.h"


static NSString *const kUIDQuery = @"id";
static NSString *const kFieldsQuery = @"fields";


@implementation BBPrivatePostMessage

#pragma mark -
#pragma mark NSMutableCopy callbacks

- (id)mutableCopyWithZone:(NSZone *)zone
{
	BBPrivatePostMessage *copy = [super mutableCopyWithZone:zone];
	copy.UID = _UID;
	copy.fields = _fields;
	
	return copy;
}


#pragma mark -
#pragma mark BBMEssage overload

- (NSString *)pathComponent
{
    return @"/message";
}


#pragma mark -
#pragma mark BBHTTPProtocol required methods

- (NSDictionary *)URLQueries
{
	NSMutableDictionary *queries = [NSMutableDictionary dictionaryWithCapacity:2];
	[queries setValue:_UID forKey:kUIDQuery];
	[queries setValue:_fields forKey:kFieldsQuery];
	
	return queries;
}


#pragma mark -
#pragma mark BBMessageProtocol required methods

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBPrivatePostResponse class];
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
		if ([message isKindOfClass:[BBPrivatePostMessage class]] == YES)
		{
			return [self isEqualToPrivatePostMessage:(BBPrivatePostMessage *)message];
		}
	
	return NO;
}

- (NSUInteger)hash
{
	const NSUInteger superHash = super.hash;
	const NSUInteger uidHash = _UID.hash;
	const NSUInteger fieldsHash = _fields.hash;
	const NSUInteger hash = (superHash ^ uidHash ^ fieldsHash);
	
	return hash;
}


#pragma mark -
#pragma mark public

- (BOOL)isEqualToPrivatePostMessage:(BBPrivatePostMessage *)message
{
	if ([super isEqualToMessage:message] == YES)
    {
        const BOOL isPageEqual = (_UID == message.UID || [_UID isEqualToString:message.UID]);
        const BOOL isFieldsEqual = (_fields == message.fields || [_fields isEqualToSet:message.fields]);
        const BOOL isEqual = (isPageEqual && isFieldsEqual);
        
        return isEqual;
    }
    
    return NO;
}


@end
