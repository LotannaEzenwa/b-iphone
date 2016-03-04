//
//  BBSettingsController.m
//  Boredat
//
//  Created by David Pickart on 2/24/15.
//  Copyright (c) 2015 Boredat LLC. All rights reserved.
//

#import "BBFacade.h"
#import "BBHeartbeatModel.h"
#import "BBSettingsController.h"

#import "BBApplicationSettings.h"

#import "BBNetworkStatisticsCell.h"
#import "BBUsersPlotCell.h"

#import "BBPersonalityController.h"
#import "BBFavoritesController.h"
#import "BBAccountSwitcherController.h"
#import "UIKit+Extensions.h"

typedef enum {
    kHeartbeatSection = 0,
    kAccountSection
} SettingsSectionType;

typedef enum {
    kStatsButtonRow = 0,
    kPlotButtonRow
} HeartbeatButtonRow;

typedef enum {
    kProfileButtonRow = 0,
//    kFavoritesButtonRow,
    kSwitchAccountsButtonRow,
    kLogoutButtonRow
} AccountButtonRow;

@interface BBSettingsController () <UITableViewDataSource,
                                    UITableViewDelegate,
                                    BBModelDelegate,
                                    BBAccountSwitcherControllerDelegate>
{
    BOOL _plotCellSelected;
}

@property (strong, nonatomic, readwrite) UITableView *tableView;

- (void)assembleNavigationBar;
- (void)presentAccountSwitcher;

@end


@implementation BBSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.view = self.tableView;
    
    _heartbeatModel.delegate = self;

    [self assembleNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _plotCellSelected = NO;
    if ([_heartbeatModel hasData] == NO)
    {
        [_heartbeatModel updateDataForced:YES];
    }

    [self.tableView reloadData];
}

- (void)assembleNavigationBar
{
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setTitle: @"Settings" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:[BBApplicationSettings fontForKey:kFontTitle]];
    [titleButton sizeToFit];
    [self.navigationItem setTitleView:titleButton];
    
    // Hide back button text in pushed views
    self.navigationItem.title = @"";
}

