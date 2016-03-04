//
//  BBZeitgeistController.m
//  Boredat
//
//  Created by Dmitry Letko on 1/31/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBZeitgeistController.h"

#import "UIKit+Extensions.h"

#import "BBApplicationSettings.h"
#import "BBFacade.h"

#import "BBUserImageFetcher.h"
#import "BBTopPersonalitiesView.h"
#import "BBNews.h"

#import "MgmtUtils.h"
#import "BBReplyController.h"
#import "BBPersonalityController.h"

#import "BBPostCell.h"
#import "BBPostDetailsView.h"
#import "BBPostCellFooterView.h"
#import "BBPostCellButton.h"
#import "BBSegmentedControl.h"
#import "BBZeitgeistModel.h"


@interface BBZeitgeistController () <BBTopPersonalitiesViewDelegate>
{
    BBZeitgeistModel *_zeitgeistModel;
}

@property (strong, nonatomic, readwrite) BBTopPersonalitiesView *topPersonalitiesView;
@property (strong, nonatomic, readwrite) NSArray *personalitiesImages;
@property BBSegmentedControl *segmentedControl;

- (void)assembleNavigationBar;

@end


@implementation BBZeitgeistController

#pragma mark -
#pragma mark lifecycle

- (void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Top personalities view
    _topPersonalitiesView = [BBTopPersonalitiesView new];
    _topPersonalitiesView.delegate = self;
    
    // Segmented controller
    _segmentedControl = [BBSegmentedControl new];
    [_segmentedControl addTarget:self action:@selector(segmentedControlDidChangeSelectedSegmentIndex:) forControlEvents:UIControlEventValueChanged];
    [_segmentedControl setButtonsWithNames:@[@"Newsworthy",
                                                   @"Best", @"Worst"]];

    // Table view
    self.tableView = [UITableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[BBPostCell class] forCellReuseIdentifier:@"postCell"];
    
    // Remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_topPersonalitiesView];
    [self.view addSubview:_segmentedControl];
    [self.view addSubview:self.tableView];
    
    [self configureConstraints];

}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    _zeitgeistModel = (BBZeitgeistModel *)self.tableViewModel;
    _zeitgeistModel.delegate = self;
	
    [self assembleNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _segmentedControl.tintColor = [[BBFacade sharedInstance] currentBoardColor];
    
    if (_zeitgeistModel.hasData)
    {
        [_topPersonalitiesView setImages:_zeitgeistModel.topPersonalityImages];
    }
    else
    {
        [_zeitgeistModel updateDataForced:YES];
    }
    
    [self.tableView reloadData];
}

- (void)resetView
{
    [_segmentedControl setSelectedSegmentIndex:0];
    [self segmentedControlDidChangeSelectedSegmentIndex:_segmentedControl];
}

- (void)configureConstraints
{
    [_topPersonalitiesView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_segmentedControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];

    // Top personalities view
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_topPersonalitiesView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_topPersonalitiesView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_topPersonalitiesView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_topPersonalitiesView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:0.0
                                                           constant:70.0f]];
    
    // Segment view
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_segmentedControl
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_segmentedControl
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_topPersonalitiesView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:10.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_segmentedControl
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:_segmentedControl.frame.size.height]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_segmentedControl
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0.0f]];

    // Table view
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_segmentedControl
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:10.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0.0f]];
}

#pragma mark -
#pragma mark private

- (void)assembleNavigationBar
{
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setTitle: @"Zeitgeist" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:[BBApplicationSettings fontForKey:kFontTitle]];
    [titleButton sizeToFit];
   
    [self.navigationItem setTitleView:titleButton];
    
    // Hide back button text in pushed views
    self.navigationItem.title = @"";
}

#pragma mark -
#pragma mark UITableViewDataSource 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // If not loaded, one filler cell
    return ([_zeitgeistModel numberOfObjects] == 0) ? 1 : [_zeitgeistModel numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Show spinner if posts are still loading
    if ([_zeitgeistModel numberOfObjects] == 0) {
        return [BBPostCell fillerCell];
    }
    
    BBPost *post = [_zeitgeistModel objectAtIndex: indexPath.row];
    BBPostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"postCell" forIndexPath:indexPath];
    
    [cell formatWithPost:post showParent:YES];
    cell.delegate = self;
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_zeitgeistModel numberOfObjects] == 0)
    {
        return [BBPostCell heightOfFillerCell];
    }
    
    BBPost *post = [_zeitgeistModel objectAtIndex:indexPath.row];
    return [BBPostCell heightForCellWithPost:post expanded:(indexPath.row == self.expandedPostIndex) showParent:YES];
}

#pragma mark -
#pragma mark BBTopPersonalitiesViewDelegate

- (void)tapOnTopUserAvatarAtIndex:(int)index
{
    BBPersonality *personality = [_zeitgeistModel.topPersonalities objectAtIndex:index];
    [self presentPersonalityControllerWithPersonality:personality];
}

#pragma mark -
#pragma mark GUI Callbacks

- (void)segmentedControlDidChangeSelectedSegmentIndex:(id)control
{
    // Switch to correct section
    switch (_segmentedControl.selectedSegmentIndex)
    {
        case 0:
            [_zeitgeistModel switchToSection:kZeitgeistSectionNewsworthy];
            break;
        case 1:
            [_zeitgeistModel switchToSection:kZeitgeistSectionBest];
            break;
        case 2:
            [_zeitgeistModel switchToSection:kZeitgeistSectionWorst];
            break;
        default:
            break;
    }
    
    self.expandedPostIndex = -1;
    [self.tableView reloadData];
    
    // Scroll to top
    [self.tableView setContentOffset:CGPointZero animated:NO];
}

#pragma mark -
#pragma mark BBZeitgeistModelDelegate callbacks

- (void)modelDidUpdateData:(id)model
{
    if ([_zeitgeistModel.topPersonalityImages count] > 0)
    {
        [_topPersonalitiesView setImages:_zeitgeistModel.topPersonalityImages];
    }

    [self.tableView reloadData];
}

@end
