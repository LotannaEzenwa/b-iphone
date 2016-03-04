//
//  BBZeitgeistMessage.m
//  Boredat
//
//  Created by Anton Kolosov on 10/9/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBZeitgeistMessage.h"

static NSString *const kFieldsQuery = @"fields";

@implementation BBZeitgeistMessage


- (id)mutableCopyWithZone:(NSZone *)zone
{
	BBZeitgeistMessage *copy = [super mutableCopyWithZone:zone];
	copy.fields = _fields;
	
	return copy;
}

- (NSDictionary *)URLQueries
{
    NSString *fields = [_fields.allObjects componentsJoinedByString:@","];
    
	NSMutableDictionary *queries = [NSMutableDictionary dictionaryWithCapacity:1];
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
		if ([message isKindOfClass:[BBZeitgeistMessage class]] == YES)
		{
			return [self isEqualToZeitgeistMessage:(BBZeitgeistMessage *)message];
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

- (BOOL)isEqualToZeitgeistMessage:(BBZeitgeistMessage *)message
{
    if ([super isEqualToMessage:message] == YES)
    {
        const BOOL isFieldsEqual = (_fields == message.fields || [_fields isEqualToSet:message.fields]);
        
        return isFieldsEqual;
    }
    
    return NO;
}


@end
