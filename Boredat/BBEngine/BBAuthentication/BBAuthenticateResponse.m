//
//  BBAuthenticateResponse.m
//  Boredat
//
//  Created by Dmitry Letko on 5/17/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBAuthenticateResponse.h"
#import "BBToken.h"
#import "BBResponseDataProtocol.h"

#import "MgmtUtils.h"

#import "NSDictionary+Query.h"


static NSString *const kOAuthTokenKey = @"oauth_token";
static NSString *const kOAuthVerifier = @"oauth_verifier";


@interface BBAuthenticateResponse ()
@property (copy, nonatomic, readwrite) NSString *host;
@property (copy, nonatomic, readwrite) BBToken *token;
@property (copy, nonatomic, readwrite) NSString *verifier;

@end


@implementation BBAuthenticateResponse

#pragma mark -
#pragma mark BBResponse methods

+ (BOOL)JSONObject
{
	return NO;
}

- (id)initWithData:(id<BBResponseDataProtocol>)data
{
	self = [super initWithData:data];
	
	if (self != nil)
	{
		NSURL *URL = data.URLRedirection.URL;
		NSString *host = URL.host;
		NSString *query = URL.query;
		NSDictionary *queries = [NSDictionary dictionaryWithQuery:query];
		NSString *tokenKey = [queries objectForKey:kOAuthTokenKey];
		NSString *verifier = [queries objectForKey:kOAuthVerifier];
		
		_host = [host copy];
		_token = [[BBToken alloc] initWithKey:tokenKey secret:nil];
		_verifier = [verifier copy];
	}
	
	return self;
}

@end
