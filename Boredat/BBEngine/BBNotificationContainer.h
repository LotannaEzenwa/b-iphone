//
//  BBNotificationContainer.h
//  Boredat
//
//  Created by Anton Kolosov on 10/1/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBNotification.h"

@interface BBNotificationContainer : NSObject

@property (strong, nonatomic, readwrite) BBNotification *notification;
@property (nonatomic, readwrite) NSInteger notificationsCount;

- (void)increaseNotificationsCount;

@end
