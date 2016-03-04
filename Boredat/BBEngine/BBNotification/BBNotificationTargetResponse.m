//
//  BBNotificationTargetResponse.m
//  Boredat
//
//  Created by Dmitry Letko on 5/15/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBNotificationTargetResponse.h"
#import "BBNotification.h"

#import "BBPost.h"
#import "BBResponseDataProtocol.h"

#import "MgmtUtils.h"

#import "NSObject+NULL.h"


@implementation BBNotificationTargetResponse

- (id)initWithData:(id<BBResponseDataProtocol>)data
{
    self = [super initWithData:data];
    
    if (self != nil)
    {
        NSArray *JSONArray = NSArrayObject(data.JSONObject);
        if (JSONArray.count > 0)
        {
            NSMutableArray *notifications = [[NSMutableArray alloc] initWithCapacity:JSONArray.count];
            
            [JSONArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                BBNotification *notification = [[BBNotification alloc] initWithJSONObject:obj];
//                NSLog(@"notifiaction %@ and type %@ read %d", notification.UID, notification.type, notification.read);
                if (notification != nil)
                {
//                    BBNotification *previousNotification = [notifications lastObject];
//                    if ((![previousNotification.entity isKindOfClass:[BBPost class]]) && (previousNotification.type == notification.type))
//                    {
//                        [previousNotification setPoints:(previousNotification.points + notification.points)];
//                    }
//                    else
//                    {
                        [notifications addObject:notification];
//                    }

                }
            }];
            
            _notifications = [notifications copy];
            
        }
    }
    
    return self;
}

@end
