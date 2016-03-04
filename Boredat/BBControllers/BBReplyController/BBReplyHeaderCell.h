//
//  BBReplyHeaderCell.h
//  Boredat
//
//  Created by Dmitry Letko on 1/31/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@class BBUserImage;

@protocol BBReplyHeaderCellDelegate <NSObject>
@optional

- (void)tapOnAvatarwithHeaderCell:(id)cell;

@end

@interface BBReplyHeaderCell : UITableViewCell
@property (strong, nonatomic, readonly) UILabel *titleLabel;
@property (strong, nonatomic, readonly) UILabel *dateLabel;
@property (strong, nonatomic, readonly) UILabel *networkLabel;
@property (strong, nonatomic, readwrite) BBUserImage *userImage;

@property (weak, nonatomic, readwrite) id<BBReplyHeaderCellDelegate> delegate;


+ (id)cellWithReuseIdentifier:(NSString *)reuseIdentifier;
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (void)configureConstraints;

@end
