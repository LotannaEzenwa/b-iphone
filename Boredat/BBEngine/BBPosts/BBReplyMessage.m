//
//  BBReplyMessage.m
//  Boredat
//
//  Created by Dmitry Letko on 5/23/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBReplyMessage.h"
#import "BBStatusResponse.h"

#import "MgmtUtils.h"


static NSString *const kQueryText = @"text";
static NSString *const kQueryAnonymously = @"anonymously";
static NSString *const kQueryLocationUID = @"locationId";
static NSString *const kQueryUID = @"id";


@implementation BBReplyMessage

- (id)mutableCopyWithZone:(NSZone *)zone
{
	BBReplyMessage *copy = [super mutableCopyWithZone:zone];
	copy.text = _text;
	copy.anonymously = _anonymously;
	copy.locationUID = _locationUID;
	copy.UID = _UID;
	
	return copy;
}


#pragma mark -
#pragma mark BBMessage overload

- (NSString *)pathComponent
{
    return @"/post";
}


#pragma mark -
#pragma mark BBMessageProtocol required methods

- (NSString *)HTTPMethod
{
	return cHTTPMethodPOST;
}

- (NSDictionary *)HTTPBodyParameters
{    
	NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:4];
	[parameters setValue:_text forKey:kQueryText];
	[parameters setValue:_anonymously forKey:kQueryAnonymously];
	[parameters setValue:_locationUID forKey:kQueryLocationUID];
	[parameters setValue:_UID forKey:kQueryUID];
	
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
		if ([message isKindOfClass:[BBReplyMessage class]] == YES)
		{
			return [self isEqualToReplyMessage:(BBReplyMessage *)message];
		}
	
	return NO;
}

- (NSUInteger)hash
{
	const NSUInteger superHash = super.hash;
	const NSUInteger textHash = _text.hash;
	const NSUInteger anonymouslyHash = _anonymously.hash;
	const NSUInteger locationUIDHash = _locationUID.hash;
	const NSUInteger UIDEqual = _UID.hash;
	const NSUInteger hash = (superHash ^ textHash ^ anonymouslyHash ^ locationUIDHash ^ UIDEqual);
	    
	return hash;
}


#pragma mark -
#pragma mark public

- (BOOL)isEqualToReplyMessage:(BBReplyMessage *)message
{
    if ([super isEqualToMessage:message] == YES)
    {
        const BOOL isTextEqual = (_text == message.text || [_text isEqualToString:message.text]);
        const BOOL isAnonymouslyEqual = (_anonymously == message.anonymously || [_anonymously isEqualToNumber:message.anonymously]);
        const BOOL isLocationUIDEqual = (_locationUID == message.locationUID || [_locationUID isEqualToString:message.locationUID]);
        const BOOL isUIDEqual = (_UID == message.UID || [_UID isEqualToString:message.UID]);
        const BOOL isEqual = (isTextEqual && isAnonymouslyEqual && isLocationUIDEqual && isUIDEqual);
        
        return isEqual;
    }
    
    return NO;
}

@end
