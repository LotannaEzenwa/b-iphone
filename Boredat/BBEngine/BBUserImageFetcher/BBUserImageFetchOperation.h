//
//  BBUserImageFetchOperation.h
//  Boredat
//
//  Created by Dmitry Letko on 3/19/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

//@class BBUserImage;


@interface BBUserImageFetchOperation : NSOperation
@property (copy, nonatomic, readwrite) NSString *pathToImage;
@property (copy, nonatomic, readwrite) NSString *localPathOfImage;
@property (copy, nonatomic, readwrite) NSString *user;
@property (copy, nonatomic, readwrite) NSString *password;
@property (nonatomic, readonly) BOOL success;
@property (nonatomic, readonly) BOOL isExecuting;
@property (nonatomic, readonly) BOOL isFinished;

@end
