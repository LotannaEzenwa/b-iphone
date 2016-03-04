//
//  BBPersonalityResponse.m
//  Boredat
//
//  Created by Dmitry Letko on 3/20/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBPersonalityResponse.h"
#import "BBPersonality.h"

#import "BBResponseDataProtocol.h"

#import "MgmtUtils.h"


@implementation BBPersonalityResponse

- (id)initWithData:(id<BBResponseDataProtocol>)data
{
    self = [super initWithData:data];
    
    if (self != nil)
    {
        _personality = [[BBPersonality alloc] initWithJSONObject:data.JSONObject];
    }
    
    return self;
}

@end
