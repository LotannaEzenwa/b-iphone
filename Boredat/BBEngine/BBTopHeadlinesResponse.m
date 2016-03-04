//
//  BBTopHeadlinesResponse.m
//  Boredat
//
//  Created by Anton Kolosov on 1/14/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBTopHeadlinesResponse.h"
#import "BBResponseDataProtocol.h"
#import "NSObject+NULL.h"
#import "MgmtUtils.h"
#import "BBNews.h"

static NSString * const kNewsKey = @"news";

@interface BBTopHeadlinesResponse ()

@end

@implementation BBTopHeadlinesResponse

- (id)initWithData:(id<BBResponseDataProtocol>)data
{
    self = [super initWithData:data];
    
    if (self != nil)
    {
        NSDictionary *JSONDictionary = NSDictionaryObject(data.JSONObject);
        NSArray *array = [[NSArray alloc] initWithArray:[JSONDictionary objectForKey:kNewsKey]];
        
        NSMutableArray *posts = [NSMutableArray arrayWithCapacity:array.count];
		
		[array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			BBNews *news = [[BBNews alloc] initWithJSONObject:obj];
			
			if (news != nil)
			{
				[posts addObject:news];
			}
		}];
		
		_posts = [posts copy];
        
    }
    
    return self;
}


@end
