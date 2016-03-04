//
//  BBFacade.m
//  Boredat
//
//  Created by Dmitry Letko on 5/21/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBFacade.h"
#import "BBConsumer.h"
#import "BBToken.h"
#import "BBMessageQueue.h"
#import "BBRequestMessage.h"
#import "BBRequestResponse.h"
#import "BBAuthenticateMessage.h"
#import "BBAuthenticateResponse.h"
#import "BBAccessMessage.h"
#import "BBAccessResponse.h"
#import "BBReplyMessage.h"
#import "BBAgreeMessage.h"
#import "BBDisagreeMessage.h"

#import "BBUserResponse.h"
#import "BBLoginResponse.h"

#import "BBRepliesMessage.h"
#import "BBRepliesResponse.h"

#import "BBPostMessage.h"
#import "BBLoginMessage.h"
#import "BBUserMessage.h"
#import "BBNewsworthyMessage.h"

#import "BBPostsMessage.h"
#import "BBPostsResponse.h"
#import "BBPostsCountMessage.h"
#import "BBPostsCountResponse.h"

#import "BBNotificationMessage.h"
#import "BBNotificationResponse.h"

#import "BBRegistrationMessage.h"
#import "BBRegistrationResponse.h"

#import "BBVerificationMessage.h"
#import "BBVerificationResponse.h"

#import "BBPersonalityMessage.h"
#import "BBPersonalityResponse.h"

#import "BBRecentPersonalityPostsMessage.h"
#import "BBBestPersonalityPostsMessage.h"
#import "BBWorstPersonalityPostsMessage.h"
#import "BBFavoritePersonalityPostsMessage.h"
#import "BBPersonalityPostsResponse.h"

#import "BBScreennameUpdateMessage.h"
#import "BBScreennameUpdateResponse.h"

#import "BBCreationMessage.h"
#import "BBCreationResponse.h"

#import "BBStatusResponse.h"

#import "BBNetwork.h"
#import "BBNetworkMessage.h"
#import "BBNetworkResponse.h"

#import "BBNotificationStatisticsMessage.h"
#import "BBNotificationStatisticsResponse.h"
#import "BBNotificationTargetMessage.h"
#import "BBNotificationTargetResponse.h"
#import "BBNotificationMarkReadMessage.h"

#import "BBPrivatePostMessage.h"
#import "BBPrivatePostResponse.h"

#import "BBWebAuthenticateMessage.h"
#import "BBApplicationSettings.h"

#import "BBKeychainToken.h"

#import "MgmtUtils.h"
#import "GCDUtils.h"
#import "LogUtils.h"

#import "BBTopPersonalitiesMessage.h"
#import "BBTopPersonalitiesResponse.h"
#import "BBNetworkStatisticsMessage.h"
#import "BBNetworkStatisticsResponse.h"
#import "BBUsersOnlineMessage.h"
#import "BBUsersOnlineResponse.h"
#import "BBTopHeadlinesMessage.h"
#import "BBTopHeadlinesResponse.h"
#import "BBUsersOnlineInfoPlotMessage.h"
#import "BBBestPosts.h"
#import "BBWorstPosts.h"

#import "UIKit+Extensions.h"


NSString *const kOAuthCallback = @"http://authenticate.callback";
NSString *const kPostAsAnonymous = @"postAsAnonymous";


@interface BBFacade ()
{
    NSMutableArray *_backgroundTimers;
}

@property (strong, nonatomic, readwrite) BBMessageQueue *messageQueue;
@property (strong, nonatomic, readwrite) BBRequestResponse *request;
@property (strong, nonatomic, readwrite) BBAuthenticateResponse *authenticate;
@property (strong, nonatomic, readwrite) BBToken *accessToken;
@property (strong, nonatomic, readwrite) BBUser *user;
@property (strong, nonatomic, readwrite) BBVerificationResponse *verification;
@property (strong, nonatomic, readwrite) NSCache *cacheOfPersonalities;

- (void)request:(result_block_t)block;
- (void)authenticateWithUserID:(NSString *)userID password:(NSString *)password block:(result_block_t)block;
- (void)authenticate:(void (^)(BBWebViewPlugin *, NSError *))block;
- (void)access:(result_block_t)block;

