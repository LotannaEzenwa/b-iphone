//
//  BBPostCell.h
//  Boredat
//
//  Created by Anton Kolosov on 2/4/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBFacade.h"

@class BBUserImage;
@class BBPostDetailsView;
@class BBPostCellFooterView;
@class BBPost;

extern NSInteger const kPostAvatarHeight;
extern NSInteger const kPostBorderWidth;
extern NSInteger const kPostHeight;
extern NSInteger const kPostExpandedHeight;


@protocol BBPostCellDelegate <NSObject>

- (void)tapOnLink:(NSURL *)url withPostCell:(id)cell;
- (void)tapOnTextWithPostCell:(id)cell;
- (void)tapOnAvatarwithPostCell:(id)cell;
- (void)completeAction:(BBPostAction)action withPostCell:(id)cell;
- (void)postCellDidPressReply:(id)cell;

@end

@interface BBPostCell : UITableViewCell

@property (strong, nonatomic, readwrite) BBUserImage *userImage;
@property (strong, nonatomic, readonly) BBPostDetailsView *detailsView;
@property (strong, nonatomic, readwrite) UITextView *messageView;
@property (strong, nonatomic, readonly) BBPostCellFooterView *footerView;
@property (weak, nonatomic, readwrite) id<BBPostCellDelegate> delegate;


+ (id)cellWithReuseIdentifier:(NSString *)reuseIdentifier;

+ (id)fillerCell;
+ (id)fillerCellWithText:(NSString *)text;
+ (CGFloat)heightOfFillerCell;

- (void)hideAvatarImage:(BOOL)state;
- (void)flashForAction:(BBPostAction)action;

- (void)formatWithPost:(BBPost *)post showParent:(BOOL)showParent;
+ (CGFloat)heightForCellWithPost:(BBPost *)post expanded:(BOOL)expanded showParent:(BOOL)showParent;

@end


