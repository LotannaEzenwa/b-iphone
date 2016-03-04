//
//  BBVerificationMessage.m
//  Boredat
//
//  Created by Dmitry Letko on 2/21/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBVerificationMessage.h"
#import "BBVerificationResponse.h"

#import "MgmtUtils.h"


static NSString *const kRequestComponent = @"/register/status";

static NSString *const kKey = @"email_verification_token";


@interface BBVerificationMessage ()

- (BOOL)isEqualToVerificationMessage:(BBVerificationMessage *)message;

@end


@implementation BBVerificationMessage


#pragma mark -
#pragma mark NSMutableCopying required methods

- (id)mutableCopyWithZone:(NSZone *)zone
{
    BBVerificationMessage *copy = [super mutableCopyWithZone:zone];
    copy.key = _key;
    
    return copy;
}


#pragma mark -
#pragma mark BBHTTPProtocol required methods

- (NSString *)HTTPMethod
{
	return cHTTPMethodGET;
}

- (NSString *)URLString
{
	return [self.server stringByAppendingString:kRequestComponent];
}

- (NSDictionary *)URLQueries
{
	NSMutableDictionary *queries = [NSMutableDictionary dictionaryWithCapacity:1];
    [queries setValue:_key forKey:kKey];
    
	return queries;
}


#pragma mark -
#pragma mark BBMessageProtocol required methods

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBVerificationResponse class];
}

- (BOOL)isEqualToMessage:(id<BBMessageProtocol>)message
{
	if (self == message)
	{
		return YES;
	}
	else
		if ([message isKindOfClass:[BBVerificationMessage class]] == YES)
		{
			return [self isEqualToVerificationMessage:(BBVerificationMessage *)message];
		}
	
	return NO;
}

- (NSUInteger)hash
{
	const NSUInteger superHash = super.hash;
	const NSUInteger keyHash = _key.hash;
	const NSUInteger hash = (superHash ^ keyHash);
	
	return hash;
}


#pragma mark -
#pragma mark private

- (BOOL)isEqualToVerificationMessage:(BBVerificationMessage *)message
{
	const BOOL isSuperEqual = [super isEqualToMessage:message];
	const BOOL isKeyEqual = [_key isEqualToString:message.key];
	const BOOL isEqual = (isSuperEqual && isKeyEqual);
	
	return isEqual;
}

@end
