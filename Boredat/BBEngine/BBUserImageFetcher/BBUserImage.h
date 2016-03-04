//
//  BBUserImage.h
//  Boredat
//
//  Created by Dmitry Letko on 3/19/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@class BBUserImageFetcher;


@interface BBUserImage : NSObject <NSCopying>
@property (nonatomic, readonly) BOOL loading;
@property (copy, nonatomic, readwrite) NSString *filepath;

//- (void)cancelLoading;

@end