@end


@implementation BBFacade

@synthesize accessToken = _accessToken;
@synthesize postAsAnonymous = _postAsAnonymous;

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        _messageQueue = [BBMessageQueue new];
        _backgroundTimers = [NSMutableArray new];
        
        _callback = [kOAuthCallback copy];
        
        _cacheOfPersonalities = [NSCache new];
        _cacheOfPersonalities.name = @"app.BBFacade.cacheOfPersonalities";
        _cacheOfPersonalities.countLimit = NSUIntegerMax;
        
        _server = [BBApplicationSettings localServer];
        _isGlobal = NO;
        
        NSString *key = [BBApplicationSettings consumerKey];
        NSString *secret = [BBApplicationSettings consumerSecret];
        _consumer = [[BBConsumer alloc] initWithKey:key secret:secret];
    }
    
    return self;
}

static BBFacade *instance = nil;

+ (BBFacade *)sharedInstance
{
    static dispatch_once_t initialize;
    
    dispatch_once(&initialize, ^{
        instance = [self new];
    });
    
    return instance;
}

// Executes block when there's nothing else in the message queue
- (void)executeInBackground:(void (^)())block
{
    NSDictionary *dict = [NSMutableDictionary new];
    [dict setValue:block forKey:@"block"];
    [_backgroundTimers addObject:[NSTimer scheduledTimerWithTimeInterval:0.0f
                                     target:self
                                   selector: @selector(handleBackgroundTimer:)
                                   userInfo:dict
                                    repeats:NO]];
}
         
- (void)handleBackgroundTimer:(NSTimer *)timer
{
    NSDictionary *dict = [timer userInfo];
    void (^block)() = [dict objectForKey:@"block"];
    
    if ([_messageQueue numPendingMessages] == 0)
    {
        if (block != nil)
        {
            block();
        }
    }
    else
    {
        [_backgroundTimers addObject: [NSTimer scheduledTimerWithTimeInterval:3.0f
                                         target:self
                                       selector: @selector(handleBackgroundTimer:)
                                       userInfo:dict
                                        repeats:NO]];
    }
}


#pragma mark -
#pragma mark server stuff

- (NSString *)currentBoardName
{
    NSString *networkName = [self localNetworkShortname];
    if (_isGlobal) {
        networkName = @"Global";
    }
//    else if ([networkName isEqualToString:@"Dartmouth"])
//    {
//        networkName = @"Baker";
//    }
//    else if ([networkName isEqualToString:@"Columbia"])
//    {
//        networkName = @"Butler";
//    }
    else if ([networkName isEqualToString:@"New York University"])
    {
        networkName = @"NYU";
    }
    return [NSString stringWithFormat:@"@%@  ", networkName];
}

- (NSString *)localNetworkName
{
    return _user.networkShortName;
}

- (NSString *)localNetworkShortname
{
    return [_user.networkShortName capitalizedString];
}

- (UIColor *)currentBoardColor
{
    if (_isGlobal)
    {
        return [BBApplicationSettings colorForKey:kColorGlobalDark];
    }
    
    NSString *networkName = [self localNetworkShortname];

    if ([networkName isEqualToString:@"Carleton"])
    {
        return [UIColor veryDarkBlueColor];
    }
    else if ([networkName isEqualToString:@"Dartmouth"])
    {
        return [UIColor veryDarkGreenColor];
    }
    else if ([networkName isEqualToString:@"Columbia"])
    {
        return [UIColor darkBlueColor];
    }
    else if ([networkName isEqualToString:@"Kenyon"])
    {
        return [UIColor colorWithHexString:@"#271d3a"];
    }
    else if ([networkName isEqualToString:@"Grinnell"])
    {
        return [UIColor colorWithHexString:@"#661510"];
    }
    else
    {
        return [BBApplicationSettings colorForKey:kColorGlobalDark];
    }
}

- (UIColor *)currentBoardLightColor
{
    return [UIColor lighterColorForColor:[self currentBoardColor]];
}

- (void)switchToLocalBoard
{
    _server = [BBApplicationSettings localServer];
    _isGlobal = NO;
}

