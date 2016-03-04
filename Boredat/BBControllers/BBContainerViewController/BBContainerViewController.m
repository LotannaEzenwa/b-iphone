//
//  BBContainerViewController.m
//  Boredat
//
//  Created by Dmitry Letko on 2/11/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBContainerViewController.h"

#import "MgmtUtils.h"

#import "UIKit+Extensions.h"

#import <objc/runtime.h>


@interface UIViewController (AssociatedContainer)
@property (assign, nonatomic, readwrite) BBContainerViewController *associatedContainer;

- (void)tryWillMoveToParentViewController:(UIViewController *)viewController;
- (void)tryDidMoveToParentViewController:(UIViewController *)viewController;

@end


@interface BBContainerViewController ()
@property (strong, nonatomic, readwrite) NSMutableArray *viewControllers;

- (void)removeViewController:(UIViewController *)viewController;

@end


@implementation BBContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self != nil)
    {
        if (UIVIewControllerSupportsContainers == NO)
        {
            _viewControllers = [NSMutableArray new];
        }
    }
    
    return self;
}


#pragma mark -
#pragma mark lifecycle

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
     return UIVIewControllerSupportsContainers;   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (UIVIewControllerSupportsContainers == NO)
    {
        if (UIViewControllerSupportsAppearanceTransitions == NO)
        {
            [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
                [viewController viewWillAppear:animated];
            }];
        }
        else
        {
            [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
                [viewController beginAppearanceTransition:YES animated:animated];
            }];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (UIVIewControllerSupportsContainers == NO)
    {
        if (UIViewControllerSupportsAppearanceTransitions == NO)
        {
            [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
                [viewController viewDidAppear:animated];
            }];
        }
        else
        {
            [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
                [viewController endAppearanceTransition];
            }];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (UIVIewControllerSupportsContainers == NO)
    {
        if (UIViewControllerSupportsAppearanceTransitions == NO)
        {
            [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
                [viewController viewWillDisappear:animated];
            }];
        }
        else
        {
            [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
                [viewController beginAppearanceTransition:NO animated:animated];
            }];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (UIVIewControllerSupportsContainers == NO)
    {
        if (UIViewControllerSupportsAppearanceTransitions == NO)
        {
            [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
                [viewController viewDidDisappear:animated];
            }];
        }
        else
        {
            [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
                [viewController endAppearanceTransition];
            }];
        }
    }
}


#pragma mark -
#pragma mark public

- (void)addViewController:(UIViewController *)viewController
{
    if (UIVIewControllerSupportsContainers == YES)
    {
        [self addChildViewController:viewController];
    }
    else
    {
        if (viewController.associatedContainer == nil)
        {
            [viewController tryWillMoveToParentViewController:self];
            [viewController setAssociatedContainer:self];
            
            [_viewControllers addObject:viewController];
            
            [viewController tryDidMoveToParentViewController:self];
        }
    }
}

- (NSArray *)viewControllers
{
    if (UIVIewControllerSupportsContainers == YES)
    {
        return self.childViewControllers;
    }
    else
    {
        return [_viewControllers copy];
    }
}


#pragma mark -
#pragma mark private

- (void)removeViewController:(UIViewController *)viewController
{
    if ([viewController.associatedContainer isEqual:self] == YES)
    {
        [viewController tryWillMoveToParentViewController:nil];
        [viewController setAssociatedContainer:nil];
        
        [_viewControllers removeObject:viewController];
        
        [viewController tryDidMoveToParentViewController:nil];
    }
}

@end


@implementation UIViewController (AssociatedViewController)

static char kAssociatedContainer;

- (void)setAssociatedContainer:(BBContainerViewController *)associatedContainer
{
    objc_setAssociatedObject(self, &kAssociatedContainer, associatedContainer, OBJC_ASSOCIATION_ASSIGN);
}

- (BBContainerViewController *)associatedContainer
{
    return (BBContainerViewController *)objc_getAssociatedObject(self, &kAssociatedContainer);
}

- (void)tryWillMoveToParentViewController:(UIViewController *)viewController
{
    if ([self respondsToSelector:@selector(willMoveToParentViewController:)] == YES)
    {
        [self willMoveToParentViewController:viewController];
    }
}

- (void)tryDidMoveToParentViewController:(UIViewController *)viewController
{
    if ([self respondsToSelector:@selector(didMoveToParentViewController:)] == YES)
    {
        [self didMoveToParentViewController:self];
    }
}

@end


@implementation UIViewController (BBContainerViewController)

#pragma mark -
#pragma mark public

- (void)removeFromContainer
{
    if (UIVIewControllerSupportsContainers == YES)
    {
        [self removeFromParentViewController];
    }
    else
    {
        [self.associatedContainer removeViewController:self];
    }
}

- (UIViewController *)container
{
    if (UIVIewControllerSupportsContainers == YES)
    {
        return self.parentViewController;
    }
    else
    {
        return self.associatedContainer;
    }
}


@end
