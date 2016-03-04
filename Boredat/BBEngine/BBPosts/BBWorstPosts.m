//
//  BBWorstPosts.m
//  Boredat
//
//  Created by Anton Kolosov on 1/24/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBWorstPosts.h"
#import "BBPostsResponse.h"

@implementation BBWorstPosts

- (NSString *)pathComponent
{
    return @"/posts/weeks/worst";
}

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBPostsResponse class];
}

@end
