//
//  NSData+HEXString.m
//  Boredat
//
//  Created by Dmitry Letko on 5/11/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "NSData+HEXString.h"


@implementation NSData (HEXString)


static NSString *const cStrBraces = @"<>";
static NSString *const cStrSpace = @" ";
static NSString *const cStrEmpty = @"";


- (NSString *)HEXString
{	
	NSString *description = self.description;	
	NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:cStrBraces];
	NSString *trimmed = [description stringByTrimmingCharactersInSet:characterSet];	
	NSString *unspaced = [trimmed stringByReplacingOccurrencesOfString:cStrSpace withString:cStrEmpty];
	
	return unspaced;
}

@end
