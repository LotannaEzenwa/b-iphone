//
//  BBRecentPersonalityPostsMessage.m
//  Boredat
//
//  Created by David Pickart on 5/20/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

#import "BBRecentPersonalityPostsMessage.h"
#import "BBPersonalityPostsResponse.h"

static NSString *const kQueryPage = @"page";
static NSString *const kQueryUID = @"id";

@implementation BBRecentPersonalityPostsMessage


- (id)mutableCopyWithZone:(NSZone *)zone
{
    BBRecentPersonalityPostsMessage *copy = [super mutableCopyWithZone:zone];
    copy.page = _page;
    copy.UID = _UID;
    
    return copy;
}

#pragma mark -
#pragma mark BBHTTPProtocol required methods

- (NSString *)pathComponent
{
    return @"/personality/posts/recent";
}

#pragma mark -
#pragma mark BBHTTPProtocol required methods

- (NSDictionary *)URLQueries
{
    NSMutableDictionary *queries = [NSMutableDictionary dictionaryWithCapacity:2];
    [queries setValue:_page forKey:kQueryPage];
    [queries setValue:_UID forKey:kQueryUID];
    
    return queries;
}

#pragma mark -
#pragma mark BBMessageProtocol required methods

- (Class<BBResponseProtocol>)BBResponseClass
{
    return [BBPersonalityPostsResponse class];
}

@end
