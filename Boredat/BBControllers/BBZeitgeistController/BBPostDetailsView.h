//
//  BBPostDetailsView.h
//  Boredat
//
//  Created by Anton Kolosov on 2/4/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@interface BBPostDetailsView : UIView

@property (nonatomic, readwrite) NSUInteger agrees;
@property (nonatomic, readwrite) NSUInteger disagrees;
@property (nonatomic, readwrite) NSUInteger news;
@property (nonatomic, readwrite) NSInteger replies;

@property (nonatomic, readwrite) NSUInteger iconRows;

@end
