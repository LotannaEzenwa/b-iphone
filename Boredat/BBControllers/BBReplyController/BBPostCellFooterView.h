//
//  BBPostCellFooterView.h
//  Boredat
//
//  Created by Dmitry Letko on 1/25/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@class BBPostCellFooterView;
@class BBPostCellButton;

@protocol BBPostCellFooterViewDelegate <NSObject>

- (void)footerViewDidPressAgree:(BBPostCellFooterView *)view;
- (void)footerViewDidPressDisagree:(BBPostCellFooterView *)view;
- (void)footerViewDidPressNewsworthy:(BBPostCellFooterView *)view;
- (void)footerViewDidPressReply:(BBPostCellFooterView *)view;

@end

@interface BBPostCellFooterView : UIView

@property (weak, nonatomic, readwrite) id<BBPostCellFooterViewDelegate> delegate;
@property (strong, nonatomic, readwrite) BBPostCellButton *agreeButton;
@property (strong, nonatomic, readwrite) BBPostCellButton *disagreeButton;
@property (strong, nonatomic, readwrite) BBPostCellButton *newsworthyButton;
@property (strong, nonatomic, readwrite) BBPostCellButton *replyButton;
@property (strong, nonatomic, readwrite) BBPostCellButton *anonButton;

@end
