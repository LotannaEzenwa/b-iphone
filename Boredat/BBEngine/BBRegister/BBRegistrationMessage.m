//
//  BBRegistrationMessage.m
//  Boredat
//
//  Created by Dmitry Letko on 2/21/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBRegistrationMessage.h"
#import "BBRegistrationResponse.h"

#import "MgmtUtils.h"


@interface BBRegistrationMessage ()

- (BOOL)isEqualToRegistrationMessage:(BBRegistrationMessage *)message;

@end


@implementation BBRegistrationMessage

#pragma mark -
#pragma mark NSMutableCopying required methods

- (id)mutableCopyWithZone:(NSZone *)zone
{
    BBRegistrationMessage *copy = [super mutableCopyWithZone:zone];
    copy.attempt_code = _attempt_code;
    copy.email = _email;
    copy.pin = _pin;
    
    return copy;
}


#pragma mark -
#pragma mark BBHTTPProtocol required methods

- (NSString *)HTTPMethod
{
	return cHTTPMethodPOST;
}

- (NSString *)URLString
{
	return [self.server stringByAppendingString:@"/register/email_verify"];
}

- (NSDictionary *)HTTPBodyParameters
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:3];
    [parameters setValue:_email forKey:@"email"];
    [parameters setValue:_attempt_code forKey:@"attempt_code"];
    [parameters setValue:_pin forKey:@"pin"];
    
    return parameters;
}


#pragma mark -
#pragma mark BBMessageProtocol required methods

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBRegistrationResponse class];
}

- (BOOL)isEqualToMessage:(id<BBMessageProtocol>)message
{
	if (self == message)
	{
		return YES;
	}
	else
		if ([message isKindOfClass:[BBRegistrationMessage class]] == YES)
		{
			return [self isEqualToRegistrationMessage:(BBRegistrationMessage *)message];
		}
	
	return NO;
}

- (NSUInteger)hash
{
	const NSUInteger superHash = super.hash;
	const NSUInteger emailHash = _email.hash;
    const NSUInteger attemptHash = _attempt_code.hash;
	const NSUInteger pinHash = _pin.hash;
	const NSUInteger hash = (superHash ^ emailHash ^ attemptHash ^ pinHash);
	
	return hash;
}


#pragma mark -
#pragma mark private

- (BOOL)isEqualToRegistrationMessage:(BBRegistrationMessage *)message
{
	const BOOL isSuperEqual = [super isEqualToMessage:message];
	const BOOL isEmailEqual = [_email isEqualToString:message.email];
    const BOOL isAttemptEqual = [_attempt_code isEqualToString:message.attempt_code];
	const BOOL isPinEqual = [_pin isEqualToString:message.pin];
	const BOOL isEqual = (isSuperEqual && isEmailEqual && isAttemptEqual && isPinEqual);
	
	return isEqual;
}

@end
