//
//  BBCreationMessage.m
//  Boredat
//
//  Created by Dmitry Letko on 2/22/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBCreationMessage.h"
#import "BBCreationResponse.h"
#import "MgmtUtils.h"
#import "BBToken.h"

@interface BBCreationMessage ()

- (BOOL)isEqualToCreationMessage:(BBCreationMessage *)message;

@end


@implementation BBCreationMessage


#pragma mark -
#pragma mark NSMutableCopying required methods

- (id)mutableCopyWithZone:(NSZone *)zone
{
    BBCreationMessage *copy = [super mutableCopyWithZone:zone];
    copy.userID = _userID;
    copy.password = _password;
    
    return copy;
}

#pragma mark -
#pragma mark BBMessage overload

- (NSString *)pathComponent
{
    return @"/register/create_user";
}

#pragma mark -
#pragma mark BBHTTPProtocol required methods

- (NSString *)HTTPMethod
{
    return cHTTPMethodPOST;
}

- (NSDictionary *)HTTPBodyParameters
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
    [parameters setValue:_userID forKey:@"user_id"];
    [parameters setValue:_password forKey:@"pass"];
    
    return parameters;
}

#pragma mark -
#pragma mark BBMessageProtocol required methods

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBCreationResponse class];
}

- (BOOL)isEqualToMessage:(id<BBMessageProtocol>)message
{
	if (self == message)
	{
		return YES;
	}
	else
		if ([message isKindOfClass:[BBCreationMessage class]] == YES)
		{
			return [self isEqualToCreationMessage:(BBCreationMessage *)message];
		}
	
	return NO;
}

- (NSUInteger)hash
{
	const NSUInteger superHash = super.hash;
    const NSUInteger userIDHash = _userID.hash;
    const NSUInteger passwordHash = _password.hash;
	const NSUInteger hash = (superHash ^ userIDHash ^ passwordHash);
	
	return hash;
}


#pragma mark -
#pragma mark private

- (BOOL)isEqualToCreationMessage:(BBCreationMessage *)message
{
	const BOOL isSuperEqual = [super isEqualToMessage:message];
    const BOOL isUserIDEqual = [_userID isEqualToString:message.userID];
    const BOOL isPasswordEqual = [_password isEqualToString:message.password];
	const BOOL isEqual = (isSuperEqual && isUserIDEqual && isPasswordEqual);
	
	return isEqual;
}

@end
