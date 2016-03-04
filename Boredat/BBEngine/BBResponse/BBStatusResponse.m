//
//  BBStatusResponse.m
//  Boredat
//
//  Created by Dmitry Letko on 5/24/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBStatusResponse.h"
#import "BBResponseDataProtocol.h"

#import "NSObject+NULL.h"

#import "MgmtUtils.h"


static NSString *const kStatus = @"status";
static NSString *const kMessage = @"message";


@interface BBStatusResponse ()
@property (nonatomic, readwrite) NSInteger status;
@property (copy, nonatomic, readwrite) NSString *message;

@end


@implementation BBStatusResponse

- (id)initWithData:(id<BBResponseDataProtocol>)data
{
	self = [super initWithData:data];
	
	if (self != nil)
	{
		NSDictionary *JSONDictionary = NSDictionaryObject(data.JSONObject);
		
		_status = [[JSONDictionary objectForKey:kStatus] integerValue];
		_message = [[JSONDictionary objectForKey:kMessage] copy];
	}
	
	return self;
}


@end
