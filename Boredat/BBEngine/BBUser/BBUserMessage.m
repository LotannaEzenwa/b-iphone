//
//  BBUserMessage.m
//  Boredat
//
//  Created by Dmitry Letko on 1/30/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBUserMessage.h"
#import "BBUserResponse.h"

#import "MgmtUtils.h"


static NSString *const kFieldsQuery = @"fields";
static NSString *const kFieldsSeparator = @",";


@implementation BBUserMessage


#pragma mark -
#pragma mark NSMutableCopy callbacks

- (id)mutableCopyWithZone:(NSZone *)zone
{
	BBUserMessage *copy = [super mutableCopyWithZone:zone];
	copy.fields = _fields;
	
	return copy;
}

- (NSDictionary *)URLQueries
{
    NSString *fields = [_fields.allObjects componentsJoinedByString:kFieldsSeparator];
    
	NSMutableDictionary *queries = [NSMutableDictionary dictionaryWithCapacity:1];
	[queries setValue:fields forKey:kFieldsQuery];
	    
	return queries;
}


#pragma mark -
#pragma mark BBHTTPProtocol required methods

- (NSString *)pathComponent
{
    return @"/user";
}


#pragma mark BBMessageProtocol required methods
#pragma mark -

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBUserResponse class];
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
		if ([message isKindOfClass:[BBUserMessage class]] == YES)
		{
			return [self isEqualToUserMessage:(BBUserMessage *)message];
		}
	
	return NO;
}

- (NSUInteger)hash
{
	const NSUInteger superHash = super.hash;
	const NSUInteger fieldsHash = _fields.hash;
	const NSUInteger hash = (superHash ^ fieldsHash);
	
	return hash;
}


#pragma mark -
#pragma mark public

- (BOOL)isEqualToUserMessage:(BBUserMessage *)message
{
	if ([super isEqualToMessage:message] == YES)
    {
        return (_fields == message.fields || [_fields isEqualToSet:message.fields]);
    }
	
    return NO;
}

@end
