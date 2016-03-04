//
//  BBUser.m
//  Boredat
//
//  Created by Dmitry Letko on 1/30/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBUser.h"

#import "MgmtUtils.h"

#import "NSObject+NULL.h"


NSString *const kPersonalityUID = @"personalityId";
NSString *const kPersonalityName = @"personalityName";
NSString *const kUserTotalNotifications = @"userTotalNotifications";
NSString * const kUserNetworkName = @"networkName";
NSString * const kUserNetworkShortName = @"networkShortname";


@implementation BBUser
@end


@implementation BBUser (JSONObject)

- (id)initWithJSONObject:(id)JSONObject
{
    self = [super init];
    
    if (self != nil)
    {
        NSDictionary *JSONDictionary = NSDictionaryObject(JSONObject);
                
        if (JSONDictionary.count > 0)
        {
            _personalityUID = [[JSONDictionary objectForKey:kPersonalityUID] copy];
            _personalityName = [[JSONDictionary objectForKey:kPersonalityName] copy];
            _userTotalNotifications = [[JSONDictionary objectForKey:kUserTotalNotifications] integerValue];
            
            _networkName = [[JSONDictionary objectForKey:kUserNetworkName] copy];
            _networkShortName = [[JSONDictionary objectForKey:kUserNetworkShortName] copy];
        }
    }
    
    return self;
}

@end