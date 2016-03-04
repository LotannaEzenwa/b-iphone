//
//  LogUtils.h
//  Boredat
//
//  Created by Dmitry Letko on 5/16/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#ifdef DEBUG
#define DLog(...)		NSLog(__VA_ARGS__)
#define DAssert(...)	NSAssert(__VA_ARGS__)
#else
#define DLog(...)
#define DAssert(...)
#endif

#define RLog(...)			NSLog(__VA_ARGS__)
#define RAssert(...)		NSAssert(__VA_ARGS__)

#define DAssertMainThread() {DAssert(([NSThread isMainThread] == YES), @"[%@ %@] must be in the main thread", [self class], NSStringFromSelector(_cmd));}
#define DLogSelector() {DLog(@"%@ %@", self, NSStringFromSelector(_cmd));}
#define RLogSelector() {RLog(@"%@ %@", self, NSStringFromSelector(_cmd));}
#define DLogFunction() {DLog(@"%s", __FUNCTION__);}
#define RLogFunction() {RLog(@"%s", __FUNCTION__);}