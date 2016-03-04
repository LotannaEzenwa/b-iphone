//
//  BBUser.h
//  Boredat
//
//  Created by Dmitry Letko on 1/30/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

extern NSString *const kPersonalityUID;
extern NSString *const kPersonalityName;
extern NSString *const kUserTotalNotifications;
extern NSString * const kUserNetworkName;
extern NSString * const kUserNetworkShortName;


@interface BBUser : NSObject
@property (copy, nonatomic, readwrite) NSString *personalityUID;
@property (copy, nonatomic, readwrite) NSString *personalityName;
@property (nonatomic, readwrite) NSUInteger userTotalNotifications;
@property (copy, nonatomic, readwrite) NSString *networkName;
@property (copy, nonatomic, readwrite) NSString *networkShortName;

@end


@interface BBUser (JSONObject)

- (id)initWithJSONObject:(id)JSONObject;

@end