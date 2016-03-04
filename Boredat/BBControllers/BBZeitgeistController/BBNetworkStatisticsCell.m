//
//  BBNetworkStatisticsCell.m
//  Boredat
//
//  Created by Anton Kolosov on 10/9/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBNetworkStatisticsCell.h"
#import "BBApplicationSettings.h"

@interface BBNetworkStatisticsCell ()

@property (strong, nonatomic, readwrite) UILabel *todayPostsLabel;
@property (strong, nonatomic, readwrite) UILabel *yesterdayPostsLabel;
@property (strong, nonatomic, readwrite) UILabel *totalPostsLabel;
@property (strong, nonatomic, readwrite) UILabel *titleLabel;

@end

@implementation BBNetworkStatisticsCell


#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.todayPostsLabel];
        [self.contentView addSubview:self.yesterdayPostsLabel];
        [self.contentView addSubview:self.totalPostsLabel];
        [self.contentView addSubview:self.titleLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


#pragma mark -
#pragma mark Public methods

#pragma mark -
#pragma mark Private methods

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(0.0f, 5.0f, CGRectGetWidth(self.contentView.frame), 30.0f);
    CGFloat labelWidth = 75.0f;
    CGFloat spacing = (self.frame.size.width - (3*labelWidth)) / 6;
    _todayPostsLabel.frame = CGRectMake(2*spacing, 20.0f, labelWidth, 60.0f);
    _yesterdayPostsLabel.frame = CGRectOffset(_todayPostsLabel.frame, labelWidth+spacing, 0.0f);
    _totalPostsLabel.frame = CGRectOffset(_yesterdayPostsLabel.frame, labelWidth+spacing, 0.0f);
}

#pragma mark -
#pragma mark Propeties getters

- (UILabel *)todayPostsLabel
{
    if (_todayPostsLabel == nil)
    {
        _todayPostsLabel = [UILabel new];
        _todayPostsLabel.backgroundColor = [UIColor clearColor];
        _todayPostsLabel.textColor = [UIColor grayColor];
        _todayPostsLabel.numberOfLines = 2;
        _todayPostsLabel.font = [BBApplicationSettings fontForKey:kFontDetailsLarge];
        _todayPostsLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _todayPostsLabel;
}

- (UILabel *)yesterdayPostsLabel
{
    if (_yesterdayPostsLabel == nil)
    {
        _yesterdayPostsLabel = [UILabel new];
        _yesterdayPostsLabel.backgroundColor = [UIColor clearColor];
        _yesterdayPostsLabel.textColor = [UIColor grayColor];
        _yesterdayPostsLabel.numberOfLines = 2;
        _yesterdayPostsLabel.font = [BBApplicationSettings fontForKey:kFontDetailsLarge];
        _yesterdayPostsLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _yesterdayPostsLabel;
}

- (UILabel *)totalPostsLabel
{
    if (_totalPostsLabel == nil)
    {
        _totalPostsLabel = [UILabel new];
        _totalPostsLabel.backgroundColor = [UIColor clearColor];
        _totalPostsLabel.textColor = [UIColor grayColor];
        _totalPostsLabel.numberOfLines = 2;
        _totalPostsLabel.font = [BBApplicationSettings fontForKey:kFontDetailsLarge];
        _totalPostsLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _totalPostsLabel;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = [BBApplicationSettings fontForKey:kFontTitle];
        _titleLabel.text = @"Total Posts";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

@end
