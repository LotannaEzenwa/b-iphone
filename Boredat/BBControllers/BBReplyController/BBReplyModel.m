//
//  BBReplyModel.m
//  Boredat
//
//  Created by David Pickart on 14/11/2015.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import "BBFacade.h"
#import "BBReplyModel.h"

@implementation BBReplyModel
{
    NSMutableArray *_replies;
}

static const NSComparator comparator = ^NSComparisonResult(BBPost *post1, BBPost *post2) {
    return [post1.created compare:post2.created];
};

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _freshReplies = [NSMutableArray new];
        self.fetching = NO;
        self.noReplies = NO;
        self.didReply = NO;
        self.facade = [BBFacade sharedInstance];
        _postAsAnonymous = self.facade.postAsAnonymous;
        [self clearData];
    }
    return self;
}

- (void)setPost:(BBPost *)post
{
    _post = post;
    
    if (post.totalReplies == 0 && post.text != nil)
    {
        self.noReplies = YES;
    }
}

- (NSInteger)numberOfObjects
{
    return [_replies count];
}

- (id)objectAtIndex:(NSInteger)index
{
    return [_replies objectAtIndex:index];
}

- (void)replaceObjectAtIndex:(NSInteger)index withObject:(id)object
{
    [_replies replaceObjectAtIndex:index withObject:object];
}

- (void)completeAction:(BBPostAction)action forObjectAtIndex:(NSInteger)index
{
    BBPost *post = [self objectAtIndex:index];
    [post updateForAction:action];
    [self replaceObjectAtIndex:index withObject:post];
    
    // Take action
    [self.facade completePostAction:action onPost:post completion:^(NSError *error) {
        if (error != nil)
        {
            [self.delegate modelDidRecieveError:self error:error];
        }
    }];
}

- (void)updateDataForced:(BOOL)forced
{
    [self updateDataWithCompletion:nil forced:forced];
}

- (void)updateDataWithCompletion:(void (^)())block forced:(BOOL)forced
{
    [self updatePostWithCompletion:block];
}

- (void)updatePost
{
    [self updatePostWithCompletion:nil];
}
     
- (void)updatePostWithCompletion:(void (^)())block
{
    // Fetch post if necessary, then update replies
    if (_post.text == nil) {
        [self.facade postWithUID:_post.UID block:^(BBPostResponse *response, NSError *error) {
            if (error != nil)
            {
                [self.delegate modelDidRecieveError:self error:error];
            }
            else
            {
                _post = response.post;
                _noReplies = _post.totalReplies == 0;
                [self updateRepliesWithCompletion:block];
            }
        }];
    }
    else
    {
        [self updateReplies];
    }
}

- (void)updateReplies
{
    [self updateRepliesWithCompletion:nil];
}

- (void)updateRepliesWithCompletion:(void (^)())block
{
    [self.facade replies:_post.UID block:^(NSArray *posts, NSError *error) {
        if (error != nil)
        {
            _noReplies = YES;
            [self.delegate modelDidUpdateData:self];
        }
        else
        {
            NSArray *replies = [posts sortedArrayWithOptions:NSSortConcurrent usingComparator:comparator];
            
            NSInteger numTotalReplies = [replies count];
            NSInteger numOldReplies = [_replies count];
            NSInteger numNewReplies = numTotalReplies - numOldReplies;

            _freshReplies = [NSMutableArray new];
            
            // Add fresh replies to array
            for (int i = 0; i < numNewReplies; i++)
            {
                [_freshReplies addObject:[replies objectAtIndex:[replies count] - 1 - i]];
            }
            
            _post.totalReplies = numTotalReplies;
            _replies = [NSMutableArray arrayWithArray:replies];
            
            [self.delegate modelDidUpdateData:self];
            
            if (block != nil)
            {
                block();
            }
        }
    }];
}

- (void)clearData
{
    _replies = [NSMutableArray new];
    _post = nil;
}

# pragma mark Reply Model unique methods

- (void)completeActionForTopCell:(BBPostAction)action
{
    [_post updateForAction:action];
    
    // Take action
    [self.facade completePostAction:action onPost:_post completion:^(NSError *error) {
        if (error != nil)
        {
            [self.delegate modelDidRecieveError:self error:error];
        }
    }];
}

- (void)toggleAnonymous
{
    [self.facade toggleAnonymous];
    _postAsAnonymous = [self.facade postAsAnonymous];
}

- (void)replyWithText:(NSString *)text callback:(void (^)())block
{
    [self.facade replyText:text UID:_post.UID anonymously:_postAsAnonymous block:^(NSError *error) {
        if (error != nil)
        {
            [self.delegate modelDidRecieveError:self error:error];
        }
        else
        {
            self.didReply = YES;
            
            // Note: we need to fetch replies instead of updating locally because the server
            // determines the reply's UID
            [self updateDataWithCompletion:block forced:YES];
        }
        
        // Callback regardless of error
        block();
    }];
}

@end
