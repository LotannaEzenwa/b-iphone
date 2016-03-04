//
//  BBContainerViewController.h
//  Boredat
//
//  Created by Dmitry Letko on 2/11/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBViewController.h"


@interface BBContainerViewController : BBViewController

- (void)addViewController:(UIViewController *)viewController;
- (NSArray *)viewControllers;

@end


@interface UIViewController (BBContainerViewController)

- (void)removeFromContainer;
- (UIViewController *)container;

@end