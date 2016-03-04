//
//  BBFacade.h
//  Boredat
//
//  Created by Dmitry Letko on 5/21/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBError.h"
#import "BBConsumer.h"
#import "BBPost.h"
#import "BBUser.h"
#import "BBPersonality.h"
#import "BBNetwork.h"
#import "BBNotification.h"
#import "BBNotificationStatistics.h"

#import "BBPostResponse.h"
#import "BBPrivatePost.h"

#import "BBKeychainToken.h"

#import "BBWebViewPlugin.h"
#import "BBCompletionTypes.h"
#import "BBUsersOnlineResponse.h"
#import "BBNetworkStatisticsResponse.h"
#import "BBUsersOnlineInfoPlotResponse.h"

/**
 This constant defines the OAuth callback used by the process of authentication.
 */
extern NSString *const kOAuthCallback;


typedef struct BBFrame {
    NSUInteger page;
    NSUInteger count;
} BBFrame;

static inline BBFrame BBFrameMake(NSUInteger page, NSUInteger count)
{
    BBFrame frame;
    frame.page = page;
    frame.count = count;
    
    return frame;
}


/**
 Provides simple interface to send messages to the Server.
 */

@interface BBFacade : NSObject
@property (copy, nonatomic, readwrite) NSString *server;
@property (copy, nonatomic, readwrite) BBConsumer *consumer;
@property (copy, nonatomic, readwrite) NSString *callback;
@property (strong, nonatomic, readwrite) BBKeychainToken *keychainToken;
@property (strong, nonatomic, readonly) BBUser *user;
@property (nonatomic, readwrite) BOOL postAsAnonymous;
@property (nonatomic, readwrite) BOOL isGlobal;

/**
 A BOOL value indicating the successful authorization of the application.
 Actualy, now it only checks the availability of access token 
 and doesn't check the validity and doesn't trace the receiving errors.
 */
@property (nonatomic, readonly) BOOL authorized;


/**
 Returns the shared BBFacade.
 
 @return	The shared BBFacade object.
 */

+ (BBFacade *)sharedInstance;

// Helper

- (void)executeInBackground:(void (^)())block;

// Server info
- (NSString *)currentBoardName;
- (NSString *)localNetworkName;
- (NSString *)localNetworkShortname;
- (UIColor *)currentBoardColor;
- (UIColor *)currentBoardLightColor;

- (void)switchToLocalBoard;
- (void)switchToGlobalBoard;
- (void)toggleBoards;

// Posting

- (void)toggleAnonymous;
- (void)completePostAction:(BBPostAction)action onPost:(BBPost *)post completion:(void (^)(NSError *error))block;


/**
 Send request message to the server and in case of success 
 it builds the BBWebViewPlugin that can be used to authenticate 
 application and obtain the access token.
 
 @param		block	Block to execute when task is complete.
					By default block executes on the main queue.
					This parameter must not be nil.
  
					This block has no return value and takes two arguments:
						plugin		Builded BBWebViewPlugin object.
									It equals to nil if error occurs.
						error		Value is not nil if an error occurs while processing the message.
 
 @see		BBOperation
 @see		BBWebViewPlugin
 */
- (void)authorization:(void (^)(BBWebViewPlugin *plugin, NSError *error))block;

/** 
 Send 'posts' message to the server.
 
 @param		block	Block to execute when task is complete.
					By default block executes on the main queue.
					This parameter must not be nil.
  
					This block has no return value and takes two arguments:
						response	The corresponded response to the message.
									It equals to nil if error occurs.
						error		Value is not nil if an error occurs while processing the message.
 
 @see		BBOperation
 */
- (NSOperation *)postsFromPage:(NSInteger)page block:(void (^)(NSArray *, NSNumber *, NSError *))block;
- (NSOperation *)postsCountWithBlock:(void (^)(NSInteger , NSError *))block;
/** 
 Send 'post' message with specified text to the server.
 
 @param		text	A string that contains text of the post.
 @param		block	Block to execute when task is complete.
					By default block executes on the main queue.
					This parameter must not be nil.
  
					This block has no return value and takes two arguments:
						error		Value is not nil if an error occurs while processing the message.
 
 @see		BBOperation
 */
- (void)postText:(NSString *)text block:(void (^)(NSError *))block;

/** 
 Send 'reply' message with text for specified post to the server.
 
 @param		text	A string that contains text of the post.
 @param		UID		A string with unique identifier of existing post.
 @param		block	Block to execute when task is complete.
					By default block executes on the main queue.
					This parameter must not be nil.
 
					This block has no return value and takes two arguments:
						error		Value is not nil if an error occurs while processing the message.
 
 @see		BBOperation
 */
