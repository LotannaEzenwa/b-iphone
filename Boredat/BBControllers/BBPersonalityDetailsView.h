//
//  BBPersonalityDetailsView.h
//  Boredat
//
//  Created by David Pickart on 5/13/15.
//  Copyright (c) 2015 Scand Ltd. All rights reserved.
//

@class BBUserImage;

@interface BBPersonalityDetailsView : UIView

@property (strong, nonatomic, readonly) UILabel *titleLabel;
@property (strong, nonatomic, readonly) UILabel *networkLabel;
@property (strong, nonatomic, readonly) UILabel *postsLabel;
@property (strong, nonatomic, readwrite) BBUserImage *userImage;

@end


