//
//  BBTableViewController.h
//  Boredat
//
//  Created by David Pickart on 29/10/2015.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import "BBModel.h"
#import "BBPost.h"
#import "BBPostCell.h"
#import <UIKit/UIKit.h>
#import "BBViewController.h"

@interface BBTableViewController : BBViewController <BBPostCellDelegate,
                                                     BBModelDelegate,
                                                     UITableViewDelegate,
                                                     UITableViewDataSource>

@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, strong, readwrite) BBModel *tableViewModel;

@property (nonatomic, readwrite) NSInteger mainSection;

@property (nonatomic, readwrite) NSInteger selectedPostIndex;
@property (nonatomic, readwrite) NSInteger expandedPostIndex;

- (void)expandCellAtIndex:(NSInteger)postIndex;
- (void)closeCell;
- (void)resetView;
- (void)scrollToBottom;
- (NSInteger)lastIndex;

@end