//
//  BBSettingsController.m
//  Boredat
//
//  Created by David Pickart on 2/24/15.
//  Copyright (c) 2015 Boredat LLC. All rights reserved.
//

#import "BBAccountSwitcherController.h"
#import "BBAccountManager.h"
#import "BBApplicationSettings.h"
#import "BBFacade.h"
#import "UIKit+Extensions.h"

@interface BBAccountSwitcherController () <UITableViewDataSource,
                                           UITableViewDelegate,
                                           UIAlertViewDelegate>
{
    NSMutableArray *_accounts;
    int _currentAccountIndex;
}

@property UITableView *tableView;

- (void)assembleNavigationBar;

@end


@implementation BBAccountSwitcherController


- (void)viewDidLoad {
    
    _facade = [BBFacade sharedInstance];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    self.view = _tableView;
    
    _currentAccountIndex = [BBAccountManager currentAccountIndex];
    
    [self reloadAccounts];
    [self assembleNavigationBar];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_tableView reloadData];    
}

- (void)assembleNavigationBar
{
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setTitle: @"Switch Accounts" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:[BBApplicationSettings fontForKey:kFontTitle]];
    [titleButton sizeToFit];
    
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                       target:self action:@selector(onAddButton:)];
    
    [self.navigationItem setRightBarButtonItem:addButtonItem];
    
    [self.navigationItem setTitleView:titleButton];
}


#pragma mark -
#pragma mark UITableViewDelegate callbacks

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != _currentAccountIndex)
    {
        _currentAccountIndex = (int)indexPath.row;
        [BBAccountManager setCurrentAccountIndex:_currentAccountIndex];
        [_delegate accountControllerDidSelectAccount:self];
        
    }

    // Unselect row when finished
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Main and current account can't be deleted
    return (indexPath.row != _currentAccountIndex && indexPath.row != 0);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete account from local array
        [_accounts removeObjectAtIndex:indexPath.row];
        
        // Delete row from table
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        // Delete account from main dictionary
        [BBAccountManager setCurrentAccounts:[NSArray arrayWithArray:_accounts]];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_accounts count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"Accounts";
            
        case 1:
            return nil;
            
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    cell.textLabel.font = [BBApplicationSettings fontForKey:kFontSettingsButton];
    
    cell.textLabel.text = [_accounts objectAtIndex:indexPath.row];
    
    if (indexPath.row == _currentAccountIndex)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void)reloadAccounts
{
    _accounts = [NSMutableArray arrayWithArray:[BBAccountManager currentAccounts]];
}

- (void)onAddButton:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Add account"
                                message:nil
                                preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Username";
     }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Password";
         textField.secureTextEntry = YES;
     }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
    [alert addAction:cancelAction];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *username = alert.textFields.firstObject;
                                   UITextField *password = alert.textFields.lastObject;
                                   [self addAccountWithUserID:username.text andPassword:password.text];
                               }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)addAccountWithUserID:(NSString *)userID andPassword:(NSString *)password
{
    if (userID.length > 0 && password.length > 0)
    {
        // Confirm new account by logging in with it
        [_facade loginWithUserID:userID password:password block:^(NSError *error) {
            if (error != nil)
            {
                [self showAlertViewWithError:error];
            }
            else
            {
                // If successful, add it to accounts
                [BBAccountManager addAccountToCurrentUserWithUserID:userID andPassword:password];
                
                [self switchBackToCurrentAccount];
                
                // Animate if necessary
                NSInteger numAccounts = [_accounts count];
                [self reloadAccounts];
                if (numAccounts < [_accounts count])
                {
                    [_tableView beginUpdates];
                    NSIndexPath *insertPath = [NSIndexPath indexPathForRow:[_accounts count] - 1 inSection:0];
                    [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:insertPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [_tableView endUpdates];
                }

            }
        }];
    }
}

- (void)switchBackToCurrentAccount
{
    // After confirming a new account, log back into previous account
    NSString *userID = [BBAccountManager currentUserID];
    NSString *password = [BBAccountManager currentPassword];
    
    [_facade loginWithUserID:userID password:password block:^(NSError *error) {
        if (error == nil)
        {
            [_facade userInfoWithBlock:^(BBUser *user, NSError *error1) {
                if (error1 == nil)
                {
                }
            }];
        }
    }];
}

@end
