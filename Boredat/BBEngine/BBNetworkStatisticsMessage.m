//
//  BBNetworkStatistics.m
//  Boredat
//
//  Created by Anton Kolosov on 10/8/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBNetworkStatisticsMessage.h"
#import "BBNetworkStatisticsResponse.h"

@implementation BBNetworkStatisticsMessage

- (NSString *)pathComponent
{
    return @"/statistics";
}

#pragma mark -
#pragma mark BBMessageProtocol required methods

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBNetworkStatisticsResponse class];
}

@end
