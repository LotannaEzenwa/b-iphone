//
//  BBNotificationDetailsCell.h
//  Boredat
//
//  Created by David Pickart on 7/18/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

@class BBNotificationAggregate;

#import <UIKit/UIKit.h>

@interface BBNotificationDetailsCell : UITableViewCell

@property (copy, nonatomic, readwrite) UILabel *agreeLabel;
@property (copy, nonatomic, readwrite) UILabel *disagreeLabel;
@property (copy, nonatomic, readwrite) UILabel *newsworthyLabel;
@property (copy, nonatomic, readwrite) UILabel *replyUpdateLabel;
@property (copy, nonatomic, readwrite) UILabel *replyLabel;
@property (copy, nonatomic, readwrite) UILabel *urlClickLabel;
@property (copy, nonatomic, readwrite) UILabel *messageLabel;
@property (copy, nonatomic, readwrite) UILabel *profileViewLabel;

@property (copy, nonatomic, readwrite) NSMutableArray *detailLabels;

- (void)formatWithNotification:(BBNotificationAggregate *)notification;
+ (CGFloat)heightForCellWithNotification:(BBNotificationAggregate *)notification;

@end
