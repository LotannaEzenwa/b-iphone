//
//  BBRegistrationResponse.m
//  Boredat
//
//  Created by Dmitry Letko on 2/21/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBRegistrationResponse.h"

#import "BBResponseDataProtocol.h"

#import "MgmtUtils.h"

#import "NSObject+NULL.h"


static NSString *const kKey = @"email_verification_token";


@implementation BBRegistrationResponse

- (id)initWithData:(id<BBResponseDataProtocol>)data
{
    self = [super initWithData:data];
    
    if (self != nil)
    {
        NSDictionary *JSONDictionary = NSDictionaryObject(data.JSONObject);
        
        if (JSONDictionary.count > 0)
        {

        }
    }
    
    return self;
}

@end
