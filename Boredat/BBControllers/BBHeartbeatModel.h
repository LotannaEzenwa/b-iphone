//
//  BBHeartbeatModel.h
//  Boredat
//
//  Created by David Pickart on 8/3/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

#import "BBModel.h"
#import <Foundation/Foundation.h>

@interface BBHeartbeatModel : BBModel

@property (copy, nonatomic, readwrite) NSString *totalPosts;
@property (copy, nonatomic, readwrite) NSString *todayPosts;
@property (copy, nonatomic, readwrite) NSString *yesterdayPosts;

@property (copy, nonatomic, readwrite) NSString *usersToday;
@property (copy, nonatomic, readwrite) NSString *usersOnline;
@property (copy, nonatomic, readwrite) NSString *usersUnique;

@property (strong, nonatomic, readwrite) NSMutableArray *usersPointsPlot;
@property (strong, nonatomic, readwrite) NSMutableArray *timePointsPlot;

@property (nonatomic, readwrite) BOOL statsAvailable;
@property (nonatomic, readwrite) BOOL statsConfirmedUnavailable;

@end
