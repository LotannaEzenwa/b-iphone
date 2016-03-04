//
//  BBNews.m
//  Boredat
//
//  Created by Anton Kolosov on 1/15/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBNews.h"
#import "MgmtUtils.h"
#import "NSObject+NULL.h"
#import "NSFoundation+Extensions.h"
#import "BBPost.h"

NSString * const kNewsAccountID = @"accountId";
NSString * const kNewsActive = @"active";
NSString * const kNewsAgreeCount = @"agreeCount";
NSString * const kNewsDisagreeCount = @"disagreeCount";
NSString * const kNewsFavouriteCount = @"favoriteCount";
NSString * const kNewsIPHash = @"ipHash";
NSString * const kNewsNetworkID = @"networkId";
NSString * const kNewsNetworkName = @"networkName";
NSString * const kNewsNetworkShortName = @"networkShortname";
NSString * const kNewsID = @"newsId";
NSString * const kNewsNewsworthyCount = @"newsworthyCount";
NSString * const kNewsParentID = @"parentId";
NSString * const kNewsReplyCount = @"replyCount";
NSString * const kNewsScreenNameID = @"snId";
NSString * const kNewsScreenNameImage = @"snImage";
NSString * const kNewsScreenNameValue = @"snValue";
NSString * const kNewsText = @"text";
NSString * const KNewsDate = @"timestamp";
NSString * const kNewsType = @"type";
NSString * const kNewsTypeName = @"typeName";

@implementation BBNews


- (id)initWithJSONObject:(id)JSONObject
{
	self = [super init];
	
	if (self != nil)
	{
		NSDictionary *JSONDictionary = NSDictionaryObject(JSONObject);
        
        if (JSONDictionary.count > 0)
        {
            _accountID = [[JSONDictionary objectForKey:kNewsAccountID] copy];
            _ipHash = [[JSONDictionary objectForKey:kNewsIPHash] copy];
            _networkID = [[JSONDictionary objectForKey:kNewsNetworkID] copy];
            _networkName = [[JSONDictionary objectForKey:kNewsNetworkName] copy];
            _networkShortName = [[JSONDictionary objectForKey:kNewsNetworkShortName] copy];
            _ID = [[JSONDictionary objectForKey:kNewsID] copy];
            _parentID = [[JSONDictionary objectForKey:kNewsParentID] copy];
            _screenNameID = [[JSONDictionary objectForKey:kNewsScreenNameID] copy];
            _screenNameImage = [NSStringObject([JSONDictionary objectForKey:kNewsScreenNameImage]) copy];
            _screenNameValue = [[JSONDictionary objectForKey:kNewsScreenNameValue] copy];
            _type = [[JSONDictionary objectForKey:kNewsType] copy];
            _typeName = [[JSONDictionary objectForKey:kNewsTypeName] copy];
            _date = [[NSDate dateWithString:[JSONDictionary objectForKey:KNewsDate]] copy];
            _text = [[self transformedText:[JSONDictionary objectForKey:kNewsText]] copy];
            _agreeCount = [[JSONDictionary objectForKey:kNewsAgreeCount] integerValue];
            _disagreeCount = [[JSONDictionary objectForKey:kNewsDisagreeCount] integerValue];
            _newsworthyCount = [[JSONDictionary objectForKey:kNewsNewsworthyCount] integerValue];
            _favouriteCount = [[JSONDictionary objectForKey:kNewsFavouriteCount] integerValue];
            _replyCount = [[JSONDictionary objectForKey:kNewsReplyCount] integerValue];
            _active = [[JSONDictionary objectForKey:kNewsActive] integerValue];
            _localNetworkName = [[JSONDictionary objectForKey:kLocalNetworkName] copy];
            _hasVotedAgree = [[JSONDictionary objectForKey:kHasVotedAgree] boolValue];
            _hasVotedDisagree = [[JSONDictionary objectForKey:kHasVotedDisagree] boolValue];
            _hasVotedNewsworthy = [[JSONDictionary objectForKey:kHasVotedNewsworthy] boolValue];
        }
	}
	
	return self;
}



- (NSString *)transformedText:(NSString *)text
{
    NSString *firstText = [text stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
    firstText = [firstText stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    
    NSMutableString *ASCIIString = [[NSMutableString alloc] initWithString:firstText];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"ASCII_HTML" withExtension:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:url];
    NSString *expression = @"&(.*);";
    
    while (true)
    {
        NSRange range = [ASCIIString rangeOfString:expression options:NSRegularExpressionSearch|NSCaseInsensitiveSearch];
        if (range.location == NSNotFound) break;
        
        
        NSString *stringforReplace = [ASCIIString substringWithRange:(NSRange){range.location, range.length}];
        NSArray *strings = [stringforReplace componentsSeparatedByString:@"&"];
        
        [strings enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
            if ([str length] > 0)
            {
                NSString *key = [[str componentsSeparatedByString:@";"] objectAtIndex:0];
                
                NSString *value = [dict objectForKey:key];
                if ([value length] == 0)
                {
                    value = @"";
                }
                key = [@"&" stringByAppendingFormat:@"%@%@",key,@";"];
                
                [ASCIIString replaceOccurrencesOfString:key withString:value options:NSLiteralSearch range:NSMakeRange(0,[ASCIIString length])];
            }
        }];
        
    }
    
    return ASCIIString;
}



@end
