//
//  BBMainFeedPagesView.m
//  Boredat
//
//  Created by Lesha on 7/16/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBMainFeedPagesView.h"
#import "UIKit+Extensions.h"

#import "BBPageButton.h"
#import "BBApplicationSettings.h"

static CGFloat const kButtonSeparatorWidth = 10.0f;

NSInteger const kPagesViewHeight = 50;

@interface BBMainFeedPagesView ()

{
    NSInteger _currentIndex;
    
    BBPageButton *_previousPageButton;
    BBPageButton *_firstPageButton;
    BBPageButton *_nextPageButton;
    
    NSMutableArray *_numberButtons;
    NSMutableArray *_allButtons;
}

@property (strong, nonatomic, readonly) NSMutableArray *arrayOfButton;

@end

@implementation BBMainFeedPagesView


- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        CGRect topRect = CGRectMake(0.0f, 0.0f, CGRectGetWidth(frame), 1.0f);
        UIView *topSeparator = [[UIView alloc] initWithFrame:topRect];
        topSeparator.backgroundColor = [UIColor greyColor];
        [self addSubview:topSeparator];
        [self bringSubviewToFront:topSeparator];
        
        CGRect bottomRect = CGRectMake(0.0f, kPagesViewHeight, CGRectGetWidth(frame), 1.0f);
        UIView *bottomSeparator = [[UIView alloc] initWithFrame:bottomRect];
        bottomSeparator.backgroundColor = [UIColor greyColor];
        [self addSubview:bottomSeparator];
        [self bringSubviewToFront:bottomSeparator];
        
        self.contentMode = UIViewContentModeScaleAspectFit;
        
        _numberButtons = [NSMutableArray new];
        _allButtons = [NSMutableArray new];
        _currentIndex = 1;
        
        [self createNavigationButtons];
        [self createPageButtons];
    }
    return self;
}

- (void)pageButtonClicked:(BBPageButton *)sender
{
    if (sender.pageButtonType == PageButtonTypeNumber)
    {
        NSInteger index = sender.pageNumber;
        if (sender.pageNumber == 2 && _currentIndex == 1)
        {
            for (NSInteger i = 0; i < [_numberButtons count]; i++)
            {
                BBPageButton *pageButton = _numberButtons[i];
                pageButton.selected = (i == 1) ? YES : NO;
                [pageButton sizeToFit];
            }
        }
        else if (sender.pageNumber == 1)
        {
            for (NSInteger i = 0; i < [_numberButtons count]; i++)
            {
                BBPageButton *pageButton = _numberButtons[i];
                pageButton.pageNumber = i + 1;
                pageButton.selected = (i == 0) ? YES : NO;
                [pageButton sizeToFit];
            }
        }
        else if (sender.pageNumber == _pages - 1)
        {
            for (NSInteger i = 0; i < [_numberButtons count]; i++)
            {
                BBPageButton *pageButton = _numberButtons[i];
                pageButton.pageNumber = _pages - (2 - i);
                pageButton.selected = (i == 1) ? YES : NO;
                [pageButton sizeToFit];
            }
            _currentIndex--;
        }
        else if (sender.pageNumber == _pages)
        {
            for (NSInteger i = 0; i < [_numberButtons count]; i++)
            {
                BBPageButton *pageButton = _numberButtons[i];
                pageButton.pageNumber = _pages - (2 - i);
                pageButton.selected = (i == 2) ? YES : NO;
                [pageButton sizeToFit];
            }
            _currentIndex++;
        }
        else if (sender.pageNumber > _currentIndex && sender.pageNumber != _pages)
        {
            [self moveToNextPage];
        }
        else if (sender.pageNumber < _currentIndex && sender.pageNumber != 1)
        {
            [self moveToPreviousPage];
        }
        
         _currentIndex = index;
    }
    else if (sender.pageButtonType == PageButtonTypeNext)
    {
        if (_currentIndex == 1)
        {
            for (NSInteger i = 0; i < [_numberButtons count]; i++)
            {
                BBPageButton *pageButton = _numberButtons[i];
                pageButton.pageNumber = i + 1;
                pageButton.selected = (i == 1) ? YES : NO;
                [pageButton sizeToFit];
            }
            _currentIndex++;
        }
        else if (_currentIndex == _pages - 1)
        {
            for (NSInteger i = 0; i < [_numberButtons count]; i++)
            {
                BBPageButton *pageButton = _numberButtons[i];
                pageButton.pageNumber = _pages - (2 - i);
                pageButton.selected = (i == 2) ? YES : NO;
                [pageButton sizeToFit];
            }
            _currentIndex++;
        }
        else if (_currentIndex < _pages)
        {
            [self moveToNextPage];
            _currentIndex++;
        }
    }
    else if (sender.pageButtonType == PageButtonTypePrevious)
    {
        if (_currentIndex == 2)
        {
            for (NSInteger i = 0; i < [_numberButtons count]; i++)
            {
                BBPageButton *pageButton = _numberButtons[i];
                pageButton.pageNumber = i + 1;
                pageButton.selected = (i == 0) ? YES : NO;
                [pageButton sizeToFit];
            }
            _currentIndex--;
        }
        else if (_currentIndex == _pages)
        {
            for (NSInteger i = 0; i < [_numberButtons count]; i++)
            {
                BBPageButton *pageButton = _numberButtons[i];
                pageButton.pageNumber = _pages - (2 - i);
                pageButton.selected = (i == 1) ? YES : NO;
                [pageButton sizeToFit];
            }
            _currentIndex--;
        }
        else if (_currentIndex > 1)
        {
            [self moveToPreviousPage];
            _currentIndex--;            
        }
    }
    else if (sender.pageButtonType == PageButtonTypeFirst)
    {
        for (NSInteger i = 0; i < [_numberButtons count]; i++)
        {
            BBPageButton *pageButton = _numberButtons[i];
            pageButton.pageNumber = i + 1;
            pageButton.selected = (i == 0) ? YES : NO;
            [pageButton sizeToFit];
        }
        
        _currentIndex = 1;
    }
    
    [self layoutIfNeeded];
    
    [self showNecessaryNavigationButtons];
    
    [_pageDelegate pagesViewClickonPage:_currentIndex];
}

