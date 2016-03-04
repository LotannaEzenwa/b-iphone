//
//  BBNetworkStatisticsResponse.m
//  Boredat
//
//  Created by Anton Kolosov on 10/8/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBNetworkStatisticsResponse.h"
#import "BBResponseDataProtocol.h"
#import "NSObject+NULL.h"
#import "MgmtUtils.h"

static NSString * const kTotalPosts = @"TotalPosts";
static NSString * const kTodayPosts = @"Today";
static NSString * const kYesterdayPosts = @"Yesterday";

@implementation BBNetworkStatisticsResponse


- (id)initWithData:(id<BBResponseDataProtocol>)data
{
    self = [super initWithData:data];
    
    if (self != nil)
    {
//        NSDictionary *JSONDictionary = NSDictionaryObject(data.JSONObject);
        NSDictionary *JSONDictionary = NSDictionaryObject(data.JSONObject);
        _totalPosts = [[JSONDictionary objectForKey:kTotalPosts] copy];
        _todayPosts = [[JSONDictionary objectForKey:kTodayPosts] copy];
        _yesterdayPosts = [[JSONDictionary objectForKey:kYesterdayPosts] copy];
    }
    
    return self;
}

@end
