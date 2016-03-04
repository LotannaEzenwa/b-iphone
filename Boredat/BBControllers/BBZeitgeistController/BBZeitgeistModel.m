//
//  BBZeitgeistModel.m
//  Boredat
//
//  Created by David Pickart on 7/21/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

#import "BBFacade.h"
#import "BBNews.h"
#import "BBPersonality.h"
#import "BBPost.h"
#import "BBUserImage.h"
#import "BBUserImageFetcher.h"
#import "BBZeitgeistModel.h"

@interface BBZeitgeistModel ()
{
    NSMutableArray *_newsworthyPosts;
    NSMutableArray *_bestPosts;
    NSMutableArray *_worstPosts;
    
    NSInteger _numUpdates;
    
    BBZeitgeistSection _currentSection;
}

- (void)countUpdatesWithBlock:(void (^)())block;


@end

@implementation BBZeitgeistModel

- (BBZeitgeistModel *)init
{
    self = [super init];
    if (self != nil)
    {
        self.facade = [BBFacade sharedInstance];
        _fetcher = [BBUserImageFetcher sharedInstance];
        
        [self clearData];
        
        _currentSection = kZeitgeistSectionNewsworthy;
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
        [self.facade topPersonalitiesWithBlock:^(NSArray *personalities, NSError *error) {
            if (error == nil) {
                for (BBPersonality *personality in personalities)
                {
                    [_topPersonalities addObject:personality];
                    BBUserImage *userImage = [_fetcher thumbnailImageWithImageName:personality.image];
                    [_topPersonalityImages addObject:userImage];
                }
                [self.delegate modelDidUpdateData:self];
                [self countUpdatesWithBlock:block];
            }
            else
            {
                [self.delegate modelDidRecieveError:self error:error];
            }
        }];
    };
    
    void(^newsBlock)() = ^void () {
        [self.facade topHeadlinesWithBlock:^(NSArray *posts, NSError *error) {
            if (error == nil)
            {
                // Convert each from news object to post object
                NSMutableArray *postArray = [NSMutableArray new];
                for (int i = 0; i < [posts count]; i++)
                {
                    [postArray addObject:[BBPost postWithBBNews:[posts objectAtIndex:i]]];
                }
                _newsworthyPosts = [NSMutableArray arrayWithArray:postArray];
                [self countUpdatesWithBlock:block];
            }
            else
            {
                [self.delegate modelDidRecieveError:self error:error];
            }
        }];
    };
    
    void(^bestBlock)() = ^void () {
        [self.facade bestWeekPostsWithblock:^(NSArray *posts, NSError *error) {
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
        [self.facade worstWeekPostsWithBlock:^(NSArray *posts, NSError *error) {
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
        newsBlock();
        bestBlock();
        worstBlock();
    }
    else
    {
        [self.facade executeInBackground:personalityBlock];
        [self.facade executeInBackground:newsBlock];
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
    _topPersonalities = [NSMutableArray new];
    _topPersonalityImages = [NSMutableArray new];
    _newsworthyPosts = [NSMutableArray new];
    _bestPosts = [NSMutableArray new];
    _worstPosts = [NSMutableArray new];
    
    _numUpdates = 0;
    self.fetching = NO;
}

- (BOOL)hasData
{
    return ([_topPersonalities count] > 0 && [_newsworthyPosts count] > 0 && [_bestPosts count] && [_worstPosts count] > 0);
}

- (id)objectAtIndex:(NSInteger)index
{
    switch (_currentSection)
    {
        case kZeitgeistSectionNewsworthy:
            return [_newsworthyPosts objectAtIndex:index];
        
        case kZeitgeistSectionBest:
            return [_bestPosts objectAtIndex:index];
            
        case kZeitgeistSectionWorst:
            return [_worstPosts objectAtIndex:index];
            
        default:
            return nil;
    }
}

- (void)switchToSection:(BBZeitgeistSection)section
{
    _currentSection = section;
}

- (NSInteger)numberOfObjects
{
    switch (_currentSection)
    {
        case kZeitgeistSectionNewsworthy:
            return [_newsworthyPosts count];
            
        case kZeitgeistSectionBest:
            return [_bestPosts count];
            
        case kZeitgeistSectionWorst:
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
        case kZeitgeistSectionNewsworthy:
            [_newsworthyPosts replaceObjectAtIndex:index withObject:post];
            break;
            
        case kZeitgeistSectionBest:
            [_bestPosts replaceObjectAtIndex:index withObject:post];
            break;
            
        case kZeitgeistSectionWorst:
            [_worstPosts replaceObjectAtIndex:index withObject:post];
            break;
            
        default:
            break;
    }
}

@end
