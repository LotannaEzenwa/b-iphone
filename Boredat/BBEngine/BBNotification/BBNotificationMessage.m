//
//  BBNotificationMessage.m
//  Boredat
//
//  Created by Dmitry Letko on 1/31/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBNotificationMessage.h"
#import "BBNotificationResponse.h"

#import "MgmtUtils.h"


static NSString *const kQueryPage = @"page";
//static NSString *const KQueryFields = @"fields";
static NSString *const KQueryCount = @"count";
static NSString *const KQueryLastID = @"notification_last_id";


@implementation BBNotificationMessage


#pragma mark -
#pragma mark NSMutableCopying callbacks

- (id)mutableCopyWithZone:(NSZone *)zone
{
	BBNotificationMessage *copy = [super mutableCopyWithZone:zone];
	copy.page = _page;
	//copy.fields = _fields;
    copy.count = _count;
    copy.lastID = _lastID;
	
	return copy;
}


#pragma mark -
#pragma mark BBMessage overload

- (NSString *)pathComponent
{
    return @"/notifications";
}


#pragma mark -
#pragma mark BBHTTPProtocol required methods

- (NSDictionary *)URLQueries
{
    NSMutableDictionary *queries = [NSMutableDictionary dictionaryWithCapacity:3];
    [queries setValue:_page forKey:kQueryPage];
    //[queries setValue:_fields forKey:KQueryFields];
    [queries setValue:_count forKey:KQueryCount];
    [queries setValue:_lastID forKey:KQueryLastID];
    
    return queries;
}


#pragma mark -
#pragma mark BBMessageProtocol required methods

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBNotificationResponse class];
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
		if ([message isKindOfClass:[BBNotificationMessage class]] == YES)
		{
			return [self isEqualToNotificationMessage:(BBNotificationMessage *)message];
		}
	
	return NO;
}

- (NSUInteger)hash
{
	const NSUInteger superHash = super.hash;
	const NSUInteger pageHash = _page.hash;
	//const NSUInteger fieldsHash = _fields.hash;
    const NSUInteger countHash = _count.hash;
    const NSUInteger lastIDHash = _lastID.hash;
	const NSUInteger hash = (superHash ^ pageHash /*^ fieldsHash*/ ^ countHash ^ lastIDHash);
	
	return hash;
}


#pragma mark -
#pragma mark public

- (BOOL)isEqualToNotificationMessage:(BBNotificationMessage *)message
{
    if ([super isEqualToMessage:message] == YES)
    {
        const BOOL isPageEqual = (_page == message.page || [_page isEqualToNumber:message.page]);
        //const BOOL isFieldsEqual = (_fields == message.fields || [_fields isEqualToSet:message.fields]);
        const BOOL isCountEqual = (_count == message.count || [_count isEqualToNumber:message.count]);
        const BOOL isLastIDEqual = (_lastID == message.lastID || [_lastID isEqualToString:message.lastID]);
        const BOOL isEqual = (isPageEqual /*&& isFieldsEqual*/ && isCountEqual && isLastIDEqual);
        
        return isEqual;
    }
    
    return NO;
}

@end
