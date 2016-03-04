//
//  BBPostsMessage.m
//  Boredat
//
//  Created by Dmitry Letko on 5/14/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBPostsMessage.h"
#import "BBPostsResponse.h"

#import "MgmtUtils.h"


static NSString *const kQueryPage = @"page";
static NSString *const kQueryFields = @"fields";


@implementation BBPostsMessage

- (id)mutableCopyWithZone:(NSZone *)zone
{
	BBPostsMessage *copy = [super mutableCopyWithZone:zone];
	copy.page = _page;
	copy.fields = _fields;
	
	return copy;
}


#pragma mark -
#pragma mark BBMessage overload

- (NSString *)pathComponent
{
    return @"/posts/feed";
}


#pragma mark -
#pragma mark BBHTTPProtocol required methods

- (NSDictionary *)URLQueries
{
    NSString *fields = [_fields.allObjects componentsJoinedByString:@","];
    
	NSMutableDictionary *queries = [NSMutableDictionary dictionaryWithCapacity:2];
	[queries setValue:_page forKey:kQueryPage];
	[queries setValue:fields forKey:kQueryFields];
	
	return queries;
}


#pragma mark -
#pragma mark BBMessageProtocol required methods
#pragma mark -

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBPostsResponse class];
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
		if ([message isKindOfClass:[BBPostsMessage class]] == YES)
		{
			return [self isEqualToPostsMessage:(BBPostsMessage *)message];
		}
	
	return NO;
}

- (NSUInteger)hash
{
	const NSUInteger superHash = super.hash;
	const NSUInteger pageHash = _page.hash;
	const NSUInteger fieldsHash = _fields.hash;
	const NSUInteger hash = (superHash ^ pageHash ^ fieldsHash);
	
	return hash;
}


#pragma mark -
#pragma mark public

- (BOOL)isEqualToPostsMessage:(BBPostsMessage *)message
{	
	const BOOL isSuperEqual = [super isEqualToMessage:message];
	const BOOL isPageEqual = (_page == message.page || [_page isEqualToNumber:message.page]);
	const BOOL isFieldsEqual = (_fields == message.fields || [_fields isEqualToSet:message.fields]);
	const BOOL isEqual = (isSuperEqual && isPageEqual && isFieldsEqual);
	
	return isEqual;
}

@end
