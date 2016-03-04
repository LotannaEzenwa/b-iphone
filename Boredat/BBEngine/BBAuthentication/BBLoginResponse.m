//
//  BBLoginResponse.m
//  Boredat
//
//  Created by Dmitry Letko on 1/30/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBLoginResponse.h"
#import "BBResponseDataProtocol.h"
#import "BBToken.h"

#import "MgmtUtils.h"

#import "NSObject+NULL.h"


static NSString *const kOAuthTokenKey = @"oauth_token";
static NSString *const kOAuthVerifier = @"verifier";


@interface BBLoginResponse ()
@property (copy, nonatomic, readwrite) NSString *host;
@property (copy, nonatomic, readwrite) BBToken *token;
@property (copy, nonatomic, readwrite) NSString *verifier;

@end


@implementation BBLoginResponse

@synthesize host = _host;
@synthesize token = _token;
@synthesize verifier = _verifier;

/*
#pragma mark -
#pragma mark BBResponse overload

+ (BOOL)redirection
{
	return NO;
}


#pragma mark -
*/

+ (BOOL)JSONObject
{
	return YES;
}

- (id)initWithData:(id<BBResponseDataProtocol>)data
{
	self = [super initWithData:data];
	
	if (self != nil)
	{
        NSURL *URL = data.URLRedirection.URL;
        NSDictionary *JSONDictionary = NSDictionaryObject(data.JSONObject);
		NSString *tokenKey = [JSONDictionary objectForKey:kOAuthTokenKey];
		NSString *verifier = [JSONDictionary objectForKey:kOAuthVerifier];
        
        self.host = URL.host;
		self.token = [BBToken tokenWithKey:tokenKey secret:nil];
		self.verifier = verifier;
	}
	
	return self;
}

@end
