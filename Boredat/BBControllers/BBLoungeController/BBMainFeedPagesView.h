//
//  BBMainFeedPagesView.h
//  Boredat
//
//  Created by Lesha on 7/16/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBPageButton.h"

extern NSInteger const kPagesViewHeight;

@protocol BBMainFeedPagesViewDelegate

- (void)pagesViewClickonPage:(NSInteger)page;

@end

@interface BBMainFeedPagesView : UIView

@property (weak, nonatomic, readwrite) id<BBMainFeedPagesViewDelegate>pageDelegate;
@property (nonatomic, readwrite) NSInteger currentPage;
@property (nonatomic, readwrite) NSInteger pages;

@property (nonatomic, readwrite) NSInteger currentIndex;

- (void)findButtonWithLocation:(CGPoint)touchPoint;

@end