- (void)switchToGlobalBoard
{
    _server = [BBApplicationSettings globalServer];
    _isGlobal = YES;
}

- (void)toggleBoards
{
    if (_isGlobal)
    {
        [self switchToLocalBoard];
    }
    else
    {
        [self switchToGlobalBoard];
    }
}

// Posting

- (void)toggleAnonymous
{
    [self setPostAsAnonymous:!self.postAsAnonymous];
}

- (void)completePostAction:(BBPostAction)action onPost:(BBPost *)post completion:(void (^)(NSError *))block
{
    switch (action) {
        case kPostActionAgree:
        {
            [self agree:post.UID block:^(NSError *error) {
                block(error);
            }];
            break;
        }
            
        case kPostActionDisagree:
        {
            [self disagree:post.UID block:^(NSError *error) {
                block(error);
            }];
            break;
        }
            
        case kPostActionNewsworthy:
        {
            [self newsworthyPostWithUID:post.UID block:^(NSError *error) {
                block(error);
            }];
            break;
        }
            
        default:
            break;
    }
}

//

- (BOOL)authorized
{
    return (self.accessToken != nil);
}

- (void)authorization:(void (^)(BBWebViewPlugin *, NSError *))block
{
	[self request:^(NSError *error) {		
		if (error != nil)
		{
			block(nil, error);
		}			
		else
		{
			[self authenticate:block];
		}		
	}];
}

- (NSOperation *)postsCountWithBlock:(void (^)(NSInteger , NSError *))block
{
    BBPostsCountMessage *message = [BBPostsCountMessage message];
	message.server = _server;
	message.consumer = _consumer;
	message.token = self.accessToken;
    
	return [_messageQueue sendMessage:message completion:^(BBPostsCountResponse *response, NSError *error) {
        if (block != nil)
        {
            block(response.pageCount, error);
        }
    }];
}


- (NSOperation *)postsFromPage:(NSInteger)page block:(void (^)(NSArray *, NSNumber *, NSError *))block
{
	BBPostsMessage *message = [BBPostsMessage message];
	message.server = _server;
	message.consumer = _consumer;
	message.token = self.accessToken;

	message.page = [NSNumber numberWithInteger:page];
    
	return [_messageQueue sendMessage:message completion:^(BBPostsResponse *response, NSError *error) {
        if (block != nil)
        {
            block(response.posts, response.page, error);
        }
    }];
}

- (void)bestWeekPostsWithblock:(void (^)(NSArray *, NSError *))block
{
	BBBestPosts *message = [BBBestPosts message];
	message.server = _server;
	message.consumer = _consumer;
	message.token = self.accessToken;
    message.priority = NSOperationQueuePriorityVeryHigh;

    
    [_messageQueue sendMessage:message completion:^(BBPostsResponse *response, NSError *error) {
        if (block != nil)
        {
            block(response.posts, error);
        }
    }];
}

- (void)worstWeekPostsWithBlock:(void (^)(NSArray *, NSError *))block
{
	BBWorstPosts *message = [BBWorstPosts message];
	message.server = _server;
	message.consumer = _consumer;
	message.token = self.accessToken;
    
    [_messageQueue sendMessage:message completion:^(BBPostsResponse *response, NSError *error) {
        if (block != nil)
        {
            block(response.posts, error);
        }
    }];
}

- (void)postText:(NSString *)text block:(void (^)(NSError *))block
{
	[self replyText:text UID:nil block:block];
}

- (void)replyText:(NSString *)text UID:(NSString *)UID block:(void (^)(NSError *))block
{
    [self replyText:text UID:UID anonymously:YES block:block];
}

- (void)replyText:(NSString *)text UID:(NSString *)UID anonymously:(BOOL)anonymously block:(void (^)(NSError *))block
{
    NSNumber *anonymouslyNumber = [[NSNumber alloc] initWithBool:anonymously];
    
    BBReplyMessage *message = [BBReplyMessage new];
	message.server = _server;
	message.consumer = _consumer;
	message.token = self.accessToken;
	message.text = text;
	message.UID = UID;
    message.anonymously = anonymouslyNumber;
	
	[_messageQueue sendMessage:message completion:^(id<BBResponseProtocol> response, NSError *error) {
        
        // Replace oauth error dump with a more helpful message
        if (error != nil)
        {
           if ([error.userInfo[@"NSLocalizedDescription"] containsString:@"Verification of signature failed"])
           {
               error = [NSError errorWithDomain:error.domain code:error.code userInfo:[NSDictionary dictionaryWithObject:@"Illegal character(s) in post" forKey:@"NSLocalizedDescription"]];
           }
        }
        
        if (block != nil)
        {
            block(error);
        }
    }];
    
}

