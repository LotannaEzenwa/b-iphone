//
//  BBNetwork.h
//  Boredat
//
//  Created by David Pickart on 12/18/15.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBNetwork : NSObject

@property NSString *networkId;
@property NSString *networkName;
@property NSString *networkShortName;
@property NSString *networkDarkColor;
@property NSString *networkLightColor;
@property NSString *networkAlternateColor;
@property NSString *networkLeaderPersonalityId;
@property NSString *networkTotalPosts;
@property NSString *networkTimeOffset;
@property NSString *networkEmailDomains;

@end

@interface BBNetwork (JSONObject)

- (id)initWithJSONObject:(id)JSONObject;

@end