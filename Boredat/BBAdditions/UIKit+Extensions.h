//
//  UIKit+Extensions.h
//  Boredat
//
//  Created by Dmitry Letko on 1/22/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#define SYSTEM_VERSION_COMPARE_TO(v)                ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch])
#define SYSTEM_VERSION_EQUAL_TO(v)                  (SYSTEM_VERSION_COMPARE_TO(v) == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              (SYSTEM_VERSION_COMPARE_TO(v) == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  (SYSTEM_VERSION_COMPARE_TO(v) != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 (SYSTEM_VERSION_COMPARE_TO(v) == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     (SYSTEM_VERSION_COMPARE_TO(v) != NSOrderedDescending)


extern BOOL UIVIewControllerSupportsDidLayout;
extern BOOL UIVIewControllerSupportsContainers;
extern BOOL UIViewControllerSupportsAppearanceTransitions;
extern float kFadeDurationDefault;



extern inline UIViewAnimationOptions UIViewAnimationOptionsWithCurve(UIViewAnimationCurve curve);


@interface UIViewController (Extensions)

- (void)showAlertViewWithMessage:(NSString *)message;
- (void)showAlertViewWithError:(NSError *)error;

- (void)fadeInView:(UIView *)view duration:(CGFloat)duration completion:(void (^)())completion;
- (void)fadeOutView:(UIView *)view duration:(CGFloat)duration completion:(void (^)())completion;

- (void)fadeInViews:(NSArray *)views duration:(CGFloat)duration completion:(void (^)())completion;
- (void)fadeOutViews:(NSArray *)views duration:(CGFloat)duration completion:(void (^)())completion;
- (void)hideKeyboard;

@end


@interface UINavigationController (PresentController)

- (UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)pushViewControllerWithFade:(UIViewController *)viewController;
- (void)popViewControllerWithFade:(UIViewController *)viewController;
- (void)popToRootViewControllerWithFade;

@end


@interface UIPopoverController (PresentController)

- (void)dismissPopoverAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end


@interface UIView (Extensions)

+ (void)setAnimationsEnabled:(BOOL)enabled inBlock:(void (^)(void))block;
- (void)addSlightShadow;
- (UIView *)findFirstResponder;

@end


@interface UITableView (Extensions)

- (void)reloadVisibleRowsWithRowAnimation:(UITableViewRowAnimation)animation;

@end

@interface UIImage (Extensions)

+ (UIImage *)imageWithColor:(UIColor *)color;

@end


@interface UIColor (Extensions)

+ (id)colorWithRGB:(uint32_t)HEX;
+ (id)colorWithRGBA:(uint32_t)HEX;

+ (id)violetColor;
+ (id)goldColor;
+ (id)greyColor;
+ (id)agreeColor;
+ (id)disagreeColor;
+ (id)darkGreenColor;
+ (id)darkBlueColor;
+ (id)veryDarkGreenColor;
+ (id)veryDarkBlueColor;

+ (id)lighterColorForColor:(UIColor *)color;
+ (id)darkerColorForColor:(UIColor *)color;

+ (id)colorForColor:(UIColor *)color withOpacity:(CGFloat)opacity;
+ (id)colorWithHexString:(NSString *)string;



@end