//
//  BBUserImageFetcher.h
//  Boredat
//
//  Created by Dmitry Letko on 3/19/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//


@class BBUserImage;

@interface BBUserImageFetcher : NSObject

@property (copy, nonatomic, readwrite) NSString *pathToImages;
@property (copy, nonatomic, readwrite) NSString *user;
@property (copy, nonatomic, readwrite) NSString *password;
@property (copy, nonatomic, readwrite) NSString *folderName;

+ (BBUserImageFetcher *)sharedInstance;
- (BBUserImage *)thumbnailImageWithImageName:(NSString *)imageName;
- (void)cancelLoadingOfAllImages;

@end
