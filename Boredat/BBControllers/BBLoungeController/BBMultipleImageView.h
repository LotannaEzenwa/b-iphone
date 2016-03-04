//
//  BBMultipleImageView.h
//  Boredat
//
//  Created by Dmitry Letko on 1/22/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@interface BBMultipleImageView : UIView
@property (nonatomic, readwrite) NSUInteger count;
@property (nonatomic, readwrite) NSUInteger countMax;
@property (strong, nonatomic, readwrite) UIImage *image;

@end