- (void)replyText:(NSString *)text UID:(NSString *)UID block:(void (^)(NSError *))block;

- (void)replyText:(NSString *)text UID:(NSString *)UID anonymously:(BOOL)anonymously block:(void (^)(NSError *))block;

/**
 Send 'agree' message for specified post to the server.
 
 @param		UID		A string with unique identifier of existing post.
 @param		block	Block to execute when task is complete.
					By default block executes on the main queue.
					This parameter must not be nil.
 
					This block has no return value and takes two arguments:
						error		Value is not nil if an error occurs while processing the message.
 
 @see		BBOperation
 */
- (void)agree:(NSString *)UID block:(void (^)(NSError *error))block;

/**
 Send 'disagree' message for specified post to the server.
 
 @param		UID		A string with unique identifier of existing post.
 @param		block	Block to execute when task is complete.
					By default block executes on the main queue.
					This parameter must not be nil.
 
					This block has no return value and takes two arguments:
						error		Value is not nil if an error occurs while processing the message.
 
 @see		BBOperation
 */
- (void)disagree:(NSString *)UID block:(void (^)(NSError *error))block;

- (void)newsworthyPostWithUID:(NSString *)UID block:(void (^)(NSError *error))block;

- (void)replies:(NSString *)UID block:(void (^)(NSArray *posts, NSError *error))block;
- (void)postWithUID:(NSString *)UID block:(void (^)(BBPostResponse *response, NSError *error))block;
- (void)privatePostWithUID:(NSString *)UID block:(void (^)(BBPrivatePost *post, NSError *error))block;

- (void)checkDictionary:(void (^)(id <BBResponseProtocol> response, NSError *error))block;


// Notifications
- (NSOperation *)countOfNotifications:(void (^)(NSUInteger count, NSError *error))block;
- (NSOperation *)notificationsWithLastID:(NSString *)lastID frame:(BBFrame)frame block:(void (^)(NSArray *notifications, NSError *error))block;
- (NSOperation *)notificationStatisticsWithBlock:(void (^)(BBNotificationStatistics *statistics, NSError *error))block;
- (NSOperation *)notificationsWithEntities:(NSArray *)notifications block:(void (^)(NSArray *notifications, NSError *error))block;
- (NSOperation *)notificationsMarkAsReadWithBlock:(void (^)(NSError *error))block;


// Account creation
- (void)networkWithEmail:(NSString *)email block:(void (^)(BBNetwork *network, NSError *error))block;
- (void)registerWithEmail:(NSString *)email pin:(NSString *)pin attempt_code:(NSString *)attempt_code block:(void (^)(NSError *error))block;
- (void)createUserWithID:(NSString *)userID password:(NSString *)password block:(void (^)(NSString *attempt_code, NSError *error))block;

// Login and logout
- (void)loginWithUserID:(NSString *)userID password:(NSString *)password block:(void (^)(NSError *error))block;
- (void)userInfoWithBlock:(void (^)(BBUser *user, NSError *error))block;

- (void)logout;
- (void)cancelAllRequests;

// Heartbeat
- (void)networkStatisticsWithBlock:(void (^)(BBNetworkStatisticsResponse *response, NSError *error))block;
- (void)usersOnlineWithBlock:(void (^)(BBUsersOnlineResponse *response, NSError *error))block;
- (void)usersOnlineInfoPlotWithBlock:(void(^)(BBUsersOnlineInfoPlotResponse *response, NSError *error))block;


// Zeitgeist
- (void)topHeadlinesWithBlock:(void(^)(NSArray *headlines, NSError *error))block;
- (void)bestWeekPostsWithblock:(void (^)(NSArray *, NSError *))block;
- (void)worstWeekPostsWithBlock:(void (^)(NSArray *, NSError *))block;
- (void)topPersonalitiesWithBlock:(void (^)(NSArray *personalities, NSError *error))block;

// Personality
- (void)personalityOfUserWithID:(NSString *)userID block:(void (^)(BBPersonality *personality, NSError *error))block;
- (void)personalityOfUserWithName:(NSString *)username block:(void (^)(BBPersonality *personality, NSError *error))block;
- (void)recentPostsForPersonalityWithUID:(NSString *)UID block:(void(^)(NSArray *posts, NSError *error))block;
- (void)bestPostsForPersonalityWithUID:(NSString *)UID block:(void(^)(NSArray *posts, NSError *error))block;
- (void)worstPostsForPersonalityWithUID:(NSString *)UID block:(void(^)(NSArray *posts, NSError *error))block;
- (void)favoritePostsForPersonalityWithUID:(NSString *)UID block:(void(^)(NSArray *posts, NSError *error))block;
- (void)updatePersonalityScreennameToName:(NSString *)name block:(void(^)(NSError *error))block;

@end
