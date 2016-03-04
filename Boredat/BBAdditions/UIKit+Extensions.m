//
//  UIKit+Extensions.m
//  Boredat
//
//  Created by Dmitry Letko on 1/22/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "UIKit+Extensions.h"

#import <QuartzCore/CATransaction.h>


BOOL UIVIewControllerSupportsDidLayout = NO;
BOOL UIVIewControllerSupportsContainers = NO;
BOOL UIViewControllerSupportsAppearanceTransitions = NO;
float kFadeDurationDefault = 0.25f;


inline UIViewAnimationOptions UIViewAnimationOptionsWithCurve(UIViewAnimationCurve curve)
{
    switch (curve)
    {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
            
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
            
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
            
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
    }
}


@implementation UIViewController (PresentController)


# pragma mark Alert Displays

- (void)showAlertViewWithMessage:(NSString *)message
{
    NSError *error = [NSError errorWithDomain:@"error" code:0 userInfo:[NSDictionary dictionaryWithObject:message forKey:@"NSLocalizedDescription"]];
    [self showAlertViewWithError:error];
}

- (void)showAlertViewWithError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

# pragma mark View animations

- (void)fadeInView:(UIView *)view duration:(CGFloat)duration completion:(void (^)())completion
{
    [self fadeInViews:@[view] duration:duration completion:completion];
}

- (void)fadeOutView:(UIView *)view duration:(CGFloat)duration completion:(void (^)())completion
{
    [self fadeOutViews:@[view] duration:duration completion:completion];
}

- (void)fadeInViews:(NSArray *)views duration:(CGFloat)duration completion:(void (^)())completion
{
    for (UIView *view in views)
    {
        if (view.hidden == NO)
        {
            if (completion != nil)
            {
                completion();
            }
            return;
        }
        [view setAlpha:0.0f];
        view.hidden = NO;
    }
    
    [UIView animateWithDuration:duration animations:^{
        for (UIView *view in views)
        {
            [view setAlpha:1.0f];
        }
     } completion:^(BOOL finished)
     {
         if (completion != nil)
         {
             completion();
         }
     }];
}

- (void)fadeOutViews:(NSArray *)views duration:(CGFloat)duration completion:(void (^)())completion
{
    for (UIView *view in views)
    {
        if (view.hidden == YES)
        {
            if (completion != nil)
            {
                completion();
            }
            return;
        }
        [view setAlpha:1.0f];
    }
    
    [UIView animateWithDuration:duration animations:^{
        for (UIView *view in views)
        {
            [view setAlpha:0.0f];
        }
    } completion:^(BOOL finished)
    {
        for (UIView *view in views)
        {
            view.hidden = YES;
        }
        
        if (completion != nil)
        {
            completion();
        }
    }];
}

- (void)hideKeyboard
{
    UIView *responder = [self.view findFirstResponder];
    if (responder != nil)
    {
        [responder resignFirstResponder];
    }
}

@end


@implementation UINavigationController (PresentController)

- (UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    
    UIViewController *viewController = [self popViewControllerAnimated:animated];
    
    [CATransaction commit];
    
    
    return viewController;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    
    NSArray *viewControllers = [self popToViewController:viewController animated:animated];
    
    [CATransaction commit];
    
    
    return viewControllers;
}

- (void)pushViewControllerWithFade:(UIViewController *)controller
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];
    [self pushViewController:controller animated:NO];
}

- (void)popViewControllerWithFade:(UIViewController *)controller
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];
    [self popViewControllerAnimated:NO];
}

- (void)popToRootViewControllerWithFade
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];
    [self popToRootViewControllerAnimated:NO];
}

@end


@implementation UIView (Extensions)

+ (void)setAnimationsEnabled:(BOOL)enabled inBlock:(void (^)(void))block
{
    const BOOL areAnimationEnabled = [self areAnimationsEnabled];
    
    [self setAnimationsEnabled:enabled];
    
    block();
    
    [self setAnimationsEnabled:areAnimationEnabled];
}

- (void)addSlightShadow
{
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 1;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowRadius = 0.5f;
    self.layer.masksToBounds = NO;
}

- (UIView *)findFirstResponder
{
    if (self.isFirstResponder == YES)
    {
        return self;
    }
    
    for (UIView *subview in self.subviews)
    {
        UIView *firstResponder = [subview findFirstResponder];
        
        if (firstResponder != nil)
        {
            return firstResponder;
        }
    }
    
    return nil;
}

@end


@implementation UITableView (Extensions)

