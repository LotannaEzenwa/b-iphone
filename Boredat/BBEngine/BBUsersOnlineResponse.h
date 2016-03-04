//
//  BBUsersOnlineResponse.h
//  Boredat
//
//  Created by Anton Kolosov on 10/8/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBResponse.h"

@interface BBUsersOnlineResponse : BBResponse

@property (copy, nonatomic, readonly) NSString *usersOnline;
@property (copy, nonatomic, readonly) NSString *usersToday;
@property (copy, nonatomic, readonly) NSString *usersUnique;

@end
