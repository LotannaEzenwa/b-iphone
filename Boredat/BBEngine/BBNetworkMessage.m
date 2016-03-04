//
//  BBNetworkMessage.m
//  Boredat
//
//  Created by David Pickart on 12/18/15.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import "BBNetworkMessage.h"
#import "BBNetworkResponse.h"
#import "MgmtUtils.h"


@implementation BBNetworkMessage

#pragma mark -
#pragma mark NSMutableCopying required methods

- (id)mutableCopyWithZone:(NSZone *)zone
{
    BBNetworkMessage *copy = [super mutableCopyWithZone:zone];
    copy.email = _email;
    
    return copy;
}

#pragma mark -
#pragma mark BBMessage overload

- (NSString *)pathComponent
{
    return @"/network";
}

#pragma mark -
#pragma mark BBHTTPProtocol required methods

- (NSString *)HTTPMethod
{
    return cHTTPMethodGET;
}

- (NSDictionary *)URLQueries
{
    if (_email != nil)
    {
        NSMutableDictionary *queries = [NSMutableDictionary dictionaryWithCapacity:1];
        [queries setValue:_email forKey:@"email"];
        return queries;
    }
    else
    {
        return nil;
    }
}


#pragma mark -
#pragma mark BBMessageProtocol required methods

- (Class<BBResponseProtocol>)BBResponseClass
{
    return [BBNetworkResponse class];
}

- (BOOL)isEqualToMessage:(id<BBMessageProtocol>)message
{
    if (self == message)
    {
        return YES;
    }
    else if ([message isKindOfClass:[BBNetworkMessage class]] == YES)
    {
        BBNetworkMessage *networkMessage = (BBNetworkMessage *)message;
        return (_email == networkMessage.email);
    }
    
    return NO;
}

- (NSUInteger)hash
{
    const NSUInteger superHash = super.hash;
    const NSUInteger emailHash = _email.hash;
    const NSUInteger hash = (superHash ^ emailHash);
    
    return hash;
}

@end
