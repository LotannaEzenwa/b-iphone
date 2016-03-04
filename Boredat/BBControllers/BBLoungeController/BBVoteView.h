//
//  BBVoteView.h
//  Boredat
//
//  Created by Dmitry Letko on 1/22/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@interface BBVoteView : UIView
@property (nonatomic, readwrite) NSUInteger number;
@property (nonatomic, readwrite) NSUInteger imagesCountMax;
@property (strong, nonatomic, readwrite) UIImage *image;
@property (strong, nonatomic, readonly) UITextField *textField;

@end
