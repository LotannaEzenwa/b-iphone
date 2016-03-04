//
//  BBPersonalityController.m
//  Boredat
//
//  Created by David Pickart on 4/30/15.
//  Copyright (c) 2015 Boredat LLC. All rights reserved.
//

#import "BBPersonalityController.h"
#import "BBPersonalityModel.h"
#import "BBPersonalityDetailsView.h"

#import "BBApplicationSettings.h"

#import "BBFacade.h"
#import "BBUserImageFetcher.h"

#import "BBPersonality.h"

#import "BBReplyController.h"
#import "BBSegmentedControl.h"
#import "BBPostCell.h"
#import "BBPostDetailsView.h"
#import "BBPostCellFooterView.h"
#import "BBPostCellButton.h"

@interface BBPersonalityController ()
{
    BBPersonalityModel *_personalityModel;
}

@property (strong, nonatomic, readwrite) BBPersonalityDetailsView *detailsView;
@property BBSegmentedControl *segmentedControl;

-(void)assembleNavigationBar;
-(void)updateHeader;

@end

@implementation BBPersonalityController

- (id)initWithPersonality:(BBPersonality *)personality
{
    self = [self initWithNibName:nil bundle:nil];
    
    if (self != nil)
    {
        self.tableViewModel = [[BBPersonalityModel alloc] initWithPersonality: personality];
        _personalityModel = (BBPersonalityModel *)self.tableViewModel;
        _personalityModel.delegate = self;
        [_personalityModel updateDataForced:NO];
    }
    
    return self;
}

- (void)loadView {
    
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Personality details and stats
    _detailsView = [BBPersonalityDetailsView new];
 
    // Segmented controller
    _segmentedControl = [BBSegmentedControl new];
    [_segmentedControl addTarget:self action:@selector(segmentedControlDidChangeSelectedSegmentIndex:) forControlEvents:UIControlEventValueChanged];
    [_segmentedControl setButtonsWithNames:@[@"Recent",
                                             @"Best", @"Worst"]];
    
    // Table view
    self.tableView = [UITableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[BBPostCell class] forCellReuseIdentifier:@"postCell"];
    
    // Remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    [self.view addSubview:_detailsView];
    [self.view addSubview:_segmentedControl];
    [self.view addSubview:self.tableView];
    
    [self configureConstraints];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self assembleNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _segmentedControl.tintColor = [[BBFacade sharedInstance] currentBoardColor];
    
    [self updateHeader];
}

- (void)assembleNavigationBar
{
    // Set nav bar title
    NSString *postTitleString = @"Personality";
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setTitle: postTitleString forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:[BBApplicationSettings fontForKey:kFontTitle]];
    [titleButton sizeToFit];
    
    [self.navigationItem setTitleView:titleButton];
    
    // Hide back button text in pushed views
    self.navigationItem.title = @"";
    
}


- (void)configureConstraints
{
    [_detailsView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_segmentedControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // Personality details
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detailsView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detailsView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detailsView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detailsView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0.0
                                                           constant:120.0f]];
    
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
                                                             toItem:_detailsView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0f]];
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

- (void)updateHeader
{
    BBPersonality *personality = _personalityModel.personality;
    _detailsView.titleLabel.text = personality.personalityName;
    BBUserImage *userImage = [[BBUserImageFetcher sharedInstance] thumbnailImageWithImageName:personality.image];
    _detailsView.userImage = userImage;
    _detailsView.networkLabel.text = [NSString stringWithFormat:@"@ %@", personality.networkName];
    NSString *postsString = (personality.postCount > 0) ? [NSString stringWithFormat:@"%i", (int)personality.postCount] : @"";
    _detailsView.postsLabel.text = [NSString stringWithFormat:@"Total posts: %@", postsString];
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
    return ([_personalityModel numberOfObjects] == 0) ? 1 : [_personalityModel numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Show spinner if posts are still loading
    if ([_personalityModel numberOfObjects] == 0) {
        return [BBPostCell fillerCell];
    }
    
    BBPost *post = [_personalityModel objectAtIndex:indexPath.row];
    BBPostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"postCell" forIndexPath:indexPath];
    
    [cell formatWithPost:post showParent:YES];
    cell.delegate = self;
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_personalityModel numberOfObjects] == 0)
    {
        return [BBPostCell heightOfFillerCell];
    }
    
    BBPost *post = [_personalityModel objectAtIndex:indexPath.row];
    return [BBPostCell heightForCellWithPost:post expanded:(indexPath.row == self.expandedPostIndex) showParent:YES];
}

#pragma mark -
#pragma mark BBPostCellDelegate

- (void)tapOnAvatarwithPostCell:(id)cell
{
    // Do nothing
}

#pragma mark -
#pragma mark GUI Callbacks

- (void)segmentedControlDidChangeSelectedSegmentIndex:(id)control
{
    // Switch to correct section
    switch (_segmentedControl.selectedSegmentIndex)
    {
        case 0:
            [_personalityModel switchToSection:kPersonalitySectionRecent];
            break;
        case 1:
            [_personalityModel switchToSection:kPersonalitySectionBest];
            break;
        case 2:
            [_personalityModel switchToSection:kPersonalitySectionWorst];
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
#pragma mark BBPersonalityModel callbacks

- (void)modelDidUpdateData:(id)model
{
    [self updateHeader];
    [self.tableView reloadData];
}

@end
