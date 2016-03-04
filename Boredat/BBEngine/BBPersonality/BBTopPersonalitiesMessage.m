//
//  BBTopPersonalitiesMessage.m
//  Boredat
//
//  Created by Anton Kolosov on 10/7/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBTopPersonalitiesMessage.h"
#import "BBPersonalityResponse.h"
#import "BBTopPersonalitiesResponse.h"

#import "MgmtUtils.h"

@implementation BBTopPersonalitiesMessage

#pragma mark -
#pragma mark BBHTTPProtocol required methods

- (NSString *)pathComponent
{
    return @"/personalities/weeks/best";
}

#pragma mark -
#pragma mark BBMessageProtocol required methods

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBTopPersonalitiesResponse class];
}

@end
