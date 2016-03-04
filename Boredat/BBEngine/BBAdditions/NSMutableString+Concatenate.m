//
//  NSMutableString+Concatenate.m
//  Boredat
//
//  Created by Dmitry Letko on 5/17/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "NSMutableString+Concatenate.h"


@implementation NSMutableString (Concatenate)

- (void)concatenateString:(NSString *)string
{
	if (string.length > 0)
	{
		[self appendString:string];
	}
}

@end
