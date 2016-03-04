//
//  BBNotificationTargetResponse.h
//  Boredat
//
//  Created by Dmitry Letko on 5/15/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBResponse.h"


@interface BBNotificationTargetResponse : BBResponse
@property (copy, nonatomic, readonly) NSArray *notifications;

@end
