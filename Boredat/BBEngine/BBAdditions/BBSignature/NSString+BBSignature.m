//
//  NSString+BBSignature.m
//  Boredat
//
//  Created by Dmitry Letko on 5/11/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "NSString+BBSignature.h"
#import "BBSignature.h"


@implementation NSString (BBSignature)

- (NSData *)HMAC_SHA1_DataWithKey:(NSString *)key
{	
	return HMAC_SHA1_Data(self.UTF8String, key.UTF8String);
}

@end
