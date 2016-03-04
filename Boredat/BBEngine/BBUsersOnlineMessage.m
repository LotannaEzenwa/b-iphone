//
//  BBUsersOnlineMessage.m
//  Boredat
//
//  Created by Anton Kolosov on 10/8/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBUsersOnlineMessage.h"
#import "BBUsersOnlineResponse.h"

@implementation BBUsersOnlineMessage

#pragma mark -
#pragma mark BBHTTPProtocol required methods

- (NSString *)pathComponent
{
    return @"/statistics/users/online";
}

#pragma mark -
#pragma mark BBMessageProtocol required methods

- (Class<BBResponseProtocol>)BBResponseClass
{
	return [BBUsersOnlineResponse class];
}

@end
