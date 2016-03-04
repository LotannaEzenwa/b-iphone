//
//  BBLoginMessage.m
//  Boredat
//
//  Created by Dmitry Letko on 1/30/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBLoginMessage.h"
#import "BBLoginResponse.h"

#import "BBToken.h"

#import "MgmtUtils.h"


static NSString *const kQueryLogin = @"login";
static NSString *const kQueryPassword = @"pass";
static NSString *const kQueryToken = @"oauth_token";


@implementation BBLoginMessage


#pragma mark -
#pragma mark NSMutableCopying callbacks

- (id)mutableCopyWithZone:(NSZone *)zone
{
	BBLoginMessage *copy = [super mutableCopyWithZone:zone];
	copy.userID = _userID;
	copy.password = _password;
	
	return copy;
}


#pragma mark -
#pragma mark BBHTTPProtocol required methods

- (NSString *)pathComponent
{
    return @"/oauth/login";
}


#pragma mark -
#pragma mark BBHTTPProtocol callbacks

- (NSDictionary *)URLQueries
{
    NSString *tokenKey = self.token.key;
    
	NSMutableDictionary *queries = [NSMutableDictionary dictionaryWithCapacity:3];
    [queries setValue:tokenKey forKey:kQueryToken];
	[queries setValue:_userID forKey:kQueryLogin];
	[queries setValue:_password forKey:kQueryPassword];
	    
	return queries;
}


#pragma mark -
#pragma mark BBMessageProtocol callbacks

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBLoginResponse class];
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
		if ([message isKindOfClass:[BBLoginMessage class]] == YES)
		{
			return [self isEqualToLoginMessage:(BBLoginMessage *)message];
		}
	
	return NO;
}

- (NSUInteger)hash
{
	const NSUInteger superHash = super.hash;
	const NSUInteger userIDHash = _userID.hash;
    const NSUInteger passwordHash = _password.hash;
	const NSUInteger hash = (superHash ^ userIDHash & passwordHash);
	
	return hash;
}


#pragma mark -
#pragma mark public

- (BOOL)isEqualToLoginMessage:(BBLoginMessage *)message
{
	if ([super isEqualToMessage:message] == YES)
    {
        const BOOL isUserIDEqual = (_userID == message.userID || [_userID isEqualToString:message.userID]);
        const BOOL isPasswordEqual = (_password == message.password || [_password isEqualToString:message.password]);
        
        return (isUserIDEqual && isPasswordEqual);
    }
	
    return NO;
}

@end
