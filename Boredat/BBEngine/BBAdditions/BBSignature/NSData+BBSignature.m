//
//  NSData+BBSignature.m
//  Boredat
//
//  Created by Dmitry Letko on 5/16/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "NSData+BBSignature.h"
#import "BBSignature.h"


@implementation NSData (BBSignature)

- (NSData *)HMAC_SHA1_DataWithKey:(NSString *)key
{
	return HMAC_SHA1_Data(self.bytes, key.UTF8String);
}

@end
