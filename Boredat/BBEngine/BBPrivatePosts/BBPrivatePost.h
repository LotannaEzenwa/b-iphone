//
//  BBPrivatePost.h
//  Boredat
//
//  Created by Dmitry Letko on 5/8/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

extern NSString *const kFeedUID;
extern NSString *const kUID;
extern NSString *const kIsRead;
extern NSString *const kCreated;
extern NSString *const kText;
extern NSString *const kSubject;
extern NSString *const kSenderUID;
extern NSString *const kSenderName;
extern NSString *const kSenderImage;


@interface BBPrivatePost : NSObject
@property (copy, nonatomic, readonly) NSString *feedUID;
@property (copy, nonatomic, readonly) NSString *UID;
@property (copy, nonatomic, readonly) NSDate *created;
@property (copy, nonatomic, readonly) NSString *text;
@property (copy, nonatomic, readonly) NSString *subject;
@property (copy, nonatomic, readonly) NSString *senderUID;
@property (copy, nonatomic, readonly) NSString *senderName;
@property (copy, nonatomic, readonly) NSString *senderImage;
@property (nonatomic, readonly) BOOL isRead;

@end


@interface BBPrivatePost (JSONObject)

- (id)initWithJSONObject:(id)JSONObject;

@end