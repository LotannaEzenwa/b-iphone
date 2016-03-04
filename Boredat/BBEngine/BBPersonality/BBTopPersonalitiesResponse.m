//
//  BBTopPersonalitiesResponse.m
//  Boredat
//
//  Created by Anton Kolosov on 10/7/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBTopPersonalitiesResponse.h"
#import "BBResponseDataProtocol.h"
#import "BBPersonality.h"
#import "MgmtUtils.h"

#import "NSObject+NULL.h"

@interface BBTopPersonalitiesResponse ()

@property (copy, nonatomic, readwrite) NSArray *personalities;

@end


@implementation BBTopPersonalitiesResponse


- (id)initWithData:(id<BBResponseDataProtocol>)data
{
	self = [super initWithData:data];
	
	if (self != nil)
	{
		NSArray *JSONArray = NSArrayObject(data.JSONObject);
		NSMutableArray *personalities = [[NSMutableArray alloc] initWithCapacity:JSONArray.count];
        
		[JSONArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			BBPersonality *personality = [[BBPersonality alloc] initWithJSONObject:obj];
			
			if (personality != nil)
			{
				[personalities addObject:personality];
			}
		}];
		
		
        _personalities = [personalities copy];
        
        
	}
	
	return self;
}


@end
