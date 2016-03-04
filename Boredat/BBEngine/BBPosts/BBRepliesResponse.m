//
//  BBRepliesResponse.m
//  Boredat
//
//  Created by Dmitry Letko on 1/24/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBRepliesResponse.h"
#import "BBPost.h"
#import "BBResponseDataProtocol.h"

#import "MgmtUtils.h"

#import "NSObject+NULL.h"


@interface BBRepliesResponse ()
@property (copy, nonatomic, readwrite) NSArray *posts;

@end


@implementation BBRepliesResponse

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
		NSArray *JSONArray = NSArrayObject(data.JSONObject);
		NSMutableArray *posts = [[NSMutableArray alloc] initWithCapacity:JSONArray.count];

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
