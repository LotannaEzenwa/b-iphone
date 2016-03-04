//
//  BBNotificationDetailsCell.m
//  Boredat
//
//  Created by David Pickart on 7/18/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

#import "BBApplicationSettings.h"
#import "BBFacade.h"
#import "BBNotificationDetailsCell.h"
#import "BBNotificationAggregate.h"
#import "UIKit+Extensions.h"

static CGFloat const kNotificationDetailsLabelPadding = 5.0f;
static CGFloat const kNotificationDetailsLabelHeight = 23.0f;

@interface BBNotificationDetailsCell ()

@property (copy, nonatomic, readwrite) UIView *topBorder;

@end

@implementation BBNotificationDetailsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self != nil)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _topBorder = [UIView new];
        [self.contentView addSubview:_topBorder];
        
        _detailLabels = [NSMutableArray new];
        
        _agreeLabel = [self detailLabelWithColor:[UIColor agreeColor]];
        _disagreeLabel = [self detailLabelWithColor:[UIColor disagreeColor]];
        _newsworthyLabel = [self detailLabelWithColor:[UIColor grayColor]];
        _replyUpdateLabel = [self detailLabelWithColor:[UIColor goldColor]];
        _replyLabel = [self detailLabelWithColor:[UIColor goldColor]];
        _urlClickLabel = [self detailLabelWithColor:[UIColor blueColor]];
        _messageLabel = [self detailLabelWithColor:[UIColor redColor]];
        _profileViewLabel = [self detailLabelWithColor:[UIColor blackColor]];
    }
    return self;
}

- (UILabel *)detailLabelWithColor:(UIColor *)color
{
    UILabel *label = [UILabel new];
    label.font = [BBApplicationSettings fontForKey:kFontPost];
//    label.textColor = [UIColor grayColor];
    label.highlightedTextColor = color;
    [self addSubview:label];
    [_detailLabels addObject:label];
    return label;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _topBorder.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, 2);
    
    CGFloat widthOffset = 15;
    CGFloat heightOffset = kNotificationDetailsLabelPadding;
    CGFloat labelWidth = self.contentView.frame.size.width - widthOffset;
    CGFloat labelHeight = kNotificationDetailsLabelHeight;
    
    for (UILabel *label in _detailLabels)
    {
        if (label.hidden == NO)
        {
            label.frame = CGRectMake(widthOffset, heightOffset, labelWidth, labelHeight);
            heightOffset += labelHeight;
        }
    }
}

- (void)hideAllLabels
{
    for (UILabel *label in _detailLabels)
    {
        label.hidden = YES;
    }
}

- (void)updateLabel:(UILabel *)label notificationCount:(NSInteger)count message:(NSString *)message
{
    if (count > 0)
    {
        if (count == 1)
        {
            message = [message stringByReplacingOccurrencesOfString:@"people" withString:@"person"];
            message = [message stringByReplacingOccurrencesOfString:@"replies" withString:@"reply"];
            message = [message stringByReplacingOccurrencesOfString:@"messages" withString:@"message"];
        }
        
        label.text = [NSString stringWithFormat:message, count];
        label.hidden = NO;
    }
}

- (void)formatWithNotification:(BBNotificationAggregate *)notification
{
    _topBorder.backgroundColor = [UIColor colorForColor:[[BBFacade sharedInstance] currentBoardColor] withOpacity:0.5];
    
    [self hideAllLabels];
    
    [self updateLabel:_agreeLabel notificationCount:notification.agrees message:@"%lu people agreed with your post"];
    [self updateLabel:_disagreeLabel notificationCount:notification.disagrees message:@"%lu people disagreed with your post"];
    [self updateLabel:_newsworthyLabel notificationCount:notification.newsworthies message:@"%lu people voted newsworthy on your post"];
    [self updateLabel:_replyUpdateLabel notificationCount:notification.replyUpdates message:@"A post you replied to has %lu more replies"];
    [self updateLabel:_replyLabel notificationCount:notification.replies message:@"Your post has %lu replies"];
    [self updateLabel:_urlClickLabel notificationCount:notification.urlClicks message:@"%lu people clicked on your link"];
    [self updateLabel:_messageLabel notificationCount:notification.messages message:@"You received %lu messages"];
    [self updateLabel:_profileViewLabel notificationCount:notification.profileViews message:@"%lu people viewed your profile"];
    
    for (UILabel *label in _detailLabels)
    {
        label.highlighted = !notification.read;
    }
    
    [self layoutSubviews];
}

+ (CGFloat)heightForCellWithNotification:(BBNotificationAggregate *)notification
{
    return ((kNotificationDetailsLabelHeight) * notification.numNotificationTypes) + kNotificationDetailsLabelPadding * 2;
}

@end