- (void)reloadVisibleRowsWithRowAnimation:(UITableViewRowAnimation)animation
{
    NSArray *indexPathsOfVisibleRows = [self indexPathsForVisibleRows];
    
    [self reloadRowsAtIndexPaths:indexPathsOfVisibleRows withRowAnimation:animation];
}

@end

@implementation UIImage (Extensions)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end


@implementation UIColor (Extensions)

+ (id)colorWithRGB:(uint32_t)HEX
{
    const CGFloat red = ((HEX >> 16) & 0xFF) / 255.0f;
    const CGFloat green = ((HEX >> 8) & 0xFF) / 255.0f;
    const CGFloat blue = (HEX & 0xFF) / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

+ (id)colorWithRGBA:(uint32_t)HEX
{
    const CGFloat red = ((HEX >> 24) & 0xFF) / 255.0f;
    const CGFloat green = ((HEX >> 16) & 0xFF) / 255.0f;
    const CGFloat blue = ((HEX >> 8) & 0xFF) / 255.0f;
    const CGFloat alpha = (HEX & 0xFF) / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (id)darkBlueColor
{
    static const CGFloat red = 45.0f / 255.0f;
    static const CGFloat green = 42.0f / 255.0f;
    static const CGFloat blue = 98.0f / 255.0f;
    static const CGFloat alpha = 1.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (id)veryDarkGreenColor
{
    static const CGFloat red = 28.0f / 255.0f;
    static const CGFloat green = 89.0f / 255.0f;
    static const CGFloat blue = 32.0f / 255.0f;
    static const CGFloat alpha = 1.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (id)veryDarkBlueColor
{
    static const CGFloat red = 24.0f / 255.0f;
    static const CGFloat green = 19.0f / 255.0f;
    static const CGFloat blue = 74.0f / 255.0f;
    static const CGFloat alpha = 1.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (id)violetColor
{
    static const CGFloat red = 43.0f / 255.0f;
    static const CGFloat green = 42.0f / 255.0f;
    static const CGFloat blue = 102.0f / 255.0f;
    static const CGFloat alpha = 1.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (id)goldColor
{
    static const CGFloat red = 240.0f / 255.0f;
    static const CGFloat green = 184.0f / 255.0f;
    static const CGFloat blue = 0.0f / 255.0f;
    static const CGFloat alpha = 1.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (id)greyColor
{
    static const CGFloat red = 204.0f / 255.0f;
    static const CGFloat green = 204.0f / 255.0f;
    static const CGFloat blue = 204.0f / 255.0f;
    static const CGFloat alpha = 1.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (id)agreeColor
{
    static const CGFloat red = 18.0f / 255.0f;
    static const CGFloat green = 113.0f / 255.0f;
    static const CGFloat blue = 0.0f / 255.0f;
    static const CGFloat alpha = 1.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (id)disagreeColor
{
    static const CGFloat red = 251.0f / 255.0f;
    static const CGFloat green = 0.0f / 255.0f;
    static const CGFloat blue = 0.0f / 255.0f;
    static const CGFloat alpha = 1.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (id)darkGreenColor
{    
    static const CGFloat red = 50.0f / 255.0f;
    static const CGFloat green = 90.0f / 255.0f;
    static const CGFloat blue = 22.0f / 255.0f;
    static const CGFloat alpha = 1.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

// Color manipulation

+ (id)lighterColorForColor:(UIColor *)color
{
    CGFloat r, g, b, a;
    if ([color getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + 0.4, 1.0)
                               green:MIN(g + 0.4, 1.0)
                                blue:MIN(b + 0.4, 1.0)
                               alpha:a];
    return nil;
}

+ (id)darkerColorForColor:(UIColor *)color
{
    CGFloat r, g, b, a;
    if ([color getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.4, 0.0)
                               green:MAX(g - 0.4, 0.0)
                                blue:MAX(b - 0.4, 0.0)
                               alpha:a];
    return nil;
}

+ (id)colorForColor:(UIColor *)color withOpacity:(CGFloat)opacity
{
    CGFloat r, g, b, a;
    if ([color getRed:&r green:&g blue:&b alpha:&a])
        return [[UIColor alloc] initWithRed:r green:g blue:b alpha:a*opacity];
    return nil;
}

+ (id)colorWithHexString:(NSString *)string
{
    // Convert to hex int
    unsigned hexInt = 0;
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&hexInt];
    
    return [UIColor colorWithRed:((hexInt & 0xFF0000) >> 16)/255.0 green:((hexInt & 0xFF00) >> 8)/255.0 blue:(hexInt & 0xFF)/255.0 alpha:1.0];
}

@end
