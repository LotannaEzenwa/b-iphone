//
//  BBUserImageFetcher.m
//  Boredat
//
//  Created by Dmitry Letko on 3/19/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBUserImageFetcher.h"
#import "BBUserImageFetchOperation.h"
#import "BBUserImage.h"

#import "BBApplicationSettings.h"

#import "MgmtUtils.h"


@interface BBUserImage ()
@property (nonatomic, readwrite) BOOL loading;

@end


@interface BBUserImageFetcher () /*<NSCacheDelegate>*/
@property (strong, nonatomic, readwrite) NSCache *cache;
@property (strong, nonatomic, readwrite) NSMutableDictionary *loadingListOfImages;
@property (strong, nonatomic, readwrite) NSOperationQueue *operationQueue;
@property (strong, nonatomic, readwrite) NSMutableDictionary *operations;
@property (copy, nonatomic, readwrite) NSString *imagesFolder;

@end


@implementation BBUserImageFetcher

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        _loadingListOfImages = [NSMutableDictionary new];
                
        _cache = [NSCache new];        
        _cache.name = @"app.BBUserImageFetcher.cache";
        _cache.countLimit = NSUIntegerMax;
                
        _operationQueue = [NSOperationQueue new];
        _operationQueue.name = @"app.BBUserImageFetcher.operationQueue";
        
        _operations = [NSMutableDictionary new];
        
        _pathToImages = [BBApplicationSettings picturesPath];
        _user = [BBApplicationSettings picturesLogin];
        _password = [BBApplicationSettings picturesPassword];
        _folderName = [BBApplicationSettings picturesFolder];
        
        NSArray *cacheFolders = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheFolder = cacheFolders.lastObject;
        _imagesFolder = [cacheFolder stringByAppendingPathComponent:_folderName];
    }
    
    return self;
}

static BBUserImageFetcher *instance = nil;

+ (BBUserImageFetcher *)sharedInstance
{
    static dispatch_once_t initialize;
    
    dispatch_once(&initialize, ^{
        instance = [self new];
    });
    
    return instance;
}

#pragma mark -
#pragma mark public

- (void)setFolderName:(NSString *)folderName
{
    if ([_folderName isEqualToString:folderName] == NO && _folderName != folderName)
    {
        
        if (folderName.length > 0)
        {
            NSArray *cacheFolders = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *cacheFolder = cacheFolders.lastObject;
            NSString *imagesFolder = [cacheFolder stringByAppendingPathComponent:folderName];
                        
            _folderName = [folderName copy];
            _imagesFolder = [imagesFolder copy];
        }
    }
}

- (BBUserImage *)thumbnailImageWithImageName:(NSString *)imageName
{
    if (imageName != nil)
    {
        // If screenname exists but doesn't have an avatar yet, make the filepath an empty string
        if ([imageName isEqualToString:@""])
        {
            BBUserImage *anonImage = [BBUserImage new];
            anonImage.loading = NO;
            anonImage.filepath = @"";
            return anonImage;
        }
        
        BBUserImage *userImage = [_cache objectForKey:imageName];
        
        if (userImage == nil)
        {
            userImage = [_loadingListOfImages objectForKey:imageName];
            
            if (userImage == nil)
            {
                userImage = [BBUserImage new];
            }
            
            [_cache setObject:userImage forKey:imageName];
        }
        
        if (userImage.filepath == nil && userImage.loading == NO)
        {            
            NSString *filenameOfImage = [[NSString alloc] initWithFormat:@"%@_thumbnail.jpg", imageName];
            NSString *pathToImage = [_pathToImages stringByAppendingPathComponent:filenameOfImage];
            
            NSString *localPathOfImage = [_imagesFolder stringByAppendingPathComponent:filenameOfImage];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            BOOL isDirectory = YES;
            BOOL fileExists = [fileManager fileExistsAtPath:localPathOfImage isDirectory:&isDirectory];
            
            if (fileExists == YES && isDirectory == NO)
            {
                userImage.filepath = localPathOfImage;
            }
            else
            {
                userImage.loading = YES;
                BBUserImageFetchOperation *operation = [BBUserImageFetchOperation new];
                operation.localPathOfImage = localPathOfImage;
                operation.pathToImage = pathToImage;
                operation.password = _password;
                operation.user = _user;
                __weak BBUserImageFetchOperation *weakoperation = operation;
                operation.completionBlock = ^{
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [_loadingListOfImages removeObjectForKey:imageName];
                        [_operations removeObjectForKey:userImage];
                                                
                        if (weakoperation.success == YES)
                        {
                            userImage.filepath = localPathOfImage;
                        }
                        
                        userImage.loading = NO;
                    });
                };
                
                [_loadingListOfImages setObject:userImage forKey:imageName];
                [_operations setObject:operation forKey:userImage];
                [_operationQueue addOperation:operation];
                
            }
            
        }
        
        return userImage;
    }
    
    return nil;
}

- (void)cancelLoadingOfAllImages
{
    [_operationQueue cancelAllOperations];
    
    [_loadingListOfImages enumerateKeysAndObjectsUsingBlock:^(id key, BBUserImage *userImage, BOOL *stop) {
        userImage.loading = NO;
    }];
}

@end
