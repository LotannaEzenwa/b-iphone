//
//  BBPersonality.h
//  Boredat
//
//  Created by Dmitry Letko on 3/20/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

extern NSString * const kPersonalityImage;
extern NSString * const kPersonalityId;
extern NSString * const kPostCount;
extern NSString * const kProfileViews;

@class BBPost;

@interface BBPersonality : NSObject

@property (copy, nonatomic, readwrite) NSString *image;
@property (copy, nonatomic, readwrite) NSString *personalityId;
@property (copy, nonatomic, readwrite) NSString *personalityName;
@property (nonatomic, readwrite) NSInteger postCount;
@property (nonatomic, readwrite) NSInteger profileViews;
@property (copy, nonatomic, readwrite) NSString *networkName;

@end


@interface BBPersonality (JSONObject)

- (id)initWithJSONObject:(id)JSONObject;
- (id)initWithPost:(BBPost *)post;

@end