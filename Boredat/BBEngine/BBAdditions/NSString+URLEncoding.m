//
//  NSString+URLEncoding.m
//  Boredat
//
//  Created by Dmitry Letko on 5/11/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "NSString+URLEncoding.h"
#import "CFUtils.h"


@implementation NSString (URLEncoding)

static NSString *const kEscapedCharacters = @"%|~!*'();\":@&=+$,/?%#[]^<>{} \\";

- (NSString *)URLEncodedString 
{
    NSString *string = self;
    NSString *result = [string stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:kEscapedCharacters] invertedSet]];
    
	return result;
}

- (NSString *)URLDecodedString
{
    NSString *string = self;
    NSString *result = [string stringByRemovingPercentEncoding];
	return result;
}

@end
