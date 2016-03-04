//
//  BBWebAuthenticateMessage.m
//  Boredat
//
//  Created by Dmitry Letko on 5/25/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBWebAuthenticateMessage.h"
#import "BBWebAuthenticateResponse.h"
#import "BBToken.h"


@implementation BBWebAuthenticateMessage


static NSString *const cAuthorizeComponent = @"/oauth/authorize";


#pragma mark -
#pragma mark BBMessageProtocol required methods

- (NSString *)HTTPMethod
{
	return cHTTPMethodGET;
}

- (NSString *)URLString
{		
	return [self.server stringByAppendingString:cAuthorizeComponent];
}

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBWebAuthenticateResponse class];
}

@end
