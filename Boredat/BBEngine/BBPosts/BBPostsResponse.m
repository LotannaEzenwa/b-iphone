//
//  BBPostsResponse.m
//  Boredat
//
//  Created by Dmitry Letko on 5/14/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBPostsResponse.h"
#import "BBPost.h"
#import "BBResponseDataProtocol.h"

#import "MgmtUtils.h"

#import "NSObject+NULL.h"


@implementation BBPostsResponse

/*
#pragma mark -
#pragma mark BBResponse methods
#pragma mark -

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
		NSArray *JSONArray = NSArrayObject(data.JSONObject);
		NSMutableArray *posts = [NSMutableArray arrayWithCapacity:JSONArray.count];
		
		[JSONArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			BBPost *post = [[BBPost alloc] initWithJSONObject:obj];
			
			if (post != nil)
			{
				[posts addObject:post];
			}
		}];
		
		_posts = [posts copy];
	}
	
	return self;
}

@end
