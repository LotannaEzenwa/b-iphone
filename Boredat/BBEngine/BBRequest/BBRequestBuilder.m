//
//  BBRequestBuilder.m
//  Boredat
//
//  Created by Dmitry Letko on 5/11/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBRequestBuilder.h"
#import "BBMessageProtocol.h"
#import "BBRequest.h"
#import "BBConsumer.h"
#import "BBToken.h"
#import "BBSignatureMethodProtocol.h"
#import "BBUUID.h"

#import "NSData+Base64.h"
#import "NSString+URLEncoding.h"
#import "NSMutableString+Concatenate.h"
#import "NSDictionary+Query.h"


static NSString *const kNameConsumer = @"oauth_consumer_key";
static NSString *const kNameToken = @"oauth_token";
static NSString *const kNameTimestamp = @"oauth_timestamp";
static NSString *const kNameNonce = @"oauth_nonce";
static NSString *const kNameVersion = @"oauth_version";
static NSString *const kNameSignature = @"oauth_signature";
static NSString *const kNameMethod = @"oauth_signature_method";
static NSString *const kNameCallback = @"oauth_callback";

static NSString *const kHeaderAuthorization = @"Authorization";

static NSString *const kHeaderContentType = @"content-type";
static NSString *const cValueURLEncoded = @"application/x-www-form-urlencoded";

static NSString *const cQuerySign = @"?";
static NSString *const cParametersSeparator = @"&";
static NSString *const cBaseStringSeparator = @"&";
static NSString *const cSecretSeparator = @"&";

static NSString *const cAuthorizationPrefix = @"OAuth ";
static NSString *const cAuthorizationNameValueFormat = @"%@=\"%@\"";
static NSString *const cAuthorizationSeparator = @", ";


@interface BBRequestBuilder ()

+ (NSString *)timestamp;
+ (NSString *)nonce;
+ (NSString *)version;

@end


@implementation BBRequestBuilder

+ (BBRequest *)requestWithMessage:(id<BBMessageProtocol>)message
{			
	NSMutableString *URLString = [NSMutableString string];
	[URLString concatenateString:message.URLString];
	
	if (message.URLQueries.count > 0)
	{
		[URLString concatenateString:cQuerySign];
		[URLString concatenateString:message.URLQueries.URLEncodedString];
	}
		
	
	NSURL *URL = [NSURL URLWithString:URLString];
	NSData *HTTPBody = [message.HTTPBodyParameters.URLEncodedString dataUsingEncoding:NSUTF8StringEncoding];
	
	NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	URLRequest.HTTPMethod = message.HTTPMethod;
	URLRequest.allHTTPHeaderFields = message.HTTPHeaders;
	
	
	if (HTTPBody.length > 0)
	{
		[URLRequest setValue:kHeaderContentType forHTTPHeaderField:cValueURLEncoded];
		[URLRequest setHTTPBody:HTTPBody];	
	}
	
	
	if (message.authorization == YES)
	{
		NSMutableDictionary *authorizationDictionary = [NSMutableDictionary dictionary];		
		[authorizationDictionary setValue:self.timestamp forKey:kNameTimestamp];
		[authorizationDictionary setValue:self.version forKey:kNameVersion];
		[authorizationDictionary setValue:self.nonce forKey:kNameNonce];
		[authorizationDictionary setValue:message.consumer.key forKey:kNameConsumer];
		[authorizationDictionary setValue:message.token.key forKey:kNameToken];
		[authorizationDictionary setValue:message.callback forKey:kNameCallback];
		[authorizationDictionary setValue:message.signatureMethod.name forKey:kNameMethod];
		[authorizationDictionary addEntriesFromDictionary:message.additional];
		
		NSMutableDictionary *parametersDictionary = [NSMutableDictionary dictionary];
		[parametersDictionary addEntriesFromDictionary:authorizationDictionary];
		[parametersDictionary addEntriesFromDictionary:message.URLQueries];
		[parametersDictionary addEntriesFromDictionary:message.HTTPBodyParameters];
				
		NSArray *parametersArray = parametersDictionary.URLEncodedComponents;
		NSArray *parametersSortedArray = [parametersArray sortedArrayUsingSelector:@selector(compare:)];
		NSString *parametersString = [parametersSortedArray componentsJoinedByString:cParametersSeparator];
				        
		NSMutableString *baseString = [NSMutableString string];
		[baseString concatenateString:message.HTTPMethod.URLEncodedString];
		[baseString concatenateString:cBaseStringSeparator];
		[baseString concatenateString:message.URLString.URLEncodedString];
		[baseString concatenateString:cBaseStringSeparator];
		[baseString concatenateString:parametersString.URLEncodedString];
		
		NSMutableString *secret = [NSMutableString string];
		[secret concatenateString:message.consumer.secret.URLEncodedString];	
		[secret concatenateString:cSecretSeparator];
		[secret concatenateString:message.token.secret.URLEncodedString];
		
		NSData *signature = [message.signatureMethod signText:baseString secret:secret];		
		NSString *signatureBase64 = signature.base64EncodedString;
		        		
		//	
		[authorizationDictionary setValue:signatureBase64 forKey:kNameSignature];
		
		
		NSString *authorizationURLEncodedString = [authorizationDictionary URLEncodedStringWithFormat:cAuthorizationNameValueFormat separator:cAuthorizationSeparator];
		NSMutableString *authorizationString = [NSMutableString string];
		[authorizationString concatenateString:cAuthorizationPrefix];
		[authorizationString concatenateString:authorizationURLEncodedString];
				
		NSMutableDictionary *headers = [NSMutableDictionary dictionary];
		[headers setValue:authorizationString forKey:kHeaderAuthorization];		
		
		
		//	
		[URLRequest setValue:authorizationString forHTTPHeaderField:kHeaderAuthorization];
    }
    		
	
	BBRequest *request = [BBRequest requestWithURLRequest:URLRequest];
						
	
	return request;
}


#pragma mark -
#pragma mark private

+ (NSString *)timestamp
{
	return [NSString stringWithFormat:@"%ld", time(nil)];	
}

+ (NSString *)nonce
{
	BBUUID *uuid = [BBUUID uuid];
	NSString *nonce = uuid.HEXString;
	
	return nonce;
}

+ (NSString *)version
{
	return @"1.0";
}

@end
