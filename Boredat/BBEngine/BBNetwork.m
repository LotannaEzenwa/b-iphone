//
//  BBNetwork.m
//  Boredat
//
//  Created by David Pickart on 12/18/15.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import "BBNetwork.h"
#import "MgmtUtils.h"
#import "NSObject+NULL.h"

@implementation BBNetwork
@end


@implementation BBNetwork (JSONObject)

- (id)initWithJSONObject:(id)JSONObject
{
    self = [super init];
    
    if (self != nil)
    {
        NSDictionary *JSONDictionary = NSDictionaryObject(JSONObject);
        
        if (JSONDictionary.count > 0)
        {
            _networkId = [[JSONDictionary objectForKey:@"networkId"] copy];
            _networkName = [[JSONDictionary objectForKey:@"networkName"] copy];
            _networkShortName = [[JSONDictionary objectForKey:@"networkShortName"] copy];
            _networkDarkColor = [[JSONDictionary objectForKey:@"networkDarkColor"] copy];
            _networkLightColor = [[JSONDictionary objectForKey:@"networkLightColor"] copy];
            _networkAlternateColor = [[JSONDictionary objectForKey:@"networkAlternateColor"] copy];
            _networkLeaderPersonalityId = [[JSONDictionary objectForKey:@"networkLeaderPersonalityId"] copy];
            _networkTotalPosts = [[JSONDictionary objectForKey:@"networkTotalPosts"] copy];
            _networkTimeOffset = [[JSONDictionary objectForKey:@"networkTimeOffset"] copy];
            _networkEmailDomains = [[JSONDictionary objectForKey:@"networkEmailDomains"] copy];
        }
    }
    
    return self;
}

@end
