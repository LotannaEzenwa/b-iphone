//
//  BBApplicationDelegate.m
//  Boredat
//
//  Created by Dmitry Letko on 5/10/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBApplicationDelegate.h"
#import "BBAccountManager.h"
#import "BBLoginController.h"
#import "BBMainFeedController.h"
#import "BBMainFeedModel.h"
#import "BBNavigationController.h"
#import "BBNotificationController.h"
#import "BBZeitgeistController.h"
#import "BBSettingsController.h"

#import "BBFacade.h" 
#import "BBNotificationRelay.h"
#import "BBNotificationRelaySubscriber.h"

#import "BBApplicationSettings.h"

#import "MgmtUtils.h"

#import "BBNotificationModel.h"
#import "BBHeartbeatModel.h"

#import "NSFoundation+Extensions.h"

#import "KeychainItemWrapper.h"
#import "BBZeitgeistModel.h"

@interface BBApplicationDelegate () <UITabBarControllerDelegate,
                                     BBLoginControllerDelegate,
                                     BBMainFeedControllerDelegate,
                                     BBSettingsControllerDelegate,
                                     BBNotificationRelaySubscriber>

{
    NSInteger _countOfNotifications;
}

@property (strong, nonatomic, readwrite) UINavigationController *mainController;
@property (strong, nonatomic, readwrite) UITabBarController *tabBarController;
@property (strong, nonatomic, readwrite) BBLoginController *loginController;
@property (strong, nonatomic, readwrite) NSTimer *updateLoopTimer;

@property (strong, nonatomic, readwrite) BBMainFeedController *mainFeedController;
@property (strong, nonatomic, readwrite) BBMainFeedModel *mainFeedModel;

@property (strong, nonatomic, readwrite) BBNotificationController *notificationController;
@property (strong, nonatomic, readwrite) BBNotificationRelay *notificationRelay;
@property (strong, nonatomic, readwrite) BBNotificationModel *notificationModel;

@property (strong, nonatomic, readwrite) BBZeitgeistController *zeitgeistController;
@property (strong, nonatomic, readwrite) BBZeitgeistModel *zeitgeistModel;

@property (strong, nonatomic, readwrite) BBSettingsController *settingsController;
@property (strong, nonatomic, readwrite) BBHeartbeatModel *heartbeatModel;

@property (strong, nonatomic, readwrite) BBFacade *facade;
@property (strong, nonatomic, readwrite) KeychainItemWrapper *passwordItem;

- (void)assembleTabBarController;
- (void)updateColors;
- (void)switchToLoginController;
- (void)switchToTabBarController;
//- (void)startUpdateLoop;
//- (void)stopUpdateLoop;

@end


@implementation BBApplicationDelegate


#pragma mark -
#pragma mark UIApplicationDelegate callbacks

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Clear old user defaults if necessary
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"AMVersion"] == nil) {
        
        [NSUserDefaults resetStandardUserDefaults];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"AMVersion"];
    
    _facade = [BBFacade sharedInstance];
    
    _mainFeedModel = [BBMainFeedModel new];
    
    _notificationRelay = [BBNotificationRelay new];
    [_notificationRelay subscribe:self];
    _notificationModel = [BBNotificationModel new];
    _countOfNotifications = 0;
    
    _zeitgeistModel = [BBZeitgeistModel new];
    _heartbeatModel = [BBHeartbeatModel new];
    
    UIScreen *screen = [UIScreen mainScreen];    
	UIWindow *window = [[UIWindow alloc] initWithFrame:screen.bounds];
    
    [self setWindow:window];
    
    _mainController = [UINavigationController new];
    _mainController.view.backgroundColor = [UIColor whiteColor];
    
    [self assembleTabBarController];
    
    _loginController = [BBLoginController new];
    _loginController.delegate = self;
    
    [_mainController pushViewController:_loginController animated:NO];
    [self.window setRootViewController:_mainController];

    [window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    [BBAccountManager saveCurrentUser];
//    NSString *userID = [_passwordItem objectForKey:(__bridge id)kSecAttrAccount];
//    NSString *password = [_passwordItem objectForKey:(__bridge id)kSecValueData];
//    [BBApplicationSettings saveUserDetailsWithUser:userID andPassword:password];
//    [BBApplicationSettings clearUserDetails];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // If user is already logged in,
    // fetch new posts if enough time has passed
    if (_facade.user != nil) {
        NSDate *now = [NSDate date];
        NSDate *lastClosed =  (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"lastClosed"];
    
        if (lastClosed != nil) {
            NSTimeInterval minutesPassed = [now timeIntervalSinceDate:lastClosed]/60.0;

            if (minutesPassed > 5)
            {
                [_mainFeedModel clearData];
                [_mainFeedController resetView];
                [_mainFeedModel updateDataForced:NO];
            }
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Stop requests when app is in the background, save the time
    [_facade cancelAllRequests];

    NSDate *lastClosed = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:lastClosed forKey:@"lastClosed"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark private

-(void)assembleTabBarController
{
    UITabBarController *tabBarController = [UITabBarController new];
    [tabBarController.tabBar setTranslucent:NO];
    [tabBarController setDelegate:self];
    
    // Init mainFeed
    UINavigationController *mainFeedWrapper = [BBNavigationController new];
    [mainFeedWrapper.navigationBar setTranslucent:NO];
    _mainFeedController = [BBMainFeedController new];
    _mainFeedController.tableViewModel = _mainFeedModel;
    mainFeedWrapper.tabBarItem.image = [UIImage imageNamed:@"mainfeed_icon.png"];
    mainFeedWrapper.tabBarItem.title = @"Main Feed";
    [mainFeedWrapper pushViewController:_mainFeedController animated:NO];
    _mainFeedController.delegate = self;
    
    // Init notifications
    UINavigationController *notificationWrapper = [BBNavigationController new];
    [notificationWrapper.navigationBar setTranslucent:NO];
    _notificationController = [BBNotificationController new];
    _notificationController.tableViewModel = _notificationModel;
    notificationWrapper.tabBarItem.image = [UIImage imageNamed:@"notifications_icon.png"];
    notificationWrapper.tabBarItem.title = @"Notifications";
    [notificationWrapper pushViewController:_notificationController animated:NO];
    
    // Init zeitgeist
    UINavigationController *zeitgeistWrapper = [BBNavigationController new];
    [zeitgeistWrapper.navigationBar setTranslucent:NO];
    _zeitgeistController = [BBZeitgeistController new];
    _zeitgeistController.tableViewModel = _zeitgeistModel;
    zeitgeistWrapper.tabBarItem.image = [UIImage imageNamed:@"zeitgeist_icon.png"];
    zeitgeistWrapper.tabBarItem.title = @"Zeitgeist";
    [zeitgeistWrapper pushViewController:_zeitgeistController animated:NO];
    
    // Init settings
    UINavigationController *settingsWrapper = [BBNavigationController new];
    [settingsWrapper.navigationBar setTranslucent:NO];
    _settingsController = [BBSettingsController new];
    _settingsController.heartbeatModel = _heartbeatModel;
    settingsWrapper.tabBarItem.image = [UIImage imageNamed:@"settings_icon.png"];
    settingsWrapper.tabBarItem.title = @"Settings";
    [settingsWrapper pushViewController:_settingsController animated:NO];
    _settingsController.delegate = self;
    
    // Add items to controller
    tabBarController.viewControllers = @[mainFeedWrapper, notificationWrapper, zeitgeistWrapper, settingsWrapper];
    _tabBarController = tabBarController;
}

- (void)updateColors
{
    // Change selection tint
    _tabBarController.tabBar.tintColor = [_facade currentBoardColor];
    
    // Change border color
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, _tabBarController.view.frame.size.width, 0.5f);
    topBorder.backgroundColor = [[_facade currentBoardLightColor] CGColor];
    [_tabBarController.tabBar.layer addSublayer:topBorder];
}

- (void)switchToLoginController
{
    [_mainController popToRootViewControllerAnimated:YES];
}

- (void)switchToTabBarController
{
    [_tabBarController setSelectedIndex:0];
    [_mainController pushViewController:_tabBarController animated:YES];
}

- (void)resetViewControllers
{
    [_notificationController resetView];
    [_zeitgeistController resetView];
}

#pragma mark -
#pragma mark tab bar controller callbacks

- (void)tabBarController:(UITabBarController*)tabBarController didSelectViewController:(UINavigationController*)controller
{
    // Get index of newly selected item
    NSInteger index = [self.tabBarController.viewControllers indexOfObjectIdenticalTo:controller];
    
    // If the notification controller is selected, clear notifications badge and mark as read
    if (index == 1)
    {
        [[_tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:nil];
        [_facade notificationsMarkAsReadWithBlock:nil];
    }
}

#pragma mark -
#pragma mark login controller callbacks

- (void)loginControllerDidLoginSuccessfully:(BBLoginController *)controller
{
    [self updateColors];
    [_mainFeedModel updateDataForced:NO];
//    [self startUpdateLoop];
    [self switchToTabBarController];
}

#pragma mark -
#pragma mark mainFeed controller callbacks

- (void)mainFeedControllerDidSwitchServers:(BBMainFeedController *)controller
{
    [self updateColors];

    [self resetViewControllers];
    [self clearModelData];
    [_notificationModel updateDataForced:NO];
    [_zeitgeistModel updateDataForced:NO];
    [_heartbeatModel updateDataForced:NO];
}

- (void)mainFeedControllerDidLoadFirstPage:(BBMainFeedController *)controller
{
    [_notificationModel updateDataForced:NO];
    [_zeitgeistModel updateDataForced:NO];
    [_heartbeatModel updateDataForced:NO];
}

#pragma mark -
#pragma mark Model Updates

//- (void)startUpdateLoop
//{
//    [_mainFeedModel updateDataForced:NO];
//    _updateLoopTimer = [NSTimer scheduledTimerWithTimeInterval:20.0f
//                                     target:self
//                                   selector: @selector(startUpdateLoop)
//                                   userInfo:nil
//                                    repeats:NO];
//}
//
//- (void)stopUpdateLoop
//{
//    [_updateLoopTimer invalidate];
//}

- (void)clearModelData
{
    [_mainFeedModel clearData];
    [_notificationModel clearData];
    [_zeitgeistModel clearData];
    [_heartbeatModel clearData];
}

#pragma mark -
#pragma mark BBNotificationRelaySubscriber callbacks

- (void)notificationRelayDidUpdateCount:(BBNotificationRelay *)relay
{
    NSInteger newCount = _notificationRelay.countOfNotifications;
    
    if (newCount != _countOfNotifications )
    {
        _countOfNotifications = newCount;
        if (_countOfNotifications > 0)
        {
            [_notificationModel updateDataWithCompletion:^(void) {
                [[_tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%li",(long)_countOfNotifications]];
            } forced:YES];
        }
        else
        {
            [[_tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:nil];
        }
    }
}

#pragma mark -
#pragma mark settings controller callbacks

- (void)settingsControllerDidSwitchAccounts:(BBSettingsController *)controller
{
    [_facade cancelAllRequests];
//    [self stopUpdateLoop];
    [_facade logout];
    [self clearModelData];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector: @selector(switchToLoginController)
                                   userInfo:nil
                                    repeats:NO];
    // Reset all view controllers
    [self assembleTabBarController];
}

- (void)settingsControllerDidClickOnLogout:(BBSettingsController *)controller
{
    [_facade cancelAllRequests];
//    [self stopUpdateLoop];
    [_facade logout];
    
    [BBAccountManager clearCurrentUser];
    [self clearModelData];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector: @selector(switchToLoginController)
                                   userInfo:nil
                                    repeats:NO];
    // Reset all view controllers
    [self assembleTabBarController];
}

@end
