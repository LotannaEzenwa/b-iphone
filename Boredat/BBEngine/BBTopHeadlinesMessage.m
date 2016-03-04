//
//  BBTopHeadlinesMessage.m
//  Boredat
//
//  Created by Anton Kolosov on 1/14/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBTopHeadlinesMessage.h"
#import "BBTopHeadlinesResponse.h"

@implementation BBTopHeadlinesMessage

#pragma mark -
#pragma mark BBHTTPProtocol required methods

- (NSString *)pathComponent
{
    return @"/news/top";
}

#pragma mark -
#pragma mark BBMessageProtocol required methods

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBTopHeadlinesResponse class];
}


@end