- (void)agree:(NSString *)UID block:(void (^)(NSError *))block
{	
	BBAgreeMessage *message = [BBAgreeMessage new];
	message.server = _server;
	message.consumer = _consumer;
	message.token = self.accessToken;
	message.UID = UID;
	
	[_messageQueue sendMessage:message completion:^(id<BBResponseProtocol> response, NSError *error) {
        if (block != nil)
        {
            block(error);
        }
    }];
    
}

- (void)disagree:(NSString *)UID block:(void (^)(NSError *))block
{
	BBDisagreeMessage *message = [BBDisagreeMessage new];
	message.server = _server;
	message.consumer = _consumer;
	message.token = self.accessToken;
	message.UID = UID;
	
	[_messageQueue sendMessage:message completion:^(id<BBResponseProtocol> response, NSError *error) {
        if (block != nil)
        {
            block(error);
        }
    }];
    
}

- (void)replies:(NSString *)UID block:(void (^)(NSArray *, NSError *))block
{
    BBRepliesMessage *message = [BBRepliesMessage new];
    message.server = _server;
    message.consumer = _consumer;
    message.token = self.accessToken;
    message.UID = UID;
    message.priority = NSOperationQueuePriorityVeryHigh;
    
    [_messageQueue sendMessage:message completion:^(BBRepliesResponse *response, NSError *error) {
        if (block != nil)
        {
            block(response.posts, error);
        }
    }];
    
}

- (void)postWithUID:(NSString *)UID block:(void (^)(BBPostResponse *, NSError *))block
{
    BBPostMessage *message = [BBPostMessage new];
    message.server = _server;
    message.consumer = _consumer;
    message.token = self.accessToken;
    message.UID = UID;
        
    [_messageQueue sendMessage:message completion:block];
    
}

- (void)loginWithUserID:(NSString *)userID password:(NSString *)password block:(void (^)(NSError *error))block
{
    [self request:^(NSError *error) {
        if (error == nil)
        {
            [self authenticateWithUserID:userID password:password block:block];
        }
        else
        {
            if (block != nil)
            {
                block(error);
            }
        }
    }];
}

- (void)userInfoWithBlock:(void (^)(BBUser *, NSError *))block
{
    NSSet *fields = [[NSSet alloc] initWithObjects:kPersonalityUID, kPersonalityName, kUserTotalNotifications, kUserNetworkName, kUserNetworkShortName, nil];
    
    BBUserMessage *message = [BBUserMessage new];
    message.server = _server;
    message.consumer = _consumer;
    message.token = self.accessToken;
    message.fields = fields;
    
    [_messageQueue sendMessage:message completion:^(BBUserResponse *response, NSError *error) {
        if (response.user != nil)
        {
            [self setUser:response.user];
        }
        
        if (block != nil)
        {
            block(response.user, error);
        }
    }];
    
}

- (NSOperation *)countOfNotifications:(void (^)(NSUInteger, NSError *))block
{
    NSSet *fields = [NSSet setWithObject:kUserTotalNotifications];
    
    BBUserMessage *message = [BBUserMessage message];
    message.server = _server;
    message.consumer = _consumer;
    message.token = self.accessToken;
    message.fields = fields;
    
    return [_messageQueue sendMessage:message completion:^(BBUserResponse *response, NSError *error) {
        if (block != nil)
        {            
            block([response.user userTotalNotifications], error);
        }
    }];
}

- (void)newsworthyPostWithUID:(NSString *)UID block:(void (^)(NSError *))block
{
    BBNewsworthyMessage *message = [BBNewsworthyMessage new];
    message.server = _server;
	message.consumer = _consumer;
	message.token = self.accessToken;
	message.UID = UID;
    
    [_messageQueue sendMessage:message completion:^(id<BBResponseProtocol> response, NSError *error) {
       if (block != nil)
       {
           block(error);
       }
    }];
    
}

