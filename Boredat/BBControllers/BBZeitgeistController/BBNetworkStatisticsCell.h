//
//  BBNetworkStatisticsCell.h
//  Boredat
//
//  Created by Anton Kolosov on 10/9/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@interface BBNetworkStatisticsCell : UITableViewCell

@property (strong, nonatomic, readonly) UILabel *todayPostsLabel;
@property (strong, nonatomic, readonly) UILabel *yesterdayPostsLabel;
@property (strong, nonatomic, readonly) UILabel *totalPostsLabel;

@end
