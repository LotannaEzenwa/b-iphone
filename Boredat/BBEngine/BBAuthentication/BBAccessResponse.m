//
//  BBAccessResponse.m
//  Boredat
//
//  Created by Dmitry Letko on 5/17/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBAccessResponse.h"
#import "BBToken.h"
#import "BBResponseDataProtocol.h"

#import "MgmtUtils.h"

#import "NSObject+NULL.h"


static NSString *const kOAuthTokenKey = @"oauth_token";
static NSString *const kOAuthTokenSecret = @"oauth_token_secret";


@interface BBAccessResponse ()
@property (copy, nonatomic, readwrite) BBToken *token;

@end


@implementation BBAccessResponse

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
            NSString *tokenKey = [JSONDictionary objectForKey:kOAuthTokenKey];
            NSString *tokenSecret = [JSONDictionary objectForKey:kOAuthTokenSecret];
                        
            _token = [[BBToken alloc] initWithKey:tokenKey secret:tokenSecret];
        }
	}
	
	return self;
}

@end
