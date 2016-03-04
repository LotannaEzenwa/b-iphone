//
//  BBResponse.m
//  Boredat
//
//  Created by Dmitry Letko on 5/11/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBResponse.h"
#import "BBResponseDataProtocol.h"

#import "MgmtUtils.h"


@implementation BBResponse

@synthesize URLRedirection = _URLRedirection;
@synthesize URLResponse = _URLResponse;

/*
+ (BOOL)redirection
{
	return YES;
}
*/ 

+ (BOOL)JSONObject
{
	return YES;
}


+ (id)responseWithData:(id<BBResponseDataProtocol>)data
{
	return [(BBResponse *)[self alloc] initWithData:data];
}

- (id)initWithData:(id<BBResponseDataProtocol>)data
{
	self = [super init];
	
	if (self != nil)
	{
		_URLRedirection = [data.URLRedirection copy];
        _URLResponse = [data.URLResponse copy];
	}
	
	return self;
}

@end
