//
//  BBResponseData.h
//  Boredat
//
//  Created by Dmitry Letko on 5/25/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBResponseDataProtocol.h"


@interface BBResponseData : NSObject <BBResponseDataProtocol>
@property (copy, nonatomic, readwrite) NSURLRequest *URLRedirection;
@property (copy, nonatomic, readwrite) NSURLResponse *URLResponse;
@property (copy, nonatomic, readwrite) NSObject<NSCopying> *JSONObject;

+ (id)data;

@end
