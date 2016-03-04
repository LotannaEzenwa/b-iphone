//
//  BBBestPersonalityPostsMessage.m
//  Boredat
//
//  Created by David Pickart on 5/20/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

#import "BBWorstPersonalityPostsMessage.h"
#import "BBPersonalityPostsResponse.h"

static NSString *const kQueryPage = @"page";
static NSString *const kQueryUID = @"id";

@implementation BBWorstPersonalityPostsMessage

- (id)mutableCopyWithZone:(NSZone *)zone
{
    BBWorstPersonalityPostsMessage *copy = [super mutableCopyWithZone:zone];
    copy.page = _page;
    copy.UID = _UID;
    
    return copy;
}

#pragma mark -
#pragma mark BBHTTPProtocol required methods

- (NSString *)pathComponent
{
    return @"/personality/posts/worst";
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