- (void)updateButtonTitles
{
    if (_currentIndex == 1)
    {
        for (NSInteger i = 0; i < [_numberButtons count]; i++)
        {
            BBPageButton *pageButton = _numberButtons[i];
            pageButton.pageNumber = _currentIndex + i;
            pageButton.selected = (i == 0) ? YES : NO;
            [pageButton sizeToFit];
        }
    }
    else if (_currentIndex == _pages)
    {
        for (NSInteger i = 0; i < [_numberButtons count]; i++)
        {
            BBPageButton *pageButton = _numberButtons[i];
            pageButton.pageNumber = _currentIndex + (i - 2);
            pageButton.selected = (i == 2) ? YES : NO;
            [pageButton sizeToFit];
        }
    }
    else
    {
        for (NSInteger i = 0; i < [_numberButtons count]; i++)
        {
            BBPageButton *pageButton = _numberButtons[i];
            pageButton.pageNumber = _currentIndex + (i - 1);
            pageButton.selected = (i == 1) ? YES : NO;
            [pageButton sizeToFit];
        }
    }
    
}

- (void)createNavigationButtons
{
    UIColor *buttonColor = [UIColor blackColor];
    UIFont *buttonFont = [BBApplicationSettings fontForKey:kFontPageUnselected];
    
    _nextPageButton = [BBPageButton new];
    [_nextPageButton addTarget:self action:@selector(pageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _nextPageButton.pageButtonType = PageButtonTypeNext;
    [_nextPageButton setTitle:@">" forState:UIControlStateNormal];
    [_nextPageButton setTitleColor:buttonColor forState:UIControlStateNormal];
    _nextPageButton.titleLabel.font = buttonFont;
    [_nextPageButton sizeToFit];
    [self addSubview:_nextPageButton];
    [_allButtons addObject:_nextPageButton];
    
    _previousPageButton = [BBPageButton new];
    [_previousPageButton addTarget:self action:@selector(pageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _previousPageButton.pageButtonType = PageButtonTypePrevious;
    [_previousPageButton setTitle:@"<" forState:UIControlStateNormal];
    [_previousPageButton setTitleColor:buttonColor forState:UIControlStateNormal];
    _previousPageButton.titleLabel.font = buttonFont;
    [_previousPageButton sizeToFit];
    _previousPageButton.hidden = YES;
    [self addSubview:_previousPageButton];
    [_allButtons addObject:_previousPageButton];
    
    _firstPageButton = [BBPageButton new];
    [_firstPageButton addTarget:self action:@selector(pageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _firstPageButton.pageButtonType = PageButtonTypeFirst;
    [_firstPageButton setTitle:@"First" forState:UIControlStateNormal];
    [_firstPageButton setTitleColor:buttonColor forState:UIControlStateNormal];
    _firstPageButton.titleLabel.font = buttonFont;
    [_firstPageButton sizeToFit];
    _firstPageButton.hidden = YES;
    [self addSubview:_firstPageButton];
    [_allButtons addObject:_firstPageButton];
}

- (void)createPageButtons
{
    UIColor *buttonColor = [UIColor blackColor];
    UIFont *buttonFont = [BBApplicationSettings fontForKey:kFontPageUnselected];
    
    for (NSInteger i = 0; i < 3; i++)
    {
        BBPageButton *pageButton = [BBPageButton new];
        [pageButton addTarget:self action:@selector(pageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        pageButton.pageButtonType = PageButtonTypeNumber;
        pageButton.pageNumber = i + 1;

        [pageButton setTitleColor:buttonColor forState:UIControlStateNormal];
        pageButton.titleLabel.font = buttonFont;
        if (pageButton.pageNumber == 1)
        {
            pageButton.selected = YES;
        }
        [pageButton sizeToFit];
        
        [self addSubview:pageButton];
        [_numberButtons addObject:pageButton];
        [_allButtons addObject:pageButton];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    BBPageButton *unitButton = _previousPageButton;
    CGFloat buttonOriginY = CGRectGetHeight(self.bounds)/2 - CGRectGetHeight(unitButton.bounds)/2;
    
    // First page button
    CGFloat firstPageOriginX = kButtonSeparatorWidth;
    CGRect firstPageRect = CGRectMake(firstPageOriginX, buttonOriginY,
                                         CGRectGetWidth(_firstPageButton.bounds), CGRectGetHeight(_firstPageButton.bounds));
    _firstPageButton.frame = firstPageRect;
    
    // Center number buttons
    CGFloat numberButtonsOrigin = CGRectGetWidth(self.bounds)/2 - ((CGRectGetWidth(unitButton.bounds) * 1.5) + kButtonSeparatorWidth);
    [_numberButtons enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop){
        BBPageButton *pageButton = (BBPageButton *)object;
        
        CGFloat buttonOriginX = numberButtonsOrigin + ((CGRectGetWidth(pageButton.bounds) + kButtonSeparatorWidth) * index);
        
        CGRect pageButtonRect = CGRectMake(buttonOriginX, buttonOriginY, CGRectGetWidth(pageButton.bounds), CGRectGetHeight(pageButton.bounds));
        pageButton.frame = pageButtonRect;
    }];

    // Previous page button
    CGFloat previousPageOriginX = numberButtonsOrigin - (CGRectGetWidth(_previousPageButton.bounds) + kButtonSeparatorWidth);
    CGRect previousPageRect = CGRectMake(previousPageOriginX, buttonOriginY, CGRectGetWidth(_previousPageButton.bounds), CGRectGetHeight(_previousPageButton.bounds));
    _previousPageButton.frame = previousPageRect;

    // Next page button
    CGFloat nextPageOriginX = (CGRectGetWidth(self.bounds) - numberButtonsOrigin) + kButtonSeparatorWidth;
    CGRect nextPageRect = CGRectMake(nextPageOriginX, buttonOriginY, CGRectGetWidth(_nextPageButton.bounds), CGRectGetHeight(_nextPageButton.bounds));
    _nextPageButton.frame = nextPageRect;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    [self showNecessaryNavigationButtons];
    
    [self updateButtonTitles];
    [self layoutIfNeeded];
}

- (void)showNecessaryNavigationButtons
{
    if (_currentIndex == 1)
    {
        _firstPageButton.hidden = YES;
        _previousPageButton.hidden = YES;
        _nextPageButton.hidden = NO;
    }
    else if (_currentIndex == _pages)
    {
        _nextPageButton.hidden = YES;
        _firstPageButton.hidden = NO;
        _previousPageButton.hidden = NO;
    }
    else
    {
        _firstPageButton.hidden = NO;
        _previousPageButton.hidden = NO;
        _nextPageButton.hidden = NO;
    }
}

#pragma mark -
#pragma mark private methods

- (void)moveToNextPage
{
    for (NSInteger i = 0; i < [_numberButtons count]; i++)
    {
        BBPageButton *pageButton = _numberButtons[i];
        pageButton.pageNumber++;
        pageButton.selected = (i == 1) ? YES : NO;
        [pageButton sizeToFit];
    }
}

- (void)moveToPreviousPage
{
    for (NSInteger i = 0; i < [_numberButtons count]; i++)
    {
        BBPageButton *pageButton = _numberButtons[i];
        pageButton.pageNumber--;
        pageButton.selected = (i == 1) ? YES : NO;
        [pageButton sizeToFit];
    }
}

- (void)findButtonWithLocation:(CGPoint)touchPoint
{
    touchPoint.y = 20.0f;
    for (BBPageButton *button in _allButtons)
    {
        if(CGRectContainsPoint(button.frame, touchPoint))
        {
            [self pageButtonClicked:button];
            break;
        }
    }
}

@end
