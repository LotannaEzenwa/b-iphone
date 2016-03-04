//
//  BBRequestResponse.m
//  Boredat
//
//  Created by Dmitry Letko on 5/16/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBRequestResponse.h"
#import "BBToken.h"
#import "BBResponseDataProtocol.h"

#import "MgmtUtils.h"

#import "NSObject+NULL.h"


static NSString *const kTokenKey = @"oauth_token";
static NSString *const kTokenSecret = @"oauth_token_secret";
static NSString *const kTokenTTL = @"xoauth_token_ttl";
static NSString *const kConfirmed = @"oauth_callback_confirmed";


@interface BBRequestResponse ()
@property (copy, nonatomic, readwrite) BBToken *token;
@property (nonatomic, readwrite) NSInteger tokenTTL;
@property (nonatomic, readwrite) BOOL confirmed;

@end


@implementation BBRequestResponse

/*
 #pragma mark -
 #pragma mark BBResponse methods
 #pragma mark -
 
 + (BOOL)redirection
 {
 return NO;
 }
 
 
 #pragma mark -
 */

- (id)initWithData:(id<BBResponseDataProtocol>)data
{
	self = [super initWithData:data];
	
	if (self != nil)
	{
		NSDictionary *JSONDictionary = NSDictionaryObject(data.JSONObject);
        
        if (JSONDictionary.count > 0)
        {
            NSString *tokenKey = [JSONDictionary objectForKey:kTokenKey];
            NSString *tokenSecret = [JSONDictionary objectForKey:kTokenSecret];
            
            _token = [[BBToken alloc] initWithKey:tokenKey secret:tokenSecret];
            _tokenTTL = [[JSONDictionary objectForKey:kTokenTTL] integerValue];
            _confirmed = [[JSONDictionary objectForKey:kConfirmed] boolValue];
        }
	}
	
	return self;
}

@end
