//
//  BBPostsTableView.h
//  Boredat
//
//  Created by Dmitry Letko on 5/22/12.
//  Copyright (c) 2012 Scand Ltd. All rights reserved.
//

@protocol BBPostsTableViewDelegate;


@interface BBPostsTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
@property (assign, nonatomic, readwrite) id<BBPostsTableViewDelegate> bbDelegate;
@property (copy, nonatomic, readwrite) NSArray *posts;

@end
