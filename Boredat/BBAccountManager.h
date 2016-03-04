//
//  BBAccountManager.h
//  Boredat
//
//  Created by David Pickart on 2/20/16.
//  Copyright © 2016 BoredAt LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBAccountManager : NSObject

// Wrapper for storing user info.


// ACCESS
+ (NSDictionary *)userWithUserID:(NSString *)userID;
+ (NSString *)currentUserID;
+ (NSString *)currentPassword;
+ (NSDictionary *)currentUser;
+ (void)clearCurrentUser;

// SWITCH
+ (NSArray *)currentAccounts;
+ (void)setCurrentAccounts:(NSArray *)accounts;
+ (int)currentAccountIndex;
+ (void)setCurrentAccountIndex:(int)index;

// MUTATE
+ (void)addAccountToCurrentUserWithUserID:(NSString *)userID andPassword:(NSString *)password;
+ (void)setCurrentUser:(NSDictionary *)user;
+ (void)saveCurrentUser;

@end