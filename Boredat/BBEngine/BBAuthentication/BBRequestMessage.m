//
//  BBRequestMessage.m
//  Boredat
//
//  Created by Dmitry Letko on 5/15/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBRequestMessage.h"
#import "BBRequestResponse.h"


static NSString *const kRequestComponent = @"/oauth/request_token";


@implementation BBRequestMessage

#pragma mark -
#pragma mark BBMessageProtocol required methods

- (NSString *)HTTPMethod
{
	return cHTTPMethodPOST;
}

- (NSString *)URLString
{	
	return [self.server stringByAppendingString:kRequestComponent];
}

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBRequestResponse class];
}

@end
