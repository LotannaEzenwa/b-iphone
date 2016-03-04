//
//  BBMessage.m
//  Boredat
//
//  Created by Dmitry Letko on 5/11/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBMessage.h"
#import "BBConsumer.h"
#import "BBToken.h"
#import "BBResponse.h"
#import "BBHMACSHA1SignatureMethod.h"

#import "MgmtUtils.h"


NSString *const cHTTPMethodGET = @"GET";
NSString *const cHTTPMethodPOST = @"POST";

@implementation BBMessage


+ (id)message
{
	return [self new];
}

- (id)init
{
	self = [super init];
	
	if (self != nil)
	{
		_signatureMethod = [BBHMACSHA1SignatureMethod new];
        _priority = NSOperationQueuePriorityNormal;
	}
	
	return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
	BBMessage *copy = [[[self class] allocWithZone:zone] init];
	copy.server = _server;
	copy.consumer = _consumer;
	copy.token = _token;
	copy.callback = _callback;
	copy.signatureMethod = _signatureMethod;
	
	return copy;
}


#pragma mark -
#pragma mark public

- (NSString *)pathComponent
{
    return nil;
}


#pragma mark -
#pragma mark BBHTTPProtocol required methods

- (NSString *)URLString
{
    if (self.pathComponent)
        return [_server stringByAppendingString:self.pathComponent];
    else
        return _server;
}

- (NSDictionary *)URLQueries
{
	return nil;
}

- (NSString *)HTTPMethod
{
	return cHTTPMethodGET;
}

- (NSDictionary *)HTTPHeaders
{
	return nil;
}

- (NSDictionary *)HTTPBodyParameters
{
	return nil;
}


#pragma mark -
#pragma mark BBAuthorizationProtocol required methods

- (NSDictionary *)additional
{
	return nil;
}

- (BOOL)authorization
{
	return YES;
}

- (Class<BBResponseProtocol>)BBResponseClass
{
	return nil;
}


#pragma mark -
#pragma mark BBMessageProtocol required methods
#pragma mark -

- (id)clone
{
	return [self mutableCopy];
}


#pragma mark -
#pragma mark equality

- (BOOL)isEqual:(id)object
{
	return [self isEqualToMessage:(BBMessage *)object];
}

- (NSUInteger)hash
{
	const NSUInteger serverHash = _server.hash;
	const NSUInteger consumerHash = _consumer.hash;
	const NSUInteger tokenHash = _token.hash;
	const NSUInteger callbackHash = _callback.hash;
	const NSUInteger signatureHash = _signatureMethod.hash;
	const NSUInteger hash = (serverHash ^ consumerHash ^ tokenHash ^ callbackHash ^ signatureHash);
	
	return hash;
}

- (BOOL)isEqualToMessage:(BBMessage *)message
{
	if (self == message)
	{
		return YES;
	}
	else
		if ([message isKindOfClass:[BBMessage class]] == YES)
		{
			const BOOL isServerEqual = (_server == message.server || [_server isEqualToString:message.server]);
			const BOOL isConsumerEqual = (_consumer == message.consumer || [_consumer isEqualToConsumer:message.consumer]);
			const BOOL isTokenEqual = (_token == message.token || [_token isEqualToToken:message.token]);
			const BOOL isCallbackEqual = (_callback == message.callback || [_callback isEqualToString:message.callback]);
			const BOOL isSignatureEqual = (_signatureMethod == message.signatureMethod || [_signatureMethod isEqualToSignature:message.signatureMethod]);
			const BOOL isEqual = (isServerEqual && isConsumerEqual && isTokenEqual && isCallbackEqual && isSignatureEqual);
			
			return isEqual;
		}
	
	return NO;
}

@end
