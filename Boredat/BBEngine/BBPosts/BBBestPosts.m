//
//  BBBestPosts.m
//  Boredat
//
//  Created by Anton Kolosov on 1/24/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBBestPosts.h"
#import "BBPostsResponse.h"

@implementation BBBestPosts

- (NSString *)pathComponent
{
    return @"/posts/weeks/best";
}

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBPostsResponse class];
}

@end
