//
//  BBNotificationAggregator.h
//  BoredAt
//
//  Created by David Pickart on 7/17/15.
//
//

#import <Foundation/Foundation.h>

@class BBNotificationRetriever;

@interface BBNotificationAggregator : NSObject

+ (NSArray *)notificationAggregatesFromRetriever:(BBNotificationRetriever *)retriever;

@end
