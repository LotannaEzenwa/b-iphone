//
//  BBPrivatePostResponse.m
//  Boredat
//
//  Created by Dmitry Letko on 5/8/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBPrivatePostResponse.h"
#import "BBPrivatePost.h"

#import "BBResponseDataProtocol.h"

#import "MgmtUtils.h"


@implementation BBPrivatePostResponse

- (id)initWithData:(id<BBResponseDataProtocol>)data
{
	self = [super initWithData:data];
	
	if (self != nil)
	{
		_post = [[BBPrivatePost alloc] initWithJSONObject:data.JSONObject];
    }
	
	return self;
}

@end
