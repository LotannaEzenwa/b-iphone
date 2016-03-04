//
//  BBUsersOnlineResponse.m
//  Boredat
//
//  Created by Anton Kolosov on 10/8/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBUsersOnlineResponse.h"
#import "BBResponseDataProtocol.h"
#import "NSObject+NULL.h"
#import "MgmtUtils.h"

static NSString * const kUsersTodayKey = @"loginsToday";
static NSString * const kUsersOnlineKey = @"usersOnline";
static NSString * const kUsersUniqueTodayKey = @"uniqueUserLoginsToday";

@interface BBUsersOnlineResponse ()

@property (copy, nonatomic, readwrite) NSString *usersToday;
@property (copy, nonatomic, readwrite) NSString *usersOnline;
@property (copy, nonatomic, readwrite) NSString *usersUnique;

@end

@implementation BBUsersOnlineResponse

@synthesize usersToday = _usersToday;
@synthesize usersOnline = _usersOnline;
@synthesize usersUnique = _usersUnique;

- (id)initWithData:(id<BBResponseDataProtocol>)data
{
    self = [super initWithData:data];
    
    if (self != nil)
    {
        NSDictionary *JSONDictionary = NSDictionaryObject(data.JSONObject);
//        NSLog(@"users %@", JSONDictionary);
        _usersToday = [[JSONDictionary objectForKey:kUsersTodayKey] copy];
        _usersOnline = [[JSONDictionary objectForKey:kUsersOnlineKey] copy];
        _usersUnique = [[JSONDictionary objectForKey:kUsersUniqueTodayKey] copy];
    }
    
    return self;
}

@end
