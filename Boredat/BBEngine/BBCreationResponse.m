//
//  BBCreationResponse.m
//  
//
//  Created by David Pickart on 12/27/15.
//
//

#import "BBCreationResponse.h"
#import "BBResponseDataProtocol.h"
#import "NSObject+NULL.h"

@implementation BBCreationResponse


- (id)initWithData:(id<BBResponseDataProtocol>)data
{
    self = [super initWithData:data];
    
    if (self != nil)
    {
        NSDictionary *JSONDictionary = NSDictionaryObject(data.JSONObject);
        
        if (JSONDictionary.count > 0)
        {
            _attempt_code = [JSONDictionary objectForKey:@"attempt_code"];
        }
    }
    
    return self;
}

@end
