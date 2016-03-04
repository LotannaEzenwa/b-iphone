//
//  BBUserResponse.m
//  Boredat
//
//  Created by Dmitry Letko on 1/30/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBUserResponse.h"
#import "BBUser.h"

#import "BBResponseDataProtocol.h"

#import "MgmtUtils.h"


@implementation BBUserResponse

- (id)initWithData:(id<BBResponseDataProtocol>)data
{
    self = [super initWithData:data];
    
    if (self != nil)
    {        
        _user = [[BBUser alloc] initWithJSONObject:data.JSONObject];  
    }
    
    return self;
}

@end