- (void)presentPersonalityControllerWithPersonality:(BBPersonality *)personality
{
    BBPersonalityController *controller = [[BBPersonalityController alloc] initWithPersonality:personality];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma mark UITableViewDelegate callbacks

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case kHeartbeatSection:
            if (_heartbeatModel.statsAvailable == NO) {
                // For filler text
                return 115.0f;
            }
            else
            {
                switch (indexPath.row)
                {
                    case kStatsButtonRow:
                        return 80.0f;
                        
                    case kPlotButtonRow:
                        return _plotCellSelected == YES ? 240.0f : 35.0f;
                        
                    default:
                        break;
                }
            }
            
        case kAccountSection:
            return 50.0f;
            
        default:
            break;
    }

    return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case kHeartbeatSection:
            // Expand to show plot
            _plotCellSelected = !_plotCellSelected;
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
            break;
            
        case kAccountSection:
        {
            switch (indexPath.row)
            {
                case kProfileButtonRow:
                {
                    BBPersonality *personality = [BBPersonality new];
                    personality.personalityName = [BBFacade sharedInstance].user.personalityName;
                    [self presentPersonalityControllerWithPersonality:personality];
                    break;
                }
                    
//                case kFavoritesButtonRow:
//                {
//                    BBFavoritesController *controller = [BBFavoritesController new];
//                    controller.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:controller animated:YES];
//                    break;
//                }
                    
                case kSwitchAccountsButtonRow:
                    [self presentAccountSwitcher];
                    break;
                    
                case kLogoutButtonRow:
                    [_delegate settingsControllerDidClickOnLogout:self];
                    break;
                    
                default:
                    break;
            }
        }
        default:
            break;
    }
    
    // Unselect row when finished
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case kHeartbeatSection:
            if (_heartbeatModel.statsAvailable == NO)
            {
                // For filler text
                return 1;
            }
            else
            {
                return 2;
            }

        case kAccountSection:
            return 3;
            
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case kHeartbeatSection:
            return @"Heartbeat";
            
        case kAccountSection:
            return @"Account";
            
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case kHeartbeatSection:
            if (_heartbeatModel.statsAvailable == NO)
            {
                UITableViewCell *cell = [UITableViewCell new];
                if (_heartbeatModel.statsConfirmedUnavailable)
                {
                    return [BBPostCell fillerCellWithText:@"Become a prolific poster to unlock the heartbeat feature!"];
                }
                else
                {
                    // Spinny thing
                    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    activityView.center = CGPointMake(self.view.frame.size.width/2, 57);
                    [activityView startAnimating];
                    [cell addSubview:activityView];
                }
                return cell;
            }
            else
            {
                switch (indexPath.row)
                {
                    case kStatsButtonRow:
                    {
                        BBNetworkStatisticsCell *cell = [BBNetworkStatisticsCell new];
                        cell.todayPostsLabel.text = [NSString stringWithFormat:@"Today \n %@", _heartbeatModel.todayPosts];
                        cell.yesterdayPostsLabel.text = [NSString stringWithFormat:@"Yesterday \n %@", _heartbeatModel.yesterdayPosts];
                        cell.totalPostsLabel.text = [NSString stringWithFormat:@"All Time \n %@", _heartbeatModel.totalPosts];
                        return cell;
                    }
                        
                    case kPlotButtonRow:
                    {
                        BBUsersPlotCell *cell = [BBUsersPlotCell new];
                        [cell usersOnline:_heartbeatModel.usersOnline andUsersToday:_heartbeatModel.usersToday];
                        cell.uniqueUsersLabel.text = [NSString stringWithFormat:@"Unique logins in 24 hours: %@", _heartbeatModel.usersUnique];
                        cell.usersPlot.yAxisPoints = _heartbeatModel.usersPointsPlot;
                        cell.usersPlot.maxX = [_heartbeatModel.usersPointsPlot count];
                        int maxValue = [[_heartbeatModel.usersPointsPlot valueForKeyPath:@"@max.intValue"] intValue];
                        cell.usersPlot.maxY = maxValue;
                        
                        return cell;
                    }
                        
                    default:
                        return nil;
                }
            }

        case kAccountSection:
        {
            UITableViewCell *cell = [UITableViewCell new];
            cell.textLabel.font = [BBApplicationSettings fontForKey:kFontSettingsButton];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            switch (indexPath.row)
            {
                case kProfileButtonRow:
                    cell.textLabel.text = @"Profile";
                    break;
                    
//                case kFavoritesButtonRow:
//                    cell.textLabel.text = @"Favorites";
//                    break;

                case kSwitchAccountsButtonRow:
                    cell.textLabel.text = @"Switch accounts";
                    break;
                
                case kLogoutButtonRow:
                    cell.textLabel.text = @"Logout";
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    break;
                    
                default:
                    break;
            }
            return cell;
        }
        default:
            return nil;
    }
}

#pragma mark
#pragma mark Account switching

- (void)presentAccountSwitcher
{
    BBAccountSwitcherController *controller = [BBAccountSwitcherController new];
    controller.delegate = self;
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)accountControllerDidSelectAccount:(BBAccountSwitcherController *)controller
{
    [_delegate settingsControllerDidSwitchAccounts:self];
}

#pragma mark -
#pragma mark BBHeartbeatDelegate callbacks

- (void)modelDidUpdateData:(id)model
{
    // Update plot
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kPlotButtonRow inSection:kHeartbeatSection];
    BBUsersPlotCell *cell = (BBUsersPlotCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.usersPlot.yAxisPoints = _heartbeatModel.usersPointsPlot;
    cell.usersPlot.maxX = [_heartbeatModel.usersPointsPlot count];
    int maxValue = [[_heartbeatModel.usersPointsPlot valueForKeyPath:@"@max.intValue"] intValue];
    cell.usersPlot.maxY = maxValue;
    
    [self.tableView reloadData];
}

- (void)modelDidRecieveError:(id)model error:(NSError *)error
{
    [self showAlertViewWithError:error];
}

@end
