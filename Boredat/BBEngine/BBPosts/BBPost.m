//
//  BBPost.m
//  Boredat
//
//  Created by Dmitry Letko on 5/16/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBFacade.h"
#import "BBNews.h"
#import "BBTextFormatter.h"
#import "BBPost.h"

#import "MgmtUtils.h"

#import "NSObject+NULL.h"
#import "NSFoundation+Extensions.h"


NSString *const kPostUID = @"postId";
NSString *const kPostParentUID = @"postParentId";
NSString *const kPostText = @"postText";
NSString *const kPostCreated = @"postCreated";
NSString *const kPostTotalAgrees = @"postTotalAgrees";
NSString *const kPostTotalDisagrees = @"postTotalDisagrees";
NSString *const kPostTotalNewsworthies = @"postTotalNewsworthies";
NSString *const kPostTotalReplies = @"postTotalReplies";
NSString *const kPostType = @"postType";
NSString *const kNetworkName = @"networkName";
NSString *const kNetworkShortname = @"networkShortname";
NSString *const kLocationName = @"locationName";
NSString *const kLocationShortname = @"locationShortname";
NSString *const kScreennameUID = @"screennameId";
NSString *const kScreennameName = @"screennameName";
NSString *const kScreennameImage = @"screennameImage";
NSString *const kLocalNetworkName = @"localNetworkName";
NSString *const kHasVotedAgree = @"hasVotedAgree";
NSString *const kHasVotedDisagree = @"hasVotedDisagree";
NSString *const kHasVotedNewsworthy = @"hasVotedNewsworthy";


@implementation BBPost

+ (id)postWithJSONObject:(id)JSONObject
{
	return [[self alloc] initWithJSONObject:JSONObject];
}

+ (id)postWithBBNews:(BBNews *)news
{
    BBPost *post = [BBPost new];
    post.UID = news.ID;
    post.parentUID = news.parentID;
    post.type = news.type;
    post.text = [BBTextFormatter sanitizeText:news.text];
    post.created = news.date;
    post.totalAgrees = news.agreeCount;
    post.totalDisagrees = news.disagreeCount;
    post.totalNewsworthies = news.newsworthyCount;
    post.totalReplies = news.replyCount;
    post.networkName = news.networkName;
    post.networkShortname = news.networkShortName;
    post.locationName = @"";
    post.locationShortname = @"";
    post.screennameUID = news.screenNameID;
    post.screennameName = news.screenNameValue;
    post.screennameImage = news.screenNameImage;    
    post.localNetworkName = news.localNetworkName;
    post.hasVotedAgree = news.hasVotedAgree;
    post.hasVotedDisagree = news.hasVotedDisagree;
    post.hasVotedNewsworthy = news.hasVotedNewsworthy;
    
    return post;
}

- (id)initWithJSONObject:(id)JSONObject
{
	self = [super init];
	
	if (self != nil)
	{
		NSDictionary *JSONDictionary = NSDictionaryObject(JSONObject);
                
        if (JSONDictionary.count > 0)
        {
            NSString *created = [JSONDictionary objectForKey:kPostCreated];
            NSString *screennameImage = NSStringObject([JSONDictionary objectForKey:kScreennameImage]);
            
            _UID = [[JSONDictionary objectForKey:kPostUID] copy];
            _parentUID = [[JSONDictionary objectForKey:kPostParentUID] copy];
            _type = [[JSONDictionary objectForKey:kPostType] copy];
            _text = [[BBTextFormatter sanitizeText:[JSONDictionary objectForKey:kPostText]] copy];
            _created = [[NSDate dateWithString:created] copy];
            _totalAgrees = [[JSONDictionary objectForKey:kPostTotalAgrees] integerValue];
            _totalDisagrees = [[JSONDictionary objectForKey:kPostTotalDisagrees] integerValue];
            _totalNewsworthies = [[JSONDictionary objectForKey:kPostTotalNewsworthies] integerValue];
            _totalReplies = [[JSONDictionary objectForKey:kPostTotalReplies] integerValue];
            _networkName = [[JSONDictionary objectForKey:kNetworkName] copy];
            _networkShortname = [[JSONDictionary objectForKey:kNetworkShortname] copy];
            _locationName = [[JSONDictionary objectForKey:kLocationName] copy];
            _locationShortname = [[JSONDictionary objectForKey:kLocationShortname] copy];
            _screennameUID = [[JSONDictionary objectForKey:kScreennameUID] copy];
            _screennameName = [[JSONDictionary objectForKey:kScreennameName] copy];
            _screennameImage = [screennameImage copy];
            _localNetworkName = [[JSONDictionary objectForKey:kLocalNetworkName] copy];
            _hasVotedAgree = [[JSONDictionary objectForKey:kHasVotedAgree] boolValue];
            _hasVotedDisagree = [[JSONDictionary objectForKey:kHasVotedDisagree] boolValue];
            _hasVotedNewsworthy = [[JSONDictionary objectForKey:kHasVotedNewsworthy] boolValue];
        }
	}
	
	return self;
}

