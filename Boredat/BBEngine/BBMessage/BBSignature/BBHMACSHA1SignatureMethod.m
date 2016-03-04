//
//  BBHMACSHA1SignatureMethod.m
//  Boredat
//
//  Created by Dmitry Letko on 5/14/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBHMACSHA1SignatureMethod.h"

#import "NSString+BBSignature.h"


static NSString *const kSignatureName = @"HMAC-SHA1";


@interface BBHMACSHA1SignatureMethod ()

- (BOOL)isEqualToHMACSHA1Signature:(BBHMACSHA1SignatureMethod *)signature;

@end


@implementation BBHMACSHA1SignatureMethod

+ (id)method
{
	return [self new];
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}


#pragma mark -
#pragma mark BBSignatureMethodProtocol required methods

- (NSString *)name
{
	return kSignatureName;
}

- (NSData *)signText:(NSString *)text secret:(NSString *)secret
{
	return [text HMAC_SHA1_DataWithKey:secret];	
}


#pragma mark -
#pragma mark equality

- (BOOL)isEqual:(id)object
{
	if (self == object)
	{
		return YES;
	}
	else
		if ([object conformsToProtocol:@protocol(BBSignatureMethodProtocol)] == YES)
		{
			return [self isEqualToSignature:(id<BBSignatureMethodProtocol>)object];
		}
	
	return NO;
}

- (NSUInteger)hash
{
	return (NSUInteger)self.name;
}

- (BOOL)isEqualToSignature:(id<BBSignatureMethodProtocol>)signature
{
	if ([signature isKindOfClass:[BBHMACSHA1SignatureMethod class]] == YES)
	{
		return [self isEqualToHMACSHA1Signature:(BBHMACSHA1SignatureMethod *)signature];
	}
	
	return NO;
}


#pragma mark -
#pragma mark private

- (BOOL)isEqualToHMACSHA1Signature:(BBHMACSHA1SignatureMethod *)signature
{
	return YES;
}

@end
