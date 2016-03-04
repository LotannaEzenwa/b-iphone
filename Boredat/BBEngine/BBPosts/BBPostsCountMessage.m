//
//  BBPostCountMessage.m
//  Boredat
//
//  Created by Lesha on 7/17/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBPostsCountMessage.h"
#import "BBPostsCountResponse.h"
#import "MgmtUtils.h"


@implementation BBPostsCountMessage

- (id)mutableCopyWithZone:(NSZone *)zone
{
	BBPostsCountMessage *copy = [super mutableCopyWithZone:zone];
	
	return copy;
}



#pragma mark -
#pragma mark BBMessage overload

- (NSString *)pathComponent
{
    return @"/posts/pages";
}

#pragma mark -
#pragma mark BBMessageProtocol required methods
#pragma mark -

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBPostsCountResponse class];
}


#pragma mark -
#pragma mark equality

- (NSUInteger)hash
{
	const NSUInteger hash = super.hash;
	
	return hash;
}

@end
