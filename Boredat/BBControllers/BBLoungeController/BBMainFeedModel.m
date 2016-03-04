//
//  BBMainFeedModel.m
//  Boredat
//
//  Created by David Pickart on 8/3/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

#import "BBFacade.h"
#import "BBOperation.h"
#import "BBMainFeedModel.h"

static const NSInteger kPostCacheSize = 100;

@interface BBMainFeedModel ()
{
    NSMutableArray *_postOperations;
    NSMutableArray *_postCache;
    NSInteger _pageIndex;
}

@end

@implementation BBMainFeedModel

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        [self clearData];
        self.facade = [BBFacade sharedInstance];
    }
    return self;
}

- (NSInteger)numberOfObjects
{
    id posts = [_postCache objectAtIndex:_pageIndex];
    if (posts == [NSNull null])
    {
        return 0;
    }
    else
    {
        return [(NSMutableArray *)posts count];
    }
}

- (void)setPageNumber:(NSInteger)pageNumber
{
    _pageNumber = pageNumber;
    _pageIndex = pageNumber-1;
    if (self.hasData == NO)
    {
        [self updateDataForced:YES];
    }
}

- (NSMutableDictionary *)getPostDictionary
{
    NSMutableDictionary *postDict = [NSMutableDictionary new];
    id posts = [_postCache objectAtIndex:_pageIndex];
    if (posts != [NSNull null])
    {
        for (BBPost *post in (NSMutableArray *)posts)
        {
            [postDict setObject:post forKey:post.UID];
        }
    }
    return postDict;
}

- (NSMutableArray *)getPosts
{
    id posts = [_postCache objectAtIndex:_pageIndex];
    if (posts == [NSNull null])
    {
        return nil;
    }
    else
    {
        return (NSMutableArray *)posts;
    }
}


- (id)objectAtIndex:(NSInteger)index
{
    id posts = [_postCache objectAtIndex:_pageIndex];
    if (posts == [NSNull null])
    {
        return nil;
    }
    else
    {
        return [(NSMutableArray *)posts objectAtIndex:index];
    }
}

- (void)replaceObjectAtIndex:(NSInteger)index withObject:(id)object
{
    id posts = [_postCache objectAtIndex:_pageIndex];
    if (posts != [NSNull null])
    {
        [(NSMutableArray *)posts replaceObjectAtIndex:index withObject:object];
    }
}

- (void)setPosts:(NSArray *)posts
{
    [_postCache replaceObjectAtIndex:_pageIndex withObject:[NSMutableArray arrayWithArray:posts]];
    [self.delegate modelDidUpdateData:self];
}

- (void)completeAction:(BBPostAction)action forObjectAtIndex:(NSInteger)index
{
    id posts = [_postCache objectAtIndex:_pageIndex];
    if (posts != [NSNull null])
    {
        BBPost *post = [(NSMutableArray *)posts objectAtIndex:index];
        [post updateForAction:action];
        
        [self replaceObjectAtIndex:index withObject:post];
        [_postCache replaceObjectAtIndex:_pageIndex withObject:posts];
        
        // Take action
        [self.facade completePostAction:action onPost:post completion:^(NSError *error) {
            if (error != nil)
            {
                [self.delegate modelDidRecieveError:self error:error];
            }
        }];

    }
}

- (void)updateDataForced:(BOOL)forced
{
    [self updateDataWithCompletion:nil forced:forced];
}

- (void)updateDataWithCompletion:(void (^)())block forced:(BOOL)forced
{
    [self fetchPostsforPage:_pageNumber];
    
    [self.facade executeInBackground:^(void) {
        [self fetchPostsforPage:_pageNumber+1];
        [self fetchPostsforPage:_pageNumber-1];
    }];
}

- (void)clearData
{
    _oldPosts = [NSMutableArray new];
    _postCache = [NSMutableArray new];
    _postOperations = [NSMutableArray new];
    for (int i = 0; i < kPostCacheSize; i++)
    {
        [_postCache addObject:[NSNull null]];
        [_postOperations addObject:[NSNull null]];
    }
    
    _pageNumber = 1;
    _pageIndex = 0;
    self.fetching = NO;
}

- (NSMutableArray *)oldPosts
{
    if ([_oldPosts count] > 0)
    {
        return _oldPosts;
    }
    else
    {
        return [self getPosts];
    }
}

#pragma mark -
#pragma mark private

-(void)fetchPostsforPage:(NSInteger)pageNumber
{
    BOOL alreadyExecuting = NO;
    BOOL refreshing = (pageNumber == _pageNumber);
    id op = [_postOperations objectAtIndex:pageNumber];
    if (op != [NSNull null])
    {
        BBOperation *operation = (BBOperation *)op;
        if (operation.isFinished == NO)
        {
            alreadyExecuting = YES;
        }
    }
    if (pageNumber == 0 || alreadyExecuting)
    {
        return;
    }
    [_postOperations replaceObjectAtIndex:pageNumber withObject:[self.facade postsFromPage:pageNumber block:^(NSArray *posts, NSNumber *page, NSError *error) {
        if (error != nil)
        {
//            [self.delegate modelDidRecieveError:self error:error];
        }
        else
        {
            if (refreshing) {
                _oldPosts = [_postCache objectAtIndex:_pageIndex];
            }
            [_postCache replaceObjectAtIndex:pageNumber-1 withObject:[NSMutableArray arrayWithArray:posts]];
        }
        if (refreshing)
        {
            [self.delegate modelDidUpdateData:self];
        }
    }]];
}

-(void)clearPostCache
{
    for (int i = 0; i < 5; i++)
    {
        [_postCache replaceObjectAtIndex:i withObject:[NSNull null]];
    }
}
@end
