//
//  BBToken.m
//  Boredat
//
//  Created by Dmitry Letko on 5/10/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBToken.h"

#import "MgmtUtils.h"


static NSString *const kKey = @"key";
static NSString *const kSecret = @"secret";


@interface BBToken ()
@property (copy, nonatomic, readwrite) NSString *key;
@property (copy, nonatomic, readwrite) NSString *secret;

@end


@implementation BBToken

+ (id)tokenWithKey:(NSString *)key secret:(NSString *)secret
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
#pragma mark NSCoding callbacks

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_key forKey:kKey];
    [coder encodeObject:_secret forKey:kSecret];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if (self != nil)
    {
        _key = [[decoder decodeObjectForKey:kKey] copy];
        _secret = [[decoder decodeObjectForKey:kSecret] copy];
    }
    
    return self;
}


#pragma mark -
#pragma mark equality

- (BOOL)isEqual:(id)object
{	
	if ([object isKindOfClass:[BBToken class]] == YES)
	{
		return [self isEqualToToken:(BBToken *)object];
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

- (BOOL)isEqualToToken:(BBToken *)token
{
	if (self == token)
	{
		return YES;
	}
	else
	{
		const BOOL isKeyEqual = [_key isEqualToString:token.key];
		const BOOL isSecretEqual = [_secret isEqualToString:token.secret];
		const BOOL isEqual = (isKeyEqual && isSecretEqual);
		
		return isEqual;
	}
}

@end
