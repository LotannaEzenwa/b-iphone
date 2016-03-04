//
//  BBScreennameUpdateMessage.m
//  Boredat
//
//  Created by David Pickart on 7/2/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

#import "BBScreennameUpdateMessage.h"
#import "BBScreennameUpdateResponse.h"

static NSString *const kQueryScreenname = @"screenname";

@implementation BBScreennameUpdateMessage

- (id)mutableCopyWithZone:(NSZone *)zone
{
    BBScreennameUpdateMessage *copy = [super mutableCopyWithZone:zone];
    copy.screenname = _screenname;
    
    return copy;
}

#pragma mark -
#pragma mark BBHTTPProtocol required methods

- (NSString *)pathComponent
{
    return @"/personality";
}

#pragma mark -
#pragma mark BBHTTPProtocol required methods

- (NSDictionary *)URLQueries
{
    NSMutableDictionary *queries = [NSMutableDictionary dictionaryWithCapacity:0];
    
    return queries;
}

#pragma mark -
#pragma mark BBMessageProtocol required methods

- (NSString *)HTTPMethod
{
    return cHTTPMethodPOST;
}

- (NSDictionary *)HTTPBodyParameters
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameters setValue:_screenname forKey:kQueryScreenname];
    
    return parameters;
}

- (Class<BBResponseProtocol>)BBResponseClass
{
    return [BBScreennameUpdateResponse class];
}

@end
