//
//  BBNotificationRelaySubscriber.h
//  Boredat
//
//  Created by Dmitry Letko on 5/13/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@class BBNotificationRelay;


@protocol BBNotificationRelaySubscriber <NSObject>
@optional

- (void)notificationRelayDidUpdateCount:(BBNotificationRelay *)relay;
- (void)notificationRelayDidUpdateStatistics:(BBNotificationRelay *)relay;

@end
