//
//  BBUsersPlotCell.m
//  Boredat
//
//  Created by Anton Kolosov on 10/9/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBUsersPlotCell.h"
#import "BBUsersPlotView.h"
#import "BBApplicationSettings.h"

@interface BBUsersPlotCell ()

@property (strong, nonatomic, readwrite) BBUsersPlotView *usersPlot;
@property (strong, nonatomic, readwrite) UILabel *titleLabel;
@property (strong, nonatomic, readwrite) UILabel *plotDescriptionLabel;
@property (strong, nonatomic, readwrite) UILabel *uniqueUsersLabel;

@end

@implementation BBUsersPlotCell

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        // Hides overflow
        self.clipsToBounds = YES;
        
        [self.contentView addSubview:self.usersPlot];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.uniqueUsersLabel];
        [self.contentView addSubview:self.plotDescriptionLabel];
        
        [self configureConstraints];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


#pragma mark -
#pragma mark Public methods

- (void)usersOnline:(NSString *)usersOnline andUsersToday:(NSString *)usersToday
{
    NSString *string = [NSString stringWithFormat:@"Users online: %@   In 24 hrs: %@", usersOnline, usersToday];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    self.titleLabel.attributedText = attributedString;
}

#pragma mark -
#pragma mark Private methods

- (void)configureConstraints
{
    [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_plotDescriptionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_uniqueUsersLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_usersPlot setTranslatesAutoresizingMaskIntoConstraints:NO];
    UIView *superView = self.contentView;
    
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superView
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:8.0f]];
    
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:_uniqueUsersLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_titleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:_uniqueUsersLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_titleLabel
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:_uniqueUsersLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_titleLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:3.0f]];
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_uniqueUsersLabel(25)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_uniqueUsersLabel)]];
    
    
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:_plotDescriptionLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_uniqueUsersLabel
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:_plotDescriptionLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_uniqueUsersLabel
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:_plotDescriptionLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_uniqueUsersLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:15.0f]];
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:_plotDescriptionLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superView
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0.0f
                                                           constant:12.0f]];
    
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:_usersPlot
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superView
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:_usersPlot
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superView
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:_usersPlot
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_plotDescriptionLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:0.0f]];
}

#pragma mark -
#pragma mark Properties getters

- (void)setYAxisPoints:(NSArray *)yAxisPoints
{
    _yAxisPoints = [yAxisPoints copy];
    self.usersPlot.yAxisPoints = _yAxisPoints;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = [BBApplicationSettings fontForKey:kFontDetailsLarge];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

- (BBUsersPlotView *)usersPlot
{
    if (_usersPlot == nil)
    {
        _usersPlot = [[BBUsersPlotView alloc] initWithMaxYValue:25.0f withMaxXValue:24.0f];
    }
    
    return _usersPlot;
}

- (UILabel *)uniqueUsersLabel
{
    if (_uniqueUsersLabel == nil)
    {
        _uniqueUsersLabel = [UILabel new];
        _uniqueUsersLabel.backgroundColor = [UIColor clearColor];
        _uniqueUsersLabel.font = [BBApplicationSettings fontForKey:kFontPost];
        _uniqueUsersLabel.textAlignment = NSTextAlignmentCenter;
        _uniqueUsersLabel.text = @"Unique logins in 24 hours: 1234";
    }
    
    return _uniqueUsersLabel;
}

- (UILabel *)plotDescriptionLabel
{
    if (_plotDescriptionLabel == nil)
    {
        _plotDescriptionLabel = [UILabel new];
        _plotDescriptionLabel.text = @"Users online in the last 5 hours:";
        _plotDescriptionLabel.backgroundColor = [UIColor clearColor];
        _plotDescriptionLabel.font = [BBApplicationSettings fontForKey:kFontPost];
        _plotDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _plotDescriptionLabel;
}

@end
