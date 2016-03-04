//
//  BBAccessMessage.m
//  Boredat
//
//  Created by Dmitry Letko on 5/15/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBAccessMessage.h"
#import "BBAccessResponse.h"

#import "MgmtUtils.h"


static NSString *const kAccessComponent = @"/oauth/access_token";
static NSString *const kOAuthVerifier = @"oauth_verifier";


@interface BBAccessMessage ()

- (BOOL)isEqualToAccessMessage:(BBAccessMessage *)message;

@end


@implementation BBAccessMessage


#pragma mark -
#pragma mark BBMessageProtocol required methods

- (NSString *)HTTPMethod
{
	return cHTTPMethodPOST;
}

- (NSString *)URLString
{
	return [self.server stringByAppendingString:kAccessComponent];
}

- (NSDictionary *)additional
{
	NSMutableDictionary *additional = [NSMutableDictionary dictionary];
	[additional setValue:_verifier forKey:kOAuthVerifier];
	
	return additional;
}

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBAccessResponse class];
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
		if ([message isKindOfClass:[BBAccessMessage class]] == YES)
		{
			return [self isEqualToAccessMessage:(BBAccessMessage *)message];
		}
	
	return NO;
}

- (NSUInteger)hash
{
	const NSUInteger superHash = super.hash;
	const NSUInteger verifierHash = _verifier.hash;
	const NSUInteger hash = (superHash ^ verifierHash);
	
	return hash;
}

- (BOOL)isEqualToAccessMessage:(BBAccessMessage *)message
{	
	const BOOL isSuperEqual = [super isEqualToMessage:message];
	const BOOL isVerifierEqual = [_verifier isEqualToString:message.verifier];
	const BOOL isEqual = (isSuperEqual && isVerifierEqual);
	
	return isEqual;
}

@end
