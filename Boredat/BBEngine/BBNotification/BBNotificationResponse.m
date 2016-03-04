//
//  BBNotificationResponse.m
//  Boredat
//
//  Created by Dmitry Letko on 1/31/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBNotificationResponse.h"
#import "BBNotification.h"

#import "BBResponseDataProtocol.h"

#import "MgmtUtils.h"

#import "NSObject+NULL.h"


static NSString *const kPage = @"page";
static NSString *const kNotifications = @"messages";


@implementation BBNotificationResponse

- (id)initWithData:(id<BBResponseDataProtocol>)data
{
    self = [super initWithData:data];
    
    if (self != nil)
    {
        id JSONObject = data.JSONObject;
        
        if ([JSONObject isKindOfClass:[NSDictionary class]] == YES)
        {
            NSDictionary *JSONDictionary = JSONObject;
            
            if (JSONDictionary.count > 0)
            {
                NSArray *JSONNotifications = [JSONDictionary objectForKey:kNotifications];                
                NSMutableArray *notifications = [[NSMutableArray alloc] initWithCapacity:JSONNotifications.count];
                
                [JSONNotifications enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    BBNotification *notification = [[BBNotification alloc] initWithJSONObject:obj];
                    
                    if (notification != nil)
                    {
                        [notifications addObject:notification];
                    }
                }];
                
                _notifications = [notifications copy];
                _page = [[JSONDictionary objectForKey:kPage] integerValue];
                
            }
        }
        else
            if ([JSONObject isKindOfClass:[NSArray class]] == YES)
            {
                NSArray *JSONArray = JSONObject;
                
                if (JSONArray.count > 0)
                {                    
                    NSMutableArray *notifications = [[NSMutableArray alloc] init];
                    
                    [JSONArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        BBNotification *notification = [[BBNotification alloc] initWithJSONObject:obj];
                        
                        if (notification != nil)
                        {
                            [notifications addObject:notification];
                        }
                    }];
                    
                    _notifications = [notifications copy];
                    
                }
            }
    }
    
    return self;
}

@end
