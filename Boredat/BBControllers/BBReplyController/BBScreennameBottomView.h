//
//  BBScreennameBottomView.h
//  Boredat
//
//  Created by Dmitry Letko on 1/25/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@protocol BBScreennameBottomViewDelegate <UIAlertViewDelegate>

- (void)tapOnScreennameLabel:(UILabel *)label;

@end

@interface BBScreennameBottomView : UIView
@property (copy, nonatomic, readwrite) NSString *name;
@property (weak, nonatomic, readwrite) id<BBScreennameBottomViewDelegate> delegate;

- (void)setBorderColor:(UIColor *)color;

@end