- (NSOperation *)notificationsWithLastID:(NSString *)lastID frame:(BBFrame)frame block:(void (^)(NSArray *, NSError *))block
{
    NSNumber *countNumber = [NSNumber numberWithUnsignedInteger:frame.count];
    NSNumber *pageNumber = [NSNumber numberWithUnsignedInteger:frame.page];
    
    BBNotificationMessage *message = [BBNotificationMessage message];
    message.server = _server;
	message.consumer = _consumer;
	message.token = self.accessToken;
    message.count = countNumber;
    message.page = pageNumber;
    message.lastID = lastID;
    message.priority = NSOperationQueuePriorityHigh;
        
    return [_messageQueue sendMessage:message completion:^(BBNotificationResponse *response, NSError *error) {
        if (block != nil)
        {
            block(response.notifications, error);
        }
    }];
}

#pragma mark -
#pragma mark Account Creation

- (void)networkWithEmail:(NSString *)email block:(void (^)(BBNetwork *network, NSError *error))block
{
    BBNetworkMessage *message = [BBNetworkMessage new];
    message.server = _server;
    message.email = email;
    
    [_messageQueue sendMessage:message completion:^(BBNetworkResponse *response, NSError *error) {
        if (block != nil)
        {
            block(response.network, error);
        }
    }];
}

- (void)createUserWithID:(NSString *)userID password:(NSString *)password block:(void (^) (NSString *, NSError *))block
{
    BBCreationMessage *message = [BBCreationMessage new];
    message.server = _server;
    message.userID = userID;
    message.password = password;
    
    [_messageQueue sendMessage:message completion:^(BBCreationResponse *response, NSError *error) {
        if (block != nil)
        {
            block(response.attempt_code, error);
        }
    }];
}

- (void)registerWithEmail:(NSString *)email pin:(NSString *)pin attempt_code:(NSString *)attempt_code block:(void (^)(NSError *error))block
{
    BBRegistrationMessage *message = [BBRegistrationMessage new];
    message.server = _server;
    message.email = email;
    message.attempt_code = attempt_code;
    message.pin = pin;
    
    [_messageQueue sendMessage:message completion:^(BBRegistrationResponse *response, NSError *error) {
        
        if (block != nil)
        {
            block(error);
        }
    }];
}

- (void)personalityOfUserWithID:(NSString *)userID block:(void (^)(BBPersonality *personality, NSError *error))block
{
    id cachedPersonality = [_cacheOfPersonalities objectForKey:userID];
            
    if ([cachedPersonality isKindOfClass:[BBPersonality class]] == YES)
    {
        if (block != nil)
        {            
            dispatch_sync_main_queue(^{
                block(cachedPersonality, nil);
            });
        }
    }
    else
    {
        BBPersonalityMessage *message = [BBPersonalityMessage new];
        message.server = _server;
        message.consumer = _consumer;
        message.token = self.accessToken;
        message.UID = userID;
        
        [_messageQueue sendMessage:message completion:^(BBPersonalityResponse *response, NSError *error) {
            BBPersonality *fetchedPersonality = response.personality;
                        
            if (fetchedPersonality != nil)
            {
                [_cacheOfPersonalities setObject:fetchedPersonality forKey:userID];
            }
            else
            {
                if (error == nil)
                {
                    [_cacheOfPersonalities setObject:[NSNull null] forKey:userID];
                }
            }
            
            if (block != nil)
            {
                block(fetchedPersonality, error);
            }
        }];
        
    }
}

