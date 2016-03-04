//
//  BBReplyModel.h
//  Boredat
//
//  Created by David Pickart on 14/11/2015.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import "BBModel.h"
#import "BBPost.h"

@interface BBReplyModel : BBModel

@property (nonatomic) BBPost *post;
@property BOOL noReplies;
@property BOOL postAsAnonymous;
@property BOOL didReply;
@property (strong, nonatomic, readwrite) NSMutableArray *freshReplies;

- (void)completeActionForTopCell:(BBPostAction)action;
- (void)toggleAnonymous;
- (void)replyWithText:(NSString *)text callback:(void (^)())block;
- (void)updateRepliesWithCompletion:(void (^)())block;
- (void)updateReplies;

@end
