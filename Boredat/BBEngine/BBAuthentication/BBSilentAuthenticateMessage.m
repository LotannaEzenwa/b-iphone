//
//  BBSilentAuthenticateMessage.m
//  Boredat
//
//  Created by Dmitry Letko on 5/15/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBSilentAuthenticateMessage.h"
#import "BBSilentAuthenticateMessage.h"
#import "BBToken.h"

#import "NSMutableString+Concatenate.h"
#import "NSString+URLEncoding.h"


@interface BBSilentAuthenticateMessage ()

- (BOOL)isEqualToSilentAuthenticateMessage:(BBSilentAuthenticateMessage *)message;

@end


@implementation BBSilentAuthenticateMessage


static NSString *const cBBAuthenticateLoginURLString = @"http://192.168.1.246:8082/actions/login.php";
//static NSString *const cAuthenticateComponent = @"";

static NSString *const cNameLogin = @"d_x";
static NSString *const cNamePassword = @"d_y";


- (id)mutableCopyWithZone:(NSZone *)zone
{
	BBSilentAuthenticateMessage *copy = [super mutableCopyWithZone:zone];
	copy.login = self.login;
	copy.password = self.password;
	
	return copy;
}



#pragma mark -
#pragma mark BBMessageProtocol required methods

- (NSString *)HTTPMethod
{
	return cHTTPMethodPOST;
}

- (NSDictionary *)HTTPBodyParameters
{		
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];	
	[parameters setValue:self.login forKey:cNameLogin];
	[parameters setValue:self.password forKey:cNamePassword];		
	
	return parameters;
}

- (NSString *)URLString
{	
	return cBBAuthenticateLoginURLString;
	//return [self.server stringByAppendingString:cAuthenticateComponent];
}

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBSilentAuthenticateMessage class];
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
		if ([message isKindOfClass:[BBSilentAuthenticateMessage class]] == YES)
		{
			return [self isEqualToSilentAuthenticateMessage:(BBSilentAuthenticateMessage *)message];
		}
	
	return NO;
}

- (NSUInteger)hash
{
	const NSUInteger superHash = super.hash;
	const NSUInteger loginHash = self.login.hash;
	const NSUInteger passwordHash = self.password.hash;
	const NSUInteger hash = (superHash + loginHash + passwordHash);
	
	return hash;
}

- (BOOL)isEqualToSilentAuthenticateMessage:(BBSilentAuthenticateMessage *)message
{	
	const BOOL isSuperEqual = [super isEqualToMessage:message];
	const BOOL isLoginEqual = [self.login isEqualToString:message.login];
	const BOOL isPasswordEqual = [self.password isEqualToString:message.password];
	const BOOL isEqual = (isSuperEqual && isLoginEqual && isPasswordEqual);
	
	return isEqual;
}

@end
