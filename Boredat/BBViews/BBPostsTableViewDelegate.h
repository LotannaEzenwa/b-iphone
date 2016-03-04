//
//  BBPostsTableViewDelegate.h
//  Boredat
//
//  Created by Dmitry Letko on 5/22/12.
//  Copyright (c) 2012 Scand Ltd. All rights reserved.
//

@class BBPostsTableView;
@class BBPost;


@protocol BBPostsTableViewDelegate <NSObject>
@optional

- (void)tableView:(BBPostsTableView *)tableView didSelectPost:(BBPost *)post;

@end
