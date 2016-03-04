//
//  BBNotification.h
//  Boredat
//
//  Created by Dmitry Letko on 1/31/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

extern NSString *const kNotificationUID;
extern NSString *const kNotificationCreated;
extern NSString *const kNotificationRead;
extern NSString *const kNotificationType;
extern NSString *const kNotificationTarget;
extern NSString *const kNotificationMoreInfo;
extern NSString *const kNotificationPoints;
extern NSString *const kNotificationTargetType;
extern NSString *const kNotificationLastID;

extern NSString *const kTarget;

extern NSString *const kNotificationTypeMessage;
extern NSString *const kNotificationTypePost;
extern NSString *const kNotificationTypeProfiles;


@interface BBNotification : NSObject
@property (copy, nonatomic, readonly) NSString *UID;
@property (copy, nonatomic, readonly) NSDate *created;
@property (copy, nonatomic, readonly) NSString *type;
@property (copy, nonatomic, readonly) NSString *message;
@property (copy, nonatomic, readonly) UIColor *color;
@property (copy, nonatomic, readonly) NSString *target;
@property (copy, nonatomic, readonly) NSString *targetType;
@property (copy, nonatomic, readonly) NSString *lastID;
@property (copy, nonatomic, readonly) id moreInfo;
@property (nonatomic, readonly) BOOL read;
@property (nonatomic, readwrite) NSInteger points;
@property (strong, nonatomic, readwrite) id entity;

@end


@interface BBNotification (JSONObject)

+ (NSDictionary *)entityClasses;

- (id)initWithJSONObject:(id)JSONObject;

@end