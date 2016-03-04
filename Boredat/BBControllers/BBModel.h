//
//  BBModel.h
//  Boredat
//
//  Created by David Pickart on 8/3/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

@class BBFacade;
@class BBPost;

#import "BBGlobalEnums.h"

@protocol BBModelDelegate <NSObject>
- (void)modelDidUpdateData:(id)model;
- (void)modelDidRecieveError:(id)model error:(NSError *)error;
@end

// Protocol for objects that hold and update data
@interface BBModel : NSObject

@property (strong, nonatomic, readwrite) BBFacade *facade;
@property (weak, nonatomic, readwrite) id<BBModelDelegate> delegate;
@property (nonatomic, readwrite) BOOL fetching;
@property (nonatomic, readwrite) BOOL hasData;


- (NSInteger)numberOfObjects;
- (id)objectAtIndex:(NSInteger)index;
- (void)completeAction:(BBPostAction)action forObjectAtIndex:(NSInteger)index;
- (void)replaceObjectAtIndex:(NSInteger)index withObject:(id)object;

- (void)updateDataForced:(BOOL)forced;
- (void)updateDataWithCompletion:(void (^)())block forced:(BOOL)forced;
- (void)clearData;

@end