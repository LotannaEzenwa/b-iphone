//
//  BBUsersOnlineInfoPlot.h
//  Boredat
//
//  Created by Anton Kolosov on 1/16/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBResponse.h"

@interface BBUsersOnlineInfoPlotResponse : BBResponse

@property (copy, nonatomic, readonly) NSArray *timePoints;
@property (copy, nonatomic, readonly) NSArray *userPoints;
@property (copy, nonatomic, readonly) NSDictionary *pointsDictionary;

@end
