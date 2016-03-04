//
//  BBPageButton.h
//  Boredat
//
//  Created by Anton Kolosov on 1/27/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PageButtonTypeNumber = 0,
    PageButtonTypeFirst,
    PageButtonTypePrevious,
    PageButtonTypeNext
} PageButtonType;

@interface BBPageButton : UIButton

@property (nonatomic, readwrite) PageButtonType pageButtonType;
@property (nonatomic, readwrite) NSInteger pageNumber;

@end
