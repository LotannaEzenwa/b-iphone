//
//  BBNotificationResponse.h
//  Boredat
//
//  Created by Dmitry Letko on 1/31/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBResponse.h"


@class BBNotification;


@interface BBNotificationResponse : BBResponse
@property (copy, nonatomic, readonly) NSArray *notifications;
@property (nonatomic, readonly) NSInteger page;

@end
