//
//  BBNotificationStatistics.h
//  Boredat
//
//  Created by Dmitry Letko on 5/8/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

extern NSString *const kNotificationsTotalCount;
extern NSString *const kNotificationsLastID;

 
@interface BBNotificationStatistics : NSObject
@property (nonatomic, readonly) NSUInteger urlClicks;
@property (nonatomic, readonly) NSUInteger urlClickPoints;
@property (nonatomic, readonly) NSUInteger agrees;
@property (nonatomic, readonly) NSUInteger agreesPoints;
@property (nonatomic, readonly) NSUInteger disagrees;
@property (nonatomic, readonly) NSUInteger disagreesPoints;
@property (nonatomic, readonly) NSUInteger newsworthies;
@property (nonatomic, readonly) NSUInteger newsworthiesPoints;
@property (nonatomic, readonly) NSUInteger replies;
@property (nonatomic, readonly) NSUInteger repliesPoints;
@property (nonatomic, readonly) NSUInteger reputations;
@property (nonatomic, readonly) NSUInteger reputationsPoints;
@property (nonatomic, readonly) NSUInteger posts;
@property (nonatomic, readonly) NSUInteger postsPoints;
@property (nonatomic, readonly) NSUInteger profile;
@property (nonatomic, readonly) NSUInteger profilePoints;
@property (nonatomic, readonly) NSUInteger messages;
@property (nonatomic, readonly) NSUInteger messagesPoints;
@property (nonatomic, readonly) NSUInteger countOfNotifications;
@property (nonatomic, readonly) NSUInteger totalCountOfNotifications;
@property (copy, nonatomic, readonly) NSString *lastID;
@property (copy, nonatomic, readonly) NSDictionary *json;

@property (nonatomic, readwrite) NSUInteger replyUpdates;
@property (nonatomic, readwrite) NSUInteger replyUpdatesPoints;

- (BOOL)isEqualToNotificationStatistics:(BBNotificationStatistics *)statistics;

@end


@interface BBNotificationStatistics (JSONObject)

- (id)initWithJSONObject:(id)JSONObject;

@end