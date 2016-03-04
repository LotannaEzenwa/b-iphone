//
//  BBCreationResponse.h
//  
//
//  Created by David Pickart on 12/27/15.
//
//

#import "BBResponse.h"

@interface BBCreationResponse : BBResponse

@property (strong, nonatomic, readonly) NSString *attempt_code;

@end