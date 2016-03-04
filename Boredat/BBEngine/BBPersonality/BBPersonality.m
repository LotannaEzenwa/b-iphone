//
//  BBPersonality.m
//  Boredat
//
//  Created by Dmitry Letko on 3/20/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBPersonality.h"

#import "BBPost.h"

#import "MgmtUtils.h"

#import "NSObject+NULL.h"


NSString * const kPersonalityImage = @"personalityImage";
NSString * const kPersonalityId = @"personalityId";
NSString * const kPostCount = @"postCount";
NSString * const kProfileViews = @"profileViews";

@implementation BBPersonality

@end


@implementation BBPersonality (JSONObject)

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        _image = @"";
        _personalityId = @"";
        _personalityName = @"";
        _postCount = 0;
        _profileViews = 0;
        _networkName = @"";
    }
    
    return self;
}

- (id)initWithPost:(BBPost *)post
{
    self = [super init];
    
    if (self != nil)
    {
        _image = post.screennameImage;
        _personalityId = post.screennameUID;
        _personalityName = post.screennameName;
        _postCount = 0;
        _profileViews = 0;
        _networkName = post.localNetworkName;
    }
    
    return self;
}

- (id)initWithJSONObject:(id)JSONObject
{
    self = [super init];
    
    if (self != nil)
    {
        NSDictionary *JSONDictionary = NSDictionaryObject(JSONObject);
        
        if (JSONDictionary.count > 0)
        {
            // Because of API inconsistencies
            _image = [[JSONDictionary objectForKey:kPersonalityImage] copy];
            if (_image == nil)
            {
                _image = [[JSONDictionary objectForKey:@"image"] copy];

            }

            _personalityId = [[JSONDictionary objectForKey:kPersonalityId] copy];
            _personalityName = [[JSONDictionary objectForKey:@"personalityName"] copy];
            _postCount = [[JSONDictionary objectForKey:kPostCount] integerValue];
            _profileViews = [[JSONDictionary objectForKey:kProfileViews] integerValue];
            _networkName = [[JSONDictionary objectForKey:@"networkName"] copy];
        }
    }
    
    return self;
}

- (NSString *)networkName
{
    return (_networkName == nil) ? @"" : _networkName;
}

@end