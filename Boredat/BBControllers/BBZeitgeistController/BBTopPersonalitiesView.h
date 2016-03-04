//
//  BBTopPersonalitiesController.h
//  Boredat
//
//  Created by David Pickart on 3/1/15.
//  Copyright (c) 2015 Boredat LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBTopPersonalitiesViewDelegate <NSObject>

- (void)tapOnTopUserAvatarAtIndex:(int)index;

@end

@interface BBTopPersonalitiesView : UIView

@property (weak, nonatomic, readwrite) id<BBTopPersonalitiesViewDelegate> delegate;

- (void)setImages:(NSArray *)imagesArray;

@end
