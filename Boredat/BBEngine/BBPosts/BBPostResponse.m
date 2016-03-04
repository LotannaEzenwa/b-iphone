//
//  BBPostResponse.m
//  Boredat
//
//  Created by Dmitry Letko on 1/25/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBPostResponse.h"
#import "BBPost.h"

#import "BBResponseDataProtocol.h"

#import "MgmtUtils.h"


@implementation BBPostResponse

/*
#pragma mark -
#pragma mark BBResponse methods

+ (BOOL)redirection
{
	return NO;
}


#pragma mark -
*/ 

- (id)initWithData:(id<BBResponseDataProtocol>)data
{
	self = [super initWithData:data];
	
	if (self != nil)
	{        
		_post = [[BBPost alloc] initWithJSONObject:data.JSONObject];        
    }
	
	return self;
}


@end
