//
//  BBPost.h
//  Boredat
//
//  Created by Dmitry Letko on 5/16/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBGlobalEnums.h"
#import "BBNews.h"

extern NSString *const kPostUID;
extern NSString *const kPostParentUID;
extern NSString *const kPostText;
extern NSString *const kPostCreated;
extern NSString *const kPostTotalAgrees;
extern NSString *const kPostTotalDisagrees;
extern NSString *const kPostTotalNewsworthies;
extern NSString *const kPostTotalReplies;
extern NSString *const kPostType;
extern NSString *const kNetworkName;
extern NSString *const kNetworkShortname;
extern NSString *const kLocationName;
extern NSString *const kLocationShortname;
extern NSString *const kScreennameUID;
extern NSString *const kScreennameName;
extern NSString *const kScreennameImage;
extern NSString *const kLocalNetworkName;
extern NSString *const kHasVotedAgree;
extern NSString *const kHasVotedDisagree;
extern NSString *const kHasVotedNewsworthy;


@interface BBPost : NSObject
@property (copy, nonatomic, readwrite) NSString *UID;
@property (copy, nonatomic, readwrite) NSString *parentUID;
@property (copy, nonatomic, readwrite) NSString *text;
@property (copy, nonatomic, readwrite) NSMutableAttributedString *attributedText;
@property (copy, nonatomic, readwrite) NSDate *created;
@property (nonatomic, readwrite) NSInteger totalAgrees;
@property (nonatomic, readwrite) NSInteger totalDisagrees;
@property (nonatomic, readwrite) NSInteger totalNewsworthies;
@property (nonatomic, readwrite) NSInteger totalReplies;
@property (copy, nonatomic, readwrite) NSString *type;
@property (copy, nonatomic, readwrite) NSString *networkName;
@property (copy, nonatomic, readwrite) NSString *networkShortname;
@property (copy, nonatomic, readwrite) NSString *locationName;
@property (copy, nonatomic, readwrite) NSString *locationShortname;
@property (copy, nonatomic, readwrite) NSString *screennameUID;
@property (copy, nonatomic, readwrite) NSString *screennameName;
@property (copy, nonatomic, readwrite) NSString *screennameImage;
@property (copy, nonatomic, readwrite) NSString *localNetworkName;
@property (nonatomic, readwrite) BOOL hasVotedAgree;
@property (nonatomic, readwrite) BOOL hasVotedDisagree;
@property (nonatomic, readwrite) BOOL hasVotedNewsworthy;

+ (id)postWithJSONObject:(id)JSONObject;
+ (id)postWithBBNews:(BBNews *)news;
- (id)initWithJSONObject:(id)JSONObject;

- (void)updateForAction:(BBPostAction)action;
- (NSArray *)actionsForUpdatedPost:(BBPost *)post;

@end
