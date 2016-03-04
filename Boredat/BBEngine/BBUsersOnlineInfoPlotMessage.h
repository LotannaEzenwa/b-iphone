//
//  BBUsersOnlineInfoPlotMessage.h
//  Boredat
//
//  Created by Anton Kolosov on 1/16/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBZeitgeistMessage.h"

@interface BBUsersOnlineInfoPlotMessage : BBMessage

@property (nonatomic, readwrite) NSUInteger periodOfTime;
@property (copy, nonatomic, readwrite) NSSet *fields;

@end
