//
//  BBTopPersonalitiesView.h
//  Boredat
//
//  Created by Anton Kolosov on 10/9/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@protocol BBTopPersonalitiesAvatarViewDelegate <NSObject>

- (void)tapOnTopUserAvatarAtIndex:(int)index;

@end

@interface BBTopPersonalitiesAvatarView : UIView

@property (weak, nonatomic, readwrite) id<BBTopPersonalitiesAvatarViewDelegate> delegate;
@property (strong, nonatomic, readwrite) NSArray *topUsersImages;

@end