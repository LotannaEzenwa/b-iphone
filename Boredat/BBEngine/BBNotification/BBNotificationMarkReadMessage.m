//
//  BBNotificationMarkReadMessage.m
//  Boredat
//
//  Created by Dmitry Letko on 6/3/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBNotificationMarkReadMessage.h"
#import "BBStatusResponse.h"


@implementation BBNotificationMarkReadMessage

#pragma mark -
#pragma mark BBMessage overload

- (NSString *)pathComponent
{
    return @"/notifications/notification_mark_read";
}


#pragma mark -
#pragma mark BBMessageProtocol required methods

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBStatusResponse class];
}

@end
