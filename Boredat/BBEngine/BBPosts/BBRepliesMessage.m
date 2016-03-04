//
//  BBRepliesMessage.m
//  Boredat
//
//  Created by Dmitry Letko on 1/24/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBRepliesMessage.h"
#import "BBRepliesResponse.h"

#import "MgmtUtils.h"


static NSString *const kUIDQuery = @"id";
static NSString *const kFieldsQuery = @"fields";


@implementation BBRepliesMessage


#pragma mark -
#pragma mark NSMutableCopy callbacks

- (id)mutableCopyWithZone:(NSZone *)zone
{
	BBRepliesMessage *copy = [super mutableCopyWithZone:zone];
	copy.UID = _UID;
	copy.fields = _fields;
	
	return copy;
}


#pragma mark -
#pragma mark BBMessage overload

- (NSString *)pathComponent
{
    return @"/replies";
}


#pragma mark -
#pragma mark BBHTTPProtocol required methods

- (NSDictionary *)URLQueries
{
    NSString *fields = [_fields.allObjects componentsJoinedByString:@","];
    
	NSMutableDictionary *queries = [NSMutableDictionary dictionaryWithCapacity:2];
	[queries setValue:_UID forKey:kUIDQuery];
	[queries setValue:fields forKey:kFieldsQuery];
	
	return queries;
}


#pragma mark -
#pragma mark BBMessageProtocol required methods
#pragma mark -

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBRepliesResponse class];
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
		if ([message isKindOfClass:[BBRepliesMessage class]] == YES)
		{
			return [self isEqualToRepliesMessage:(BBRepliesMessage *)message];
		}
	
	return NO;
}

- (NSUInteger)hash
{
	const NSUInteger superHash = super.hash;
	const NSUInteger pageHash = _UID.hash;
	const NSUInteger fieldsHash = _fields.hash;
	const NSUInteger hash = (superHash ^ pageHash ^ fieldsHash);
	
	return hash;
}


#pragma mark -
#pragma mark public

- (BOOL)isEqualToRepliesMessage:(BBRepliesMessage *)message
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
