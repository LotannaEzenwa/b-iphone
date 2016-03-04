//
//  BBBestPersonalityPostsMessage.m
//  Boredat
//
//  Created by David Pickart on 5/20/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

#import "BBBestPersonalityPostsMessage.h"
#import "BBPersonalityPostsResponse.h"

static NSString *const kQueryPage = @"page";
static NSString *const kQueryUID = @"id";

@implementation BBBestPersonalityPostsMessage

- (id)mutableCopyWithZone:(NSZone *)zone
{
    BBBestPersonalityPostsMessage *copy = [super mutableCopyWithZone:zone];
    copy.page = _page;
    copy.UID = _UID;
    
    return copy;
}

#pragma mark -
#pragma mark BBHTTPProtocol required methods

- (NSString *)pathComponent
{
    return @"/personality/posts/best";
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