# pragma mark Custom getters/setters

- (NSString *)localNetworkName
{
    if (_localNetworkName == (id)[NSNull null])
    {
        _localNetworkName = @"";
    }
    return _localNetworkName;
}

- (NSMutableAttributedString *)attributedText
{
    if (_attributedText == nil)
    {
        _attributedText = [self formatAttributedText];
    }
    return _attributedText;
}

- (NSMutableAttributedString *)formatAttributedText
{
    // Here's where we format the text that will actually be displayed in the post cells
    if (_text == nil)
    {
        return [NSMutableAttributedString new];
    }
    else
    {
        // Add links to text
        NSMutableAttributedString *attributedText = [BBTextFormatter addLinksToText:_text];
        
        // Add original poster tag if applicable
        if (_type != (id)[NSNull null] && [_type isEqualToString:@"Original Poster"])
        {
            attributedText = [BBTextFormatter addOPTagToText:attributedText];
        }
        
        // Add global server tag if applicable
        if ([_networkShortname isEqualToString:@"global"])
        {
            NSString *serverName = [BBTextFormatter serverTagWithNetworkName:_localNetworkName];
            attributedText = [BBTextFormatter addServerTagToText:attributedText withName:serverName];
        }
        
        return attributedText;
    }
}

- (id)copy
{
    BBPost *newPost = [BBPost new];
    newPost.screennameImage = _screennameImage;
    newPost.UID = _UID;
    newPost.parentUID = _parentUID;
    newPost.text = _text;
    newPost.attributedText = _attributedText;
    newPost.created = _created;
    newPost.totalAgrees = _totalAgrees;
    newPost.totalDisagrees = _totalDisagrees;
    newPost.totalNewsworthies = _totalNewsworthies;
    newPost.totalReplies = _totalReplies;
    newPost.type = _type;
    newPost.networkName = _networkName;
    newPost.networkShortname = _networkShortname;
    newPost.locationName = _locationName;
    newPost.locationShortname = _locationShortname;
    newPost.screennameUID = _screennameUID;
    newPost.screennameName = _screennameName;
    newPost.screennameImage = _screennameImage;
    newPost.localNetworkName = _localNetworkName;
    newPost.hasVotedAgree = _hasVotedAgree;
    newPost.hasVotedDisagree = _hasVotedDisagree;
    newPost.hasVotedNewsworthy = _hasVotedNewsworthy;
    return newPost;
}

// Public

// Update post details
- (void)updateForAction:(BBPostAction)action
{
    switch (action)
    {
        case kPostActionAgree:
            _totalAgrees += 1;
            _hasVotedAgree = YES;
            break;
            
        case kPostActionDisagree:
            _totalDisagrees += 1;
            _hasVotedDisagree = YES;
            break;
            
        case kPostActionNewsworthy:
            _totalNewsworthies += 1;
            _hasVotedNewsworthy = YES;
            break;
            
        default:
            break;
    }
}

- (NSArray *)actionsForUpdatedPost:(BBPost *)post
{
    NSMutableArray *actions = [NSMutableArray new];
    if (post.totalAgrees > self.totalAgrees)
    {
        [actions addObject:[NSNumber numberWithInt:kPostActionAgree]];
    }
    if (post.totalDisagrees > self.totalDisagrees)
    {
        [actions addObject:[NSNumber numberWithInt:kPostActionDisagree]];
    }
    if (post.totalNewsworthies > self.totalNewsworthies)
    {
        [actions addObject:[NSNumber numberWithInt:kPostActionNewsworthy]];
    }
    if (post.totalReplies > self.totalReplies)
    {
        [actions addObject:[NSNumber numberWithInt:kPostActionReply]];
    }
    return [NSArray arrayWithArray:actions];
}

@end
