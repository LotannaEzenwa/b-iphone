//
//  BBSignature.m
//  Boredat
//
//  Created by Dmitry Letko on 5/11/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBSignature.h"
#import "LogUtils.h"

#import <CommonCrypto/CommonHMAC.h>


NSData *HMAC_SHA1_Data (const char *bytes, const char *key)
{	
	if (bytes != nil)
	{		
		if (&CCHmac != nil)
		{
			unsigned char *sha1Buffer = malloc(CC_SHA1_DIGEST_LENGTH);
			
			if (sha1Buffer != nil)
			{
				CCHmac(kCCHmacAlgSHA1, key, strlen(key), bytes, strlen(bytes), sha1Buffer);
				
				return [NSData dataWithBytesNoCopy:sha1Buffer length:CC_SHA1_DIGEST_LENGTH freeWhenDone:YES];
			}	
			else
			{
				RLogFunction();
				RLog(@"sha1Buffer != nil");
			}
		}
		else
		{
			RLogFunction();
			RLog(@"CCHmac != nil");
			RLog(@"Include external library");
		}
	}
	
	return nil;
}
