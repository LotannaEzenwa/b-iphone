//
//  BBNetworkStatisticsResponse.h
//  Boredat
//
//  Created by Anton Kolosov on 10/8/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBResponse.h"

@interface BBNetworkStatisticsResponse : BBResponse

@property (copy, nonatomic, readwrite) NSString *totalPosts;
@property (copy, nonatomic, readwrite) NSString *todayPosts;
@property (copy, nonatomic, readwrite) NSString *yesterdayPosts;

@end