- (void)personalityOfUserWithName:(NSString *)username block:(void (^)(BBPersonality *personality, NSError *error))block
{
    id cachedPersonality = [_cacheOfPersonalities objectForKey:username];
    
    if ([cachedPersonality isKindOfClass:[BBPersonality class]] == YES)
    {
        if (block != nil)
        {
            dispatch_sync_main_queue(^{
                block(cachedPersonality, nil);
            });
        }
    }
    else
    {
        BBPersonalityMessage *message = [BBPersonalityMessage new];
        message.server = _server;
        message.consumer = _consumer;
        message.token = self.accessToken;
        message.name = username;
        
        [_messageQueue sendMessage:message completion:^(BBPersonalityResponse *response, NSError *error) {

            BBPersonality *fetchedPersonality = response.personality;
            [_cacheOfPersonalities setObject:fetchedPersonality forKey:username];
            
            if (block != nil)
            {
                block(fetchedPersonality, error);
            }
        }];
    }
}

- (void)topPersonalitiesWithBlock:(void (^)(NSArray *, NSError *))block
{
    NSSet *fields = [NSSet setWithObjects:
                     kPersonalityId,
                     kPersonalityImage,
                     kPersonalityName,
                     kNetworkName,
                     kPostCount,
                     kProfileViews, nil];
    
    BBTopPersonalitiesMessage *message = [BBTopPersonalitiesMessage message];
    message.server = _server;
    message.consumer = _consumer;
    message.token = self.accessToken;
    message.fields = fields;
    
    [_messageQueue sendMessage:message completion:^(BBTopPersonalitiesResponse *response, NSError *error){
        if (block != nil)
        {
            block(response.personalities, error);
        }
    }];
}

- (void)topHeadlinesWithBlock:(void (^)(NSArray *, NSError *))block
{
	BBTopHeadlinesMessage *message = [BBTopHeadlinesMessage message];
	message.server = _server;
	message.consumer = _consumer;
	message.token = self.accessToken;
    
    [_messageQueue sendMessage:message completion:^(BBTopHeadlinesResponse *response, NSError *error) {
        if (block != nil)
        {
            block(response.posts, error);
        }
    }];
}

- (NSOperation *)notificationStatisticsWithBlock:(void (^)(BBNotificationStatistics *, NSError *))block
{
    BBNotificationStatisticsMessage *message = [BBNotificationStatisticsMessage message];
    message.server = _server;
    message.consumer = _consumer;
    message.token = self.accessToken;
    
    return [_messageQueue sendMessage:message completion:^(BBNotificationStatisticsResponse *response, NSError *error) {
        if (block != nil)
        {
            block(response.statistics, error);
        }
    }];
}

- (NSOperation *)notificationsWithEntities:(NSArray *)notifications block:(void (^)(NSArray *notifications, NSError *error))block
{
    NSMutableArray *arrayOfUID = [NSMutableArray arrayWithCapacity:notifications.count];
    
    [notifications enumerateObjectsUsingBlock:^(BBNotification *notification, NSUInteger idx, BOOL *stop) {
        [arrayOfUID addObject:notification.UID];
    }];
    
    BBNotificationTargetMessage *message = [BBNotificationTargetMessage message];
    message.server = _server;
    message.consumer = _consumer;
    message.token = self.accessToken;
    message.notifications = arrayOfUID;
    message.priority = NSOperationQueuePriorityHigh;
    
    return [_messageQueue sendMessage:message completion:^(BBNotificationTargetResponse *response, NSError *error) {
        if (block != nil)
        {
            block(response.notifications, error);
        }
    }];
}

- (NSOperation *)notificationsMarkAsReadWithBlock:(void (^)(NSError *error))block
{
    BBNotificationMarkReadMessage *message = [BBNotificationMarkReadMessage message];
    message.server = _server;
    message.consumer = _consumer;
    message.token = self.accessToken;
    
    return [_messageQueue sendMessage:message completion:^(BBStatusResponse *response, NSError *error) {
        if (block != nil)
        {
            block(error);
        }
    }];
}

- (void)privatePostWithUID:(NSString *)UID block:(void (^)(BBPrivatePost *, NSError *))block
{
    BBPrivatePostMessage *message = [BBPrivatePostMessage new];
    message.server = _server;
    message.consumer = _consumer;
    message.token = self.accessToken;
    message.UID = UID;
    
    [_messageQueue sendMessage:message completion:^(BBPrivatePostResponse *response, NSError *error) {
        if (block != nil)
        {
            block(response.post, error);
        }
    }];
    
}

- (void)logout
{
    [self setAccessToken:nil];
}

