//
//  BBPrivatePost.m
//  Boredat
//
//  Created by Dmitry Letko on 5/8/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBPrivatePost.h"

#import "MgmtUtils.h"

#import "NSObject+NULL.h"
#import "NSFoundation+Extensions.h"


NSString *const kFeedUID = @"messageFeedId";
NSString *const kUID = @"messageId";
NSString *const kIsRead = @"messageIsRead";
NSString *const kCreated = @"messageCreated";
NSString *const kText = @"messageText";
NSString *const kSubject = @"messageSubject";
NSString *const kSenderUID = @"senderId";
NSString *const kSenderName = @"senderName";
NSString *const kSenderImage = @"senderImage";


@implementation BBPrivatePost

@end


@implementation BBPrivatePost (JSONObject)

- (id)initWithJSONObject:(id)JSONObject
{
	self = [super init];
	
	if (self != nil)
	{
		NSDictionary *JSONDictionary = NSDictionaryObject(JSONObject);
        
        if (JSONDictionary.count > 0)
        {
            NSString *created = [JSONDictionary objectForKey:kCreated];
            NSString *senderImage = NSStringObject([JSONDictionary objectForKey:kSenderImage]);
            
            _feedUID = [[JSONDictionary objectForKey:kFeedUID] copy];
            _UID = [[JSONDictionary objectForKey:kUID] copy];
            _isRead = [[JSONDictionary objectForKey:kIsRead] boolValue];
            _created = [[NSDate dateWithString:created] copy];
            _text = [[JSONDictionary objectForKey:kText] copy];
            _subject = [[JSONDictionary objectForKey:kSubject] copy];
            _senderUID = [[JSONDictionary objectForKey:kSenderUID] copy];
            _senderName = [[JSONDictionary objectForKey:kSenderName] copy];
            _senderImage = [senderImage copy];
        }
	}
	
	return self;
}

@end
