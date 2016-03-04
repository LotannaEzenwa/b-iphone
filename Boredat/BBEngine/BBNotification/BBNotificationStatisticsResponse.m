//
//  BBNotificationStatisticsResponse.m
//  Boredat
//
//  Created by Dmitry Letko on 5/8/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBNotificationStatisticsResponse.h"
#import "BBNotificationStatistics.h"

#import "BBResponseDataProtocol.h"

#import "MgmtUtils.h"

#import "NSObject+NULL.h"


@implementation BBNotificationStatisticsResponse

- (id)initWithData:(id<BBResponseDataProtocol>)data
{
	self = [super initWithData:data];
	
	if (self != nil)
	{
        _statistics = [[BBNotificationStatistics alloc] initWithJSONObject:data.JSONObject];
	}
	
	return self;
}


@end