- (void)checkDictionary:(void (^)(id <BBResponseProtocol> response, NSError *error))block
{
    BBMessage *message = [BBMessage new];
    message.server = @"http://boredatbaker.com/langs/boredat.en-us.ini";
    
    [_messageQueue sendMessage:message completion:^(id <BBResponseProtocol> response, NSError *error) {
        if (block != nil)
        {
            block(response, error);
        }
    }];
}

- (void)networkStatisticsWithBlock:(void (^)(BBNetworkStatisticsResponse *, NSError *))block
{
    BBNetworkStatisticsMessage *message = [BBNetworkStatisticsMessage message];
    message.server = _server;
    message.consumer = _consumer;
    message.token = self.accessToken;
    
    [_messageQueue sendMessage:message completion:^(BBNetworkStatisticsResponse *response, NSError *error){
        block(response, error);
    }];
}

- (void)usersOnlineWithBlock:(void (^)(BBUsersOnlineResponse *, NSError *))block
{
    BBUsersOnlineMessage *message = [BBUsersOnlineMessage message];
    message.server = _server;
    message.consumer = _consumer;
    message.token = self.accessToken;
    
    [_messageQueue sendMessage:message completion:^(BBUsersOnlineResponse *response, NSError *error){
        block(response, error);
    }];
}

- (void)usersOnlineInfoPlotWithBlock:(void (^)(BBUsersOnlineInfoPlotResponse *, NSError *))block
{
    BBUsersOnlineInfoPlotMessage *message = [BBUsersOnlineInfoPlotMessage message];
    message.server = _server;
    message.consumer = _consumer;
    message.token = self.accessToken;
    message.periodOfTime = 5;
    
    [_messageQueue sendMessage:message completion:^(BBUsersOnlineInfoPlotResponse *response, NSError *error){
        block(response, error);
    }];
}

- (void)recentPostsForPersonalityWithUID:(NSString *)UID block:(void(^)(NSArray *posts, NSError *error))block
{    
    BBRecentPersonalityPostsMessage *message = [BBRecentPersonalityPostsMessage message];
    message.server = _server;
    message.consumer = _consumer;
    message.token = self.accessToken;
    message.UID = UID;
    message.page = 0;
    
    [_messageQueue sendMessage:message completion:^(BBPersonalityPostsResponse *response, NSError *error) {
        if (block != nil)
        {
            block(response.posts, error);
        }
    }];
}

- (void)bestPostsForPersonalityWithUID:(NSString *)UID block:(void(^)(NSArray *posts, NSError *error))block
{
    BBBestPersonalityPostsMessage *message = [BBBestPersonalityPostsMessage message];
    message.server = _server;
    message.consumer = _consumer;
    message.token = self.accessToken;
    message.UID = UID;
    message.page = 0;
    
    [_messageQueue sendMessage:message completion:^(BBPersonalityPostsResponse *response, NSError *error) {
        if (block != nil)
        {
            block(response.posts, error);
        }
    }];
}

- (void)worstPostsForPersonalityWithUID:(NSString *)UID block:(void(^)(NSArray *posts, NSError *error))block
{
    BBWorstPersonalityPostsMessage *message = [BBWorstPersonalityPostsMessage message];
    message.server = _server;
    message.consumer = _consumer;
    message.token = self.accessToken;
    message.UID = UID;
    message.page = 0;
    
    [_messageQueue sendMessage:message completion:^(BBPersonalityPostsResponse *response, NSError *error) {
        if (block != nil)
        {
            block(response.posts, error);
        }
    }];
}

- (void)favoritePostsForPersonalityWithUID:(NSString *)UID block:(void(^)(NSArray *posts, NSError *error))block
{
    BBFavoritePersonalityPostsMessage *message = [BBFavoritePersonalityPostsMessage message];
    message.server = _server;
    message.consumer = _consumer;
    message.token = self.accessToken;
    message.UID = UID;
    message.page = 0;
    
    [_messageQueue sendMessage:message completion:^(BBPersonalityPostsResponse *response, NSError *error) {
        if (block != nil)
        {
            block(response.posts, error);
        }
    }];
}

