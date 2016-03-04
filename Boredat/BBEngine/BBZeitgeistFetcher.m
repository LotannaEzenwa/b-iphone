//
//  BBZeitgeistFetcher.m
//  Boredat
//
//  Created by Anton Kolosov on 2/7/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBZeitgeistFetcher.h"

@implementation BBZeitgeistFetcher

- (id)init {
    
    self = [super init];
    
    if (self != nil)
    {
        _facade = [BBFacade sharedInstance];
        _fetcher = [BBUserImageFetcher sharedInstance];
    }
    
    return self;
}

- (void)updateInfoWithType:(ZeitgeistInfoType)type withCompletion:(completion_block)completionBlock
{
    switch (type) {
        case ZeitgeistInfoTypeTopHeadlines:
            [self updateTopHeadlinesWithCompletion:completionBlock];
            break;
            
        case ZeitgeistInfoTypeBestPosts:
            [self updateBestPostsWithCompletion:completionBlock];
            break;
            
        case ZeitgeistInfoTypeWorstPosts:
            [self updateWorstPostsWithCompletion:completionBlock];
            break;
            
        case ZeitgeistInfoTypeTopPersonalities:
            [self updateTopPersonalitiesWithCompletion:completionBlock];
            break;
            
        case ZeitgeistInfoTypeNetworkStats:
            [self updateNetworkStatsWithCompletion:completionBlock];
            break;
            
        case ZeitgeistInfoTypeUsersInfo:
            [self updateUsersInfoWithCompletion:completionBlock];
            break;
            
        case ZeitgeistInfoTypeUsersOnlinePlot:
            [self updateUsersOnlinePlotWithCompletion:completionBlock];
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark Update info in cache

- (void)updateTopPersonalitiesWithCompletion:(completion_block)completionBlock
{
    [_facade topPersonalitiesWithBlock:^(NSArray *personalities, NSError *error)
     {
         if (error == nil)
         {
             completionBlock(YES, personalities);
         }
         else
         {
             completionBlock(NO, nil);
         }
     }];
}

- (void)updateTopHeadlinesWithCompletion:(completion_block)completionBlock
{
    [_facade topHeadlinesWithBlock:^(NSArray *headlines, NSError *error){
        [self handleResponse:headlines withError:error withType:ZeitgeistInfoTypeTopHeadlines withCompletion:completionBlock];
    }];
}

- (void)updateBestPostsWithCompletion:(completion_block)completionBlock
{
    [_facade bestWeekPostsWithblock:^(NSArray *posts, NSError *error){
        [self handleResponse:posts withError:error withType:ZeitgeistInfoTypeBestPosts withCompletion:completionBlock];
    }];
}

- (void)updateWorstPostsWithCompletion:(completion_block)completionBlock
{
    [_facade worstWeekPostsWithBlock:^(NSArray *posts, NSError *error){
        [self handleResponse:posts withError:error withType:ZeitgeistInfoTypeWorstPosts withCompletion:completionBlock];
    }];
}

- (void)updateNetworkStatsWithCompletion:(completion_block)completionBlock
{
    [_facade networkStatisticsWithBlock:^(BBNetworkStatisticsResponse *response, NSError *error){
        [self handleResponse:response withError:error withType:ZeitgeistInfoTypeNetworkStats withCompletion:completionBlock];
    }];
}

- (void)updateUsersInfoWithCompletion:(completion_block)completionBlock
{
    [_facade usersOnlineWithBlock:^(BBUsersOnlineResponse *response, NSError *error){
        [self handleResponse:response withError:error withType:ZeitgeistInfoTypeUsersInfo withCompletion:completionBlock];
    }];
}

- (void)updateUsersOnlinePlotWithCompletion:(completion_block)completionBlock
{
    [_facade usersOnlineInfoPlotWithBlock:^(BBUsersOnlineInfoPlotResponse *response, NSError *error){
        [self handleResponse:response withError:error withType:ZeitgeistInfoTypeUsersOnlinePlot withCompletion:completionBlock];
    }];
}

#pragma mark -
#pragma mark Handle response

- (void)handleResponse:(id)response withError:(NSError *)error withType:(ZeitgeistInfoType)type withCompletion:(completion_block)completion
{
    if(error == nil)
    {
        completion(YES, response);
    }
    else
    {
        completion(NO, nil);
    }
}

@end
