//
//  BBPostCellButton.h
//  Boredat
//
//  Created by David Pickart on 6/18/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBPostCellButton : UIButton


@property (nonatomic, readwrite) BOOL disabled;
@property (nonatomic, readwrite) BOOL clicked;
@property (strong, nonatomic, readwrite) UIImage *defaultImage;
@property (strong, nonatomic, readwrite) UIImage *clickedImage;
@property (strong, nonatomic, readwrite) UIColor *clickedColor;

@end
