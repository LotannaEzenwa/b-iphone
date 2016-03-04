//
//  BBNews.h
//  Boredat
//
//  Created by Anton Kolosov on 1/15/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kNewsAccountID;
extern NSString * const kNewsActive;
extern NSString * const kNewsAgreeCount;
extern NSString * const kNewsDisagreeCount;
extern NSString * const kNewsFavouriteCount;
extern NSString * const kNewsIPHash;
extern NSString * const kNewsNetworkID;
extern NSString * const kNewsNetworkName;
extern NSString * const kNewsNetworkShortName;
extern NSString * const kNewsID;
extern NSString * const kNewsNewsworthyCount;
extern NSString * const kNewsParentID;
extern NSString * const kNewsReplyCount;
extern NSString * const kNewsScreenNameID;
extern NSString * const kNewsScreenNameImage;
extern NSString * const kNewsScreenNameValue;
extern NSString * const kNewsText;
extern NSString * const KNewsDate;
extern NSString * const kNewsType;
extern NSString * const kNewsTypeName;


@interface BBNews : NSObject

@property (nonatomic, readwrite) NSInteger active;
@property (nonatomic, readwrite) NSInteger agreeCount;
@property (nonatomic, readwrite) NSInteger disagreeCount;
@property (nonatomic, readwrite) NSInteger favouriteCount;
@property (nonatomic, readwrite) NSInteger newsworthyCount;
@property (nonatomic, readwrite) NSInteger replyCount;
@property (copy, nonatomic, readwrite) NSString *accountID;
@property (copy, nonatomic, readwrite) NSString *ipHash;
@property (copy, nonatomic, readwrite) NSString *networkID;
@property (copy, nonatomic, readwrite) NSString *networkName;
@property (copy, nonatomic, readwrite) NSString *networkShortName;
@property (copy, nonatomic, readwrite) NSString *ID;
@property (copy, nonatomic, readwrite) NSString *parentID;
@property (copy, nonatomic, readwrite) NSString *screenNameID;
@property (copy, nonatomic, readwrite) NSString *screenNameImage;
@property (copy, nonatomic, readwrite) NSString *screenNameValue;
@property (copy, nonatomic, readwrite) NSString *text;
@property (copy, nonatomic, readwrite) NSDate *date;
@property (copy, nonatomic, readwrite) NSString *type;
@property (copy, nonatomic, readwrite) NSString *typeName;
@property (copy, nonatomic, readwrite) NSString *localNetworkName;
@property (nonatomic, readwrite) BOOL hasVotedAgree;
@property (nonatomic, readwrite) BOOL hasVotedDisagree;
@property (nonatomic, readwrite) BOOL hasVotedNewsworthy;


- (id)initWithJSONObject:(id)JSONObject;

@end
