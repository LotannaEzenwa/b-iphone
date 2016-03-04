//
//  BBPersonalityPostsResponse.m
//  Boredat
//
//  Created by David Pickart on 5/20/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

#import "BBPersonalityPostsResponse.h"
#import "BBResponseDataProtocol.h"
#import "NSObject+NULL.h"
#import "MgmtUtils.h"

#import "BBPost.h"

static NSString * const kPostKey = @"posts";

@implementation BBPersonalityPostsResponse

- (id)initWithData:(id<BBResponseDataProtocol>)data
{
    self = [super initWithData:data];
    
    if (self != nil)
    {
        NSDictionary *JSONDictionary = NSDictionaryObject(data.JSONObject);
        NSArray *array = [[NSArray alloc] initWithArray:[JSONDictionary objectForKey:kPostKey]];
        
        NSMutableArray *posts = [NSMutableArray arrayWithCapacity:array.count];
        
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
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
