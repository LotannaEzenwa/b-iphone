//
//  BBKeychainToken.m
//  Boredat
//
//  Created by Dmitry Letko on 3/18/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBKeychainToken.h"

#import "BBToken.h"

#import "MgmtUtils.h"
#import "LogUtils.h"


@interface BBKeychainToken ()
{
@private
    BOOL _needsLoad;
}

@property (copy, nonatomic, readwrite) NSDictionary *query;

- (void)loadIfNecessary;
- (void)load;

- (void)upload;

- (void)setNeedsLoad;
- (void)setNeedsUpload;

@end


@implementation BBKeychainToken

@synthesize token = _token;

- (id)initWithLabel:(NSString *)label
{
    self = [super init];
    
    if (self != nil)
    {
        _needsLoad = YES;
        _label = [label copy];
    }
    
    return self;
}


#pragma mark -
#pragma mark public

- (void)setToken:(BBToken *)token
{    
    if ([self.token isEqualToToken:token] == NO)
    {
        if (_token != nil)
        {
            _token = nil;
        }
        
        if (token != nil)
        {
            _token = [token copy];
        }
        
        [self setNeedsUpload];
    }
}

- (BBToken *)token
{
    [self loadIfNecessary];
    
    return _token;
}


#pragma mark -
#pragma mark private

- (NSDictionary *)query
{
    if (_query == nil)
    {
        _query = [[NSDictionary alloc] initWithObjectsAndKeys:
                  (__bridge id)kSecClassKey, (__bridge id)kSecClass,
                  (id)kCFBooleanTrue, (__bridge id)kSecAttrCanSign,
                  (__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly, (__bridge id)kSecAttrAccessible,
                  (id)_label, (__bridge id)kSecAttrLabel, nil];
    }
    
    return _query;
}

- (void)loadIfNecessary
{
    if (_needsLoad == YES)
    {
        [self load];
    }
}

- (void)load
{
    _needsLoad = NO;
    
    NSMutableDictionary *query = [self.query mutableCopy];
    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [query setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    NSData *data = nil;
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (void *)&data);
    
    if (status == noErr)
    {        
        if ([data isKindOfClass:[NSData class]] == YES)
        {                        
            if (data != nil)
            {
                BBToken *token = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                
                if (_token != nil)
                {
                    _token = nil;
                }
                
                if (token != nil)
                {
                    _token = token;
                }
            }
        }
    }
    else
    {
        DLogFunction();
        DLog(@"\t error: %d", (int)status);
    }
    
}

- (void)upload
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_token];
        
    NSDictionary *query = self.query;
    NSDictionary *attributes = [[NSDictionary alloc] initWithObjectsAndKeys:data, (__bridge id)kSecValueData, nil];
    
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributes);
    
    if (status == errSecItemNotFound)
    {        
        NSMutableDictionary *fullAttributes = [attributes mutableCopy];
        [fullAttributes addEntriesFromDictionary:query];
        
        status = SecItemAdd((__bridge CFDictionaryRef)fullAttributes, NULL);
        
    }
    
    if (status != noErr)
    {
        DLogFunction();
        DLog(@"\t error: %d", (int)status);
    }
    
}

- (void)setNeedsLoad
{
    _needsLoad = YES;
}

- (void)setNeedsUpload
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(upload) object:nil];
    [self performSelector:@selector(upload) withObject:nil afterDelay:0.0];
}

@end
