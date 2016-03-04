//
//  BBNotificationAggregate.m
//  Boredat
//
//  Created by David Pickart on 7/17/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

#import "BBNotificationAggregate.h"

@implementation BBNotificationAggregate

- init
{
    self = [super init];
    if (self != nil)
    {
        _read = YES;
    }
    return self;
}

- (BBNotificationAggregate *)clearStats
{
    // Clears all info except for post
    BBNotificationAggregate *newAggregate = [BBNotificationAggregate new];
    newAggregate.post = _post;
    return newAggregate;
}

- (NSInteger)numNotificationTypes
{
    NSInteger numTypes = 0;
    
    numTypes += _agrees > 0 ? 1 : 0;
    numTypes += _disagrees > 0 ? 1 : 0;
    numTypes += _newsworthies > 0 ? 1 : 0;
    numTypes += _replyUpdates > 0 ? 1 : 0;
    numTypes += _replies > 0 ? 1 : 0;
    numTypes += _urlClicks > 0 ? 1 : 0;
    numTypes += _messages > 0 ? 1 : 0;
    numTypes += _profileViews > 0 ? 1 : 0;

    return numTypes;
}

@end
