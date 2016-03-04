//
//  BBPageButton.m
//  Boredat
//
//  Created by Anton Kolosov on 1/27/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBPageButton.h"
#import "BBApplicationSettings.h"

@implementation BBPageButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPageNumber:(NSInteger)pageNumber
{
    _pageNumber = pageNumber;
    [self setTitle:[NSString stringWithFormat:@"%ld", (long)_pageNumber] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected
{
    self.titleLabel.font = (selected == YES) ? [BBApplicationSettings fontForKey:kFontPageSelected] : [BBApplicationSettings fontForKey:kFontPageUnselected];
}

@end
