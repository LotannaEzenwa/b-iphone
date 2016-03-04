//
//  BBAccountManager.m
//  Boredat
//
//  Created by David Pickart on 2/20/16.
//  Copyright © 2016 BoredAt LLC. All rights reserved.
//

#import "BBAccountManager.h"
#import "FDKeychain.h"

NSString * const kAMUsers = @"AMusers";
NSString * const kAMCurrentUser = @"AMcurrentUser";

NSString * const kAMName = @"AMname";
NSString * const kAMService = @"AMservice";
NSString * const kAMAccounts = @"AMaccounts";
NSString * const kAMAccountIndex = @"AMaccountIndex";

/* User IDs are stored in NSUserDefaults, passwords are stored in keychain.
 
 Here's what NSUserDefaults looks like:
 
 {
    currentUser: {
        accounts: ["foo","bar"...],
        accountIndex: 0,
        name: "foo"
    },
    users: {
         "foo": {
            accounts: ["foo","bar"...],
            accountIndex: 0,
            name: "foo"
         },
         "baz": {
            accounts: ["baz","qux"...],
            accountIndex: 0,
            name: "baz"
         }
    }
 }
 
 The "name" value is used to find the correct place in users to save currentUser when it's edited.
 
*/

@implementation BBAccountManager

+ (void)addAccountToCurrentUserWithUserID:(NSString *)userID andPassword:(NSString *)password
{
    // Add account to keychain
    [FDKeychain saveItem: password
                  forKey: userID
              forService: kAMService // <- not important
                   error: nil];
    
    if ([self currentUser] == nil)
    {
        // Create new user
        NSString *name = userID;
        NSArray *accounts = [NSArray new];
        NSNumber *accountIndex = [NSNumber numberWithInt:0];
        NSDictionary *user = [NSDictionary dictionaryWithObjectsAndKeys: name, kAMName, accounts, kAMAccounts,  accountIndex, kAMAccountIndex, nil];
        [self setCurrentUser:user];
    }
    
    NSMutableDictionary *mutableUser = [NSMutableDictionary dictionaryWithDictionary:[self currentUser]];
    NSMutableArray *accounts = [NSMutableArray arrayWithArray:[mutableUser objectForKey:kAMAccounts]];
    
    // Check if account already exists for user
    for (NSString *account in accounts)
    {
        if ([account isEqualToString:userID])
        {
            return;
        }
    }
    
    [accounts addObject:userID];
    [mutableUser setObject:accounts forKey:kAMAccounts];
    
    // Convert back to NSDictionary and set to current user
    [self setCurrentUser:[NSDictionary dictionaryWithDictionary:mutableUser]];
    [self saveCurrentUser];
}

+ (NSDictionary *)userWithUserID:(NSString *)userID
{
    NSDictionary *users = [[NSUserDefaults standardUserDefaults] objectForKey:kAMUsers];
    return [users objectForKey:userID];
}

+ (NSString *)currentUserID
{
    NSArray *accounts = [[self currentUser] objectForKey:kAMAccounts];
    return [accounts objectAtIndex:[self currentAccountIndex]];
}

+ (NSString *)currentPassword
{
    return [self passwordForUserID:[self currentUserID]];
}

+ (NSString *)passwordForUserID:(NSString *)userID
{
    return [FDKeychain itemForKey: userID
                       forService: kAMService
                            error: nil];
}

+ (NSArray *)currentAccounts
{
    return [[self currentUser] objectForKey:kAMAccounts];
}

+ (void)setCurrentAccounts:(NSArray *)accounts
{
    NSMutableDictionary *mutableUser = [NSMutableDictionary dictionaryWithDictionary:[self currentUser]];
    [mutableUser setObject:accounts forKey:kAMAccounts];
    [self setCurrentUser:[NSDictionary dictionaryWithDictionary:mutableUser]];
    [self saveCurrentUser];
}

+ (int)currentAccountIndex
{
    return [self accountIndexForUser:[self currentUser]];
}

+ (void)setCurrentAccountIndex:(int)index
{
    NSMutableDictionary *mutableUser = [NSMutableDictionary dictionaryWithDictionary:[self currentUser]];
    [mutableUser setObject:[NSNumber numberWithInt:index] forKey:kAMAccountIndex];
    [self setCurrentUser:[NSDictionary dictionaryWithDictionary:mutableUser]];
    [self saveCurrentUser];
}

+ (NSDictionary *)currentUser
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kAMCurrentUser];
}
     
+ (void)setCurrentUser:(NSDictionary *)user
{
    [[NSUserDefaults standardUserDefaults] setObject:user forKey:kAMCurrentUser];
}

+ (void)saveCurrentUser
{
    NSMutableDictionary *mutableUsers = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:kAMUsers]];
    NSDictionary *currentUser = [self currentUser];
    [mutableUsers setObject:currentUser forKey:[currentUser objectForKey:kAMName]];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:mutableUsers] forKey:kAMUsers];
}

+ (void)clearCurrentUser
{
    [self setCurrentUser:nil];
}

+ (int)accountIndexForUser:(NSDictionary *)user
{
    return [[user objectForKey:kAMAccountIndex] intValue];
}

@end
