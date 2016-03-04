//
//  BBNotificationStatisticsResponse.h
//  Boredat
//
//  Created by Dmitry Letko on 5/8/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBResponse.h"


@class BBNotificationStatistics;


@interface BBNotificationStatisticsResponse : BBResponse
@property (strong, nonatomic, readonly) BBNotificationStatistics *statistics;

@end
