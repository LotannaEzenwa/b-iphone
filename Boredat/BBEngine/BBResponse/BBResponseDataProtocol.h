//
//  BBResponseDataProtocol.h
//  Boredat
//
//  Created by Dmitry Letko on 5/25/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@protocol BBResponseDataProtocol <NSObject>
@property (copy, nonatomic, readonly) NSURLRequest *URLRedirection;
@property (copy, nonatomic, readonly) NSURLResponse *URLResponse;
@property (copy, nonatomic, readonly) NSObject<NSCopying> *JSONObject;

@end
