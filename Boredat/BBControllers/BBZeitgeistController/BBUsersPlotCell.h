//
//  BBUsersPlotCell.h
//  Boredat
//
//  Created by Anton Kolosov on 10/9/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBUsersPlotView.h"

@interface BBUsersPlotCell : UITableViewCell

@property (strong, nonatomic, readonly) UILabel *uniqueUsersLabel;
@property (copy, nonatomic, readwrite) NSArray *xAxisPoints;
@property (copy, nonatomic, readwrite) NSArray *yAxisPoints;
@property (strong, nonatomic, readonly) BBUsersPlotView *usersPlot;

- (void)usersOnline:(NSString *)usersOnline andUsersToday:(NSString *)usersToday;

@end
