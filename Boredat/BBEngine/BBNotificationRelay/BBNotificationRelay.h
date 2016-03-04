//
//  BBNotificationRelay.h
//  Boredat
//
//  Created by Dmitry Letko on 5/13/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@class BBFacade;

@protocol BBNotificationRelaySubscriber;


@interface BBNotificationRelay : NSObject
@property (strong, nonatomic, readwrite) BBFacade *facade;
@property (nonatomic, readonly) NSUInteger countOfNotifications;

- (void)subscribe:(id<BBNotificationRelaySubscriber>)subscriber;
- (void)unsubscribe:(id<BBNotificationRelaySubscriber>)subscriber;

- (void)updateCountOfNotifications;
- (void)updateCountOfNotificationsIfNeeded;

@end
