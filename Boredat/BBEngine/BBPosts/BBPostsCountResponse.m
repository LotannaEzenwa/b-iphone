//
//  BBPostsCountResponse.m
//  Boredat
//
//  Created by Lesha on 7/17/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBPostsCountResponse.h"
#import "BBResponseDataProtocol.h"

#import "MgmtUtils.h"

#import "NSObject+NULL.h"


NSString *const kPagesCount = @"pagesCount";


@implementation BBPostsCountResponse

- (id)initWithData:(id<BBResponseDataProtocol>)data
{
	self = [super initWithData:data];
	
	if (self != nil)
	{
        NSDictionary *dict = NSDictionaryObject(data.JSONObject);
        _pageCount = [[dict objectForKey:kPagesCount] integerValue];
	}
	
	return self;
}


@end
