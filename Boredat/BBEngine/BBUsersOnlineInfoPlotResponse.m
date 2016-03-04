//
//  BBUsersOnlineInfoPlot.m
//  Boredat
//
//  Created by Anton Kolosov on 1/16/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBUsersOnlineInfoPlotResponse.h"
#import "BBResponseDataProtocol.h"
#import "NSObject+NULL.h"
#import "MgmtUtils.h"

@interface BBUsersOnlineInfoPlotResponse ()

@property (copy, nonatomic, readwrite) NSArray *timePoints;
@property (copy, nonatomic, readwrite) NSArray *userPoints;
@property (copy, nonatomic, readwrite) NSDictionary *pointsDictionary;

@end

@implementation BBUsersOnlineInfoPlotResponse

- (id)initWithData:(id<BBResponseDataProtocol>)data
{
    self = [super initWithData:data];
    
    if (self != nil)
    {
        NSDictionary *JSONDictionary = NSDictionaryObject(data.JSONObject);
//        NSLog(@"dictionary points %@", JSONDictionary);
        _pointsDictionary = [JSONDictionary copy];
        
        _timePoints = [[JSONDictionary allKeys] copy];
        _userPoints = [[JSONDictionary allValues] copy];
    }
    
    return self;
}




@end
