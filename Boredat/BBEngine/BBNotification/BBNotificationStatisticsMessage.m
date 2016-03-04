//
//  BBNotificationStatisticsMessage.m
//  Boredat
//
//  Created by Dmitry Letko on 5/8/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBNotificationStatisticsMessage.h"
#import "BBNotificationStatisticsResponse.h"


@implementation BBNotificationStatisticsMessage

#pragma mark -
#pragma mark BBMessage overload

- (NSString *)pathComponent
{
	return @"/notifications/fetch_statistics";
}


#pragma mark BBMessageProtocol required methods
#pragma mark -

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBNotificationStatisticsResponse class];
}

@end
