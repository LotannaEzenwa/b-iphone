//
//  BBNotificationAggregate.h
//  Boredat
//
//  Created by David Pickart on 7/17/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

@class BBPost;

#import <Foundation/Foundation.h>

@interface BBNotificationAggregate : NSObject

@property (nonatomic, readwrite) NSInteger agrees;
@property (nonatomic, readwrite) NSInteger disagrees;
@property (nonatomic, readwrite) NSInteger newsworthies;
@property (nonatomic, readwrite) NSInteger replyUpdates;
@property (nonatomic, readwrite) NSInteger replies;
@property (nonatomic, readwrite) NSInteger urlClicks;
@property (nonatomic, readwrite) NSInteger messages;
@property (nonatomic, readwrite) NSInteger profileViews;

@property (strong, nonatomic, readwrite) NSDate *lastChanged;
@property (nonatomic, readwrite) BOOL read;
@property (nonatomic, readonly) NSInteger numNotificationTypes;
@property (strong, nonatomic, readwrite) BBPost *post;

- (BBNotificationAggregate *)clearStats;

@end
