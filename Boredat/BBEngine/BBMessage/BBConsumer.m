//
//  BBConsumer.m
//  Boredat
//
//  Created by Dmitry Letko on 5/10/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBConsumer.h"

#import "MgmtUtils.h"


@interface BBConsumer ()
@property (copy, nonatomic, readwrite) NSString *key;
@property (copy, nonatomic, readwrite) NSString *secret;

@end


@implementation BBConsumer


+ (id)consumerWithKey:(NSString *)key secret:(NSString *)secret
{
	return [[self alloc] initWithKey:key secret:secret];
}

- (id)initWithKey:(NSString *)key secret:(NSString *)secret
{
	self = [super init];
	
	if (self != nil)
	{
		_key = [key copy];
		_secret = [secret copy];
	}
	
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}


#pragma mark -
#pragma mark equality

- (BOOL)isEqual:(id)object
{	
	if ([object isKindOfClass:[BBConsumer class]] == YES)
	{
		return [self isEqualToConsumer:(BBConsumer *)object];
	}
	
	return NO;
}

- (NSUInteger)hash
{
	const NSUInteger keyHash = _key.hash;
	const NSUInteger keySecret = _secret.hash;
	const NSUInteger hash = keyHash ^ keySecret;
	
	return hash;
}

- (BOOL)isEqualToConsumer:(BBConsumer *)consumer
{
	if (self == consumer)
	{
		return YES;
	}
	else
	{
		const BOOL isKeyEqual = [_key isEqualToString:consumer.key];
		const BOOL isSecretEqual = [_secret isEqualToString:consumer.secret];
		const BOOL isEqual = (isKeyEqual && isSecretEqual);
		
		return isEqual;
	}
}

@end
