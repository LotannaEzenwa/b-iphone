//
//  NSURLResponse+HTTPFields.h
//  Boredat
//
//  Created by Dmitry Letko on 5/16/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

extern const NSInteger cHTTPStatusOK;
extern const NSInteger cHTTPStatusForbidden;


@interface NSURLResponse (HTTPFields)
@property (nonatomic, readonly) BOOL isHTTPResponse;
@property (strong, nonatomic, readonly) NSHTTPURLResponse *HTTPResponse;
@property (nonatomic, readonly) NSInteger status;
@property (nonatomic, readonly) BOOL isSuccess;
@property (nonatomic, readonly) BOOL isForbidden;
@property (nonatomic, readonly) NSUInteger capacityToReserve;
@property (copy, nonatomic, readonly) NSString *statusMeessage;
@property (copy, nonatomic, readonly) NSDate *lastModified;

@end
