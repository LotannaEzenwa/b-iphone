//
//  BBAuthenticateMessage.m
//  Boredat
//
//  Created by Dmitry Letko on 5/26/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBAuthenticateMessage.h"
#import "BBToken.h"


static NSString *const kOAuthToken = @"oauth_token";


@implementation BBAuthenticateMessage


#pragma mark -
#pragma mark BBMessageProtocol required methods

- (NSDictionary *)URLQueries
{
	NSMutableDictionary *queries = [NSMutableDictionary dictionary];
	[queries setValue:self.token.key forKey:kOAuthToken];
	
	return queries;
}

- (BOOL)authorization
{
	return NO;
}

@end
