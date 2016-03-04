//
//  BBNetworkResponse.m
//  Boredat
//
//  Created by David Pickart on 12/18/15.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import "BBNetworkResponse.h"
#import "BBResponseDataProtocol.h"
#import "BBNetwork.h"

@implementation BBNetworkResponse

- (id)initWithData:(id<BBResponseDataProtocol>)data
{
    self = [super initWithData:data];
    
    if (self != nil)
    {
        _network = [[BBNetwork alloc] initWithJSONObject:data.JSONObject];
    }
    
    return self;
}


@end