- (void)updatePersonalityScreennameToName:(NSString *)name block:(void(^)(NSError *error))block
{
    BBScreennameUpdateMessage *message = [BBScreennameUpdateMessage message];
    message.server = _server;
    message.consumer = _consumer;
    message.token = self.accessToken;
    message.screenname = name;
    
    [_messageQueue sendMessage:message completion:^(BBScreennameUpdateResponse *response, NSError *error) {
        if (block != nil)
        {
            if (error == nil){
                _user.personalityName = name;
            }
            block(error);
        }
    }];

}

#pragma mark -
#pragma mark private

- (void)setPostAsAnonymous:(BOOL)postAsAnonymous
{
    if (postAsAnonymous != _postAsAnonymous)
    {
        _postAsAnonymous = postAsAnonymous;
        
        NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
        [settings setObject:[NSNumber numberWithBool:_postAsAnonymous] forKey:kPostAsAnonymous];
        [settings synchronize];
    }
}

- (BOOL)postAsAnonymous
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    _postAsAnonymous = [[settings objectForKey:kPostAsAnonymous] boolValue];
    return _postAsAnonymous;
}

- (void)request:(result_block_t)block
{
	BBRequestMessage *message = [BBRequestMessage new];
	message.server = _server;
	message.consumer = _consumer;
	message.callback = _callback;
	
	[_messageQueue sendMessage:message completion:^(id<BBResponseProtocol> response, NSError *error) {
		[self setRequest:response];
		
		if (block != nil)
        {
            block(error);
        }
	}];
    
}

- (void)access:(result_block_t)block
{
	BBAccessMessage *message = [BBAccessMessage new];
	message.server = _server;
	message.consumer = _consumer;
	message.token = _request.token;
	message.verifier = _authenticate.verifier;
	
	[_messageQueue sendMessage:message completion:^(BBAccessResponse *response, NSError *error) {       
        [self setAccessToken:response.token];
                
		if (block != nil)
        {
            block(error);
        }
	}];
    
}

- (void)authenticateWithUserID:(NSString *)userID password:(NSString *)password block:(result_block_t)block
{
    BBLoginMessage *message = [BBLoginMessage new];
    message.server = _server;
    message.token = _request.token;
    message.userID = userID;
    message.password = password;
    
    [_messageQueue sendMessage:message completion:^(BBAuthenticateResponse *response, NSError *error) {
        if (error != nil)
        {
            block(error);
        }
        else
        {
            [self setAuthenticate:response];
            [self access:block];
        }
    }];
    
}

- (void)authenticate:(void (^)(BBWebViewPlugin *, NSError *))block
{
	BBWebAuthenticateMessage *message = [BBWebAuthenticateMessage message];
	message.server = _server;
	message.consumer = _consumer;
	message.token = _request.token;
	message.callback = _callback;
	    
	__weak BBWebViewPlugin *plugin = [BBWebViewPlugin pluginWithMessage:message];
	plugin.completion = ^(id<BBResponseProtocol> response, NSError *error) {		
        [self setAuthenticate:response];
		[self access:plugin.result];
	};
	
	
	block(plugin, nil);
}

- (void)setUser:(BBUser *)user
{
    if (_user != user)
    {
        _user = user;
        NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
        NSString *key = [_user.personalityName stringByAppendingString:kPostAsAnonymous];
        if (key != nil)
        {
            _postAsAnonymous = [[settings objectForKey:key] boolValue];
        }
    }
}

- (void)setAccessToken:(BBToken *)accessToken
{
    if (_keychainToken != nil)
    {
        [_keychainToken setToken:accessToken];
    }
    
    if (_accessToken != accessToken)
    {
        if (_accessToken != nil)
        {
            _accessToken = nil;
        }
        
        if (accessToken != nil)
        {
            _accessToken = accessToken;
        }
    }
}

- (BBToken *)accessToken
{
    if (_accessToken != nil)
    {
        return _accessToken;
    }
    else
    {
        if (_keychainToken.token != nil)
        {
            return _keychainToken.token;
        }
    }
    
    return nil;
}

- (void)cancelAllRequests
{
    for (NSTimer *timer in _backgroundTimers)
    {
        [timer invalidate];
    }
    [_messageQueue invalidateAllMessages];
}

@end
