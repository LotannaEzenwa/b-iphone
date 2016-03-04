//
//  BBJSONSerialization.m
//  Boredat
//
//  Created by Dmitry Letko on 5/15/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBJSONSerialization.h"
#import "SBJsonParser.h"


@implementation BBJSONSerialization


static Class NSJSONSerializationClass = nil;

+ (void)initialize
{
	static dispatch_once_t initialized;
	
	dispatch_once(&initialized, ^{
		NSJSONSerializationClass = NSClassFromString(@"NSJSONSerialization");
	});
}


+ (id)JSONObjectWithData:(NSData *)data error:(NSError **)error
{
    if (data == nil)
    {
        return nil;
    }
	else if (NSJSONSerializationClass != nil)
	{
		return [NSJSONSerializationClass JSONObjectWithData:data options:0 error:error];
	}
	else
	{
		SBJsonParser *parser = [SBJsonParser new];
						
		return [parser objectWithData:data];
	}
}

@end
