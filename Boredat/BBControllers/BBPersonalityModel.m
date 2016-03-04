//
//  BBPersonalityModel.m
//  Boredat
//
//  Created by David Pickart on 16/09/2015.
//  Copyright (c) 2015 Scand Ltd. All rights reserved.
//

#import "BBFacade.h"
#import "BBNews.h"
#import "BBPersonality.h"
#import "BBPersonalityModel.h"
#import "BBPost.h"
#import "BBUserImage.h"
#import "BBUserImageFetcher.h"

@interface BBPersonalityModel ()
{
    BBPersonality *_personality;
    
    NSMutableArray *_recentPosts;
    NSMutableArray *_bestPosts;
    NSMutableArray *_worstPosts;
    
    NSInteger _numUpdates;
    
    BBPersonalitySection _currentSection;
}

- (void)countUpdatesWithBlock:(void (^)())block;


@end

@implementation BBPersonalityModel

- (BBPersonalityModel *)initWithPersonality:(BBPersonality *)personality
{
    self = [super init];
    if (self != nil)
    {
        _personality = personality;
        _personality.networkName = @"";
        
        self.facade = [BBFacade sharedInstance];
        
        [self clearData];
        
        _currentSection = kPersonalitySectionRecent;
    }
    return self;
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
    
    void(^personalityBlock)() = ^void () {
        [self.facade personalityOfUserWithName:_personality.personalityName block:^(BBPersonality *personality, NSError *error) {
            if (error == nil)
            {
                _personality = personality;
                [self countUpdatesWithBlock:block];
            }
            else
            {
                // Show error message and return from view
                [self.delegate modelDidRecieveError:self error:error];
            }
        }];
    };
    
    void(^recentBlock)() = ^void () {
        [self.facade recentPostsForPersonalityWithUID:_personality.personalityId block:^(NSArray *posts, NSError *error) {
            if (error == nil)
            {
                _recentPosts = [NSMutableArray arrayWithArray:posts];
                [self countUpdatesWithBlock:block];
            }
            else
            {
                [self.delegate modelDidRecieveError:self error:error];
            }
        }];
    };
    
    void(^bestBlock)() = ^void () {
        [self.facade bestPostsForPersonalityWithUID:_personality.personalityId block:^(NSArray *posts, NSError *error) {
            if (error == nil)
            {
                _bestPosts = [NSMutableArray arrayWithArray:posts];
                [self countUpdatesWithBlock:block];
            }
            else
            {
                [self.delegate modelDidRecieveError:self error:error];
            }
        }];
    };
    
    void(^worstBlock)() = ^void () {
        [self.facade worstPostsForPersonalityWithUID:_personality.personalityId block:^(NSArray *posts, NSError *error) {
            if (error == nil)
            {
                _worstPosts = [NSMutableArray arrayWithArray:posts];
                [self countUpdatesWithBlock:block];
            }
            else
            {
                [self.delegate modelDidRecieveError:self error:error];
            }
        }];
    };
    
    if (forced)
    {
        personalityBlock();
        recentBlock();
        bestBlock();
        worstBlock();
    }
    else
    {
        [self.facade executeInBackground:personalityBlock];
        [self.facade executeInBackground:recentBlock];
        [self.facade executeInBackground:bestBlock];
        [self.facade executeInBackground:worstBlock];
    }
}

- (void)countUpdatesWithBlock:(void (^)())block
{
    [self.delegate modelDidUpdateData:self];
    
    // Calls block after everything has updated
    _numUpdates ++;
    if (_numUpdates > 3)
    {
        _numUpdates = 0;
        self.fetching = NO;
        if (block != nil)
        {
            block();
        }
    }
}

- (void)clearData
{
    _recentPosts = [NSMutableArray new];
    _bestPosts = [NSMutableArray new];
    _worstPosts = [NSMutableArray new];
    
    _numUpdates = 0;
    self.fetching = NO;
}

- (BOOL)hasData
{
    return ([_recentPosts count] > 0 && [_bestPosts count] && [_worstPosts count] > 0);
}

- (id)objectAtIndex:(NSInteger)index
{
    switch (_currentSection)
    {
        case kPersonalitySectionRecent:
            return [_recentPosts objectAtIndex:index];
            
        case kPersonalitySectionBest:
            return [_bestPosts objectAtIndex:index];
            
        case kPersonalitySectionWorst:
            return [_worstPosts objectAtIndex:index];
            
        default:
            return nil;
    }
}

- (void)switchToSection:(BBPersonalitySection)section
{
    _currentSection = section;
}

- (NSInteger)numberOfObjects
{
    switch (_currentSection)
    {
        case kPersonalitySectionRecent:
            return [_recentPosts count];
            
        case kPersonalitySectionBest:
            return [_bestPosts count];
            
        case kPersonalitySectionWorst:
            return [_worstPosts count];
            
        default:
            return 0;
    }
}

- (void)completeAction:(BBPostAction)action forObjectAtIndex:(NSInteger)index
{
    BBPost *post = [self objectAtIndex:index];
    [post updateForAction:action];
    [self replaceObjectAtIndex:index withObject:post];
    
    [self.facade completePostAction:action onPost:post completion:^(NSError *error) {
        if (error != nil)
        {
            [self.delegate modelDidRecieveError:self error:error];
        }
    }];
}

- (void)replaceObjectAtIndex:(NSInteger)index withObject:(BBPost *)post
{
    switch (_currentSection)
    {
        case kPersonalitySectionRecent:
            [_recentPosts replaceObjectAtIndex:index withObject:post];
            break;
            
        case kPersonalitySectionBest:
            [_bestPosts replaceObjectAtIndex:index withObject:post];
            break;
            
        case kPersonalitySectionWorst:
            [_worstPosts replaceObjectAtIndex:index withObject:post];
            break;
            
        default:
            break;
    }
}

@end
