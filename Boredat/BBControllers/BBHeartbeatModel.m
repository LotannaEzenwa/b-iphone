//
//  BBHeartbeatModel.m
//  Boredat
//
//  Created by David Pickart on 8/3/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

#import "BBFacade.h"
#import "BBHeartbeatModel.h"

@interface BBHeartbeatModel ()
{
    NSInteger _numUpdates;
    NSDateFormatter *_dateFormatter;
}

- (void)countUpdatesWithBlock:(void (^)())block;

@end

@implementation BBHeartbeatModel

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.facade = [BBFacade sharedInstance];
        
        [self clearData];
        
        _dateFormatter = [NSDateFormatter new];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    return self;
}

- (void)clearData
{
    _numUpdates = 0;
    self.fetching = NO;
    
    _statsAvailable = NO;
    _statsConfirmedUnavailable = NO;
    
    _totalPosts = @"-";
    _todayPosts = @"-";
    _yesterdayPosts = @"-";
    
    _usersOnline = @"-";
    _usersToday = @"-";
    _usersUnique = @"-";
    
    _usersPointsPlot = [NSMutableArray new];
    _timePointsPlot = [NSMutableArray new];
}

- (BOOL)hasData
{
    return ([_usersPointsPlot count] > 0 && [_timePointsPlot count] > 0);
}

- (void)updateDataForced:(BOOL)forced
{
    [self updateDataWithCompletion:nil forced:forced];
}

- (void)updateDataWithCompletion:(void (^)())block forced:(BOOL)forced
{
    if (self.fetching && !forced)
    {
        if (block != nil)
        {
            block();
        }
        return;
    }
    
    self.fetching = YES;
    
    void(^statisticsBlock)() = ^void () {
        [self.facade networkStatisticsWithBlock:^(BBNetworkStatisticsResponse *response, NSError *error){
            if (!error)
            {
                _statsAvailable = YES;
                _totalPosts = response.totalPosts;
                _todayPosts = response.todayPosts;
                _yesterdayPosts = response.yesterdayPosts;
            }
            else
            {
                _statsConfirmedUnavailable = YES;
            }
            [self countUpdatesWithBlock:block];
        }];
    };
    
    void(^usersBlock)() = ^void () {
        [self.facade usersOnlineWithBlock:^(BBUsersOnlineResponse *response, NSError *error){
            if (!error)
            {
                _usersOnline = response.usersOnline;
                _usersToday = response.usersToday;
                _usersUnique = response.usersUnique;
            }
            
            [self countUpdatesWithBlock:block];
        }];
    };
    
    void(^plotBlock)() = ^void () {
        [self.facade usersOnlineInfoPlotWithBlock:^(BBUsersOnlineInfoPlotResponse *response, NSError *error){
            if (!error)
            {
                [self sortUsersAndTimesForPlot:response];
            }
            
            [self countUpdatesWithBlock:block];
        }];
    };
    
    if (forced)
    {
        statisticsBlock();
        usersBlock();
        plotBlock();
    }
    else
    {
        [self.facade executeInBackground:statisticsBlock];
        [self.facade executeInBackground:usersBlock];
        [self.facade executeInBackground:plotBlock];
    }
}

- (void)countUpdatesWithBlock:(void (^)())block
{
    [self.delegate modelDidUpdateData:self];

    // Calls block after everything has updated
    _numUpdates ++;
    if (_numUpdates > 2)
    {
        _numUpdates = 0;
        self.fetching = NO;
        if (block != nil)
        {
            block();
        }
    }
}

#pragma mark -
#pragma mark private

- (void)sortUsersAndTimesForPlot:(BBUsersOnlineInfoPlotResponse *)response
{
    NSMutableArray *times = [NSMutableArray arrayWithArray:[response.pointsDictionary allKeys]];
    
    _timePointsPlot = [NSMutableArray arrayWithArray:[times sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2)
                       {
                           NSDate *date1 = [_dateFormatter dateFromString:obj1];
                           NSDate *date2 = [_dateFormatter dateFromString:obj2];
                           return [date1 compare:date2];
                       }]];
    
    _usersPointsPlot = [NSMutableArray new];
    [_timePointsPlot enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop){
        object = (NSString *)object;
        [_usersPointsPlot addObject:[response.pointsDictionary valueForKey:object]];
    }];
}

@end
