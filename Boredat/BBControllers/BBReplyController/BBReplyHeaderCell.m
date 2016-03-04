//
//  BBReplyHeaderCell.h
//  Boredat
//
//  Created by Dmitry Letko on 1/31/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBReplyHeaderCell.h"
#import "BBUserImage.h"

#import "BBApplicationSettings.h"

#import "MgmtUtils.h"


static NSString *const kUserImage = @"userImage";
static NSString *const kUserImageFilepath = @"userImage.filepath";
static NSString *const kUserImageLoading = @"userImage.loading";


@interface BBReplyHeaderCell ()
@property (strong, nonatomic, readwrite) UILabel *dateLabel;
@property (strong, nonatomic, readwrite) UILabel *networkLabel;
@property (strong, nonatomic, readwrite) UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic, readwrite) UIButton *avatarImageView;

- (void)updateImage;
- (void)updateLoading;

@end


@implementation BBReplyHeaderCell

+ (BOOL)automaticallyNotifiesObserversOfUserImage
{
    return NO;
}
 
+ (id)cellWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [[self alloc] initWithReuseIdentifier:reuseIdentifier];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self != nil)
    {
        UIColor *whiteColor = [UIColor whiteColor];
        
        UIFont *smallFont = [BBApplicationSettings fontForKey:kFontDetailsSmall];
        UIFont *largeFont = [BBApplicationSettings fontForKey:kFontDetailsLarge];
        
        _titleLabel = [UILabel new];
        _titleLabel.backgroundColor = whiteColor;
        _titleLabel.font = largeFont;
        _titleLabel.textColor = [UIColor darkGrayColor];
        
        _dateLabel = [UILabel new];
        [_dateLabel setBackgroundColor:whiteColor];
        _dateLabel.font = smallFont;
        _dateLabel.textColor = [UIColor lightGrayColor];
                
        _networkLabel = [UILabel new];
        [_networkLabel setBackgroundColor:whiteColor];
        _networkLabel.font = smallFont;
        _networkLabel.textColor = [UIColor lightGrayColor];
                
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_indicatorView setBackgroundColor:whiteColor];
        [_indicatorView setUserInteractionEnabled:NO];
        [_indicatorView setHidesWhenStopped:NO];
        [_indicatorView setHidden:YES];
        
        _avatarImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"profile_anonymous-50x50.png"];
        [_avatarImageView setBackgroundImage:image forState:UIControlStateNormal];
        [_avatarImageView addTarget:self action:@selector(onAvatarButton:) forControlEvents:UIControlEventTouchUpInside];
        _avatarImageView.userInteractionEnabled = NO;
        
        
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_dateLabel];
        [self.contentView addSubview:_networkLabel];
        [self.contentView addSubview:_indicatorView];
        [self.contentView addSubview:_avatarImageView];
        
        [self addObserver:self forKeyPath:kUserImageFilepath options:0 context:@selector(updateImage)];
        [self addObserver:self forKeyPath:kUserImageLoading options:0 context:@selector(updateLoading)];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAutoresizesSubviews:NO];
        
        [self configureConstraints];
    }
    
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:kUserImageFilepath];
    [self removeObserver:self forKeyPath:kUserImageLoading];
}

- (void)configureConstraints
{
    [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_dateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_networkLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_indicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_avatarImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // title label
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:10.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:70.0f]];
    
    // date label
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dateLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:70.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dateLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:2.5f]];
    
    // network label
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_networkLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:70.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_networkLabel
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:-10.0f]];
    
    // avatar imageView
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:10.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_avatarImageView(50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_avatarImageView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_avatarImageView(50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_avatarImageView)]];
    
    
    // indicator view
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_avatarImageView
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_avatarImageView
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_avatarImageView
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_avatarImageView
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0
                                                      constant:0.0f]];
}

#pragma mark -
#pragma mark UITableViewCell overload

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    NSString *filepath = _userImage.filepath;
    _avatarImageView.highlighted = filepath != nil;
}

#pragma mark -
#pragma mark NSKeyValueObserving callbacks

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    IMP imp = [self methodForSelector:context];
    void (*func)(id, SEL) = (void *)imp;
    func(self, context);
}


#pragma mark -
#pragma mark public

- (void)setUserImage:(BBUserImage *)userImage
{
    if (_userImage != userImage)
    {
        [self willChangeValueForKey:kUserImage];
        
        if (userImage != nil)
        {
            _userImage = userImage;
        }
        
        [self didChangeValueForKey:kUserImage];
    }
}


#pragma mark -
#pragma mark private

- (void)updateImage
{
    NSString *filepath = _userImage.filepath;
    
    if (filepath != nil)
    {
        // If screenname exists but doesn't have an avatar yet, give it a default avatar
        if ([filepath isEqualToString:@""])
        {
            UIImage *image = [UIImage imageNamed:@"profile_anonymous-50x50.png"];
            [_avatarImageView setBackgroundImage:image forState:UIControlStateNormal];
        }
        else
        {
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:filepath];
            [_avatarImageView setBackgroundImage:image forState:UIControlStateNormal];
        }
    }
    else
    {
        [_avatarImageView setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

- (void)updateLoading
{
    if (_userImage.loading == YES)
    {
        [_indicatorView setHidden:NO];
        [_indicatorView startAnimating];
    }
    else
    {
        [_indicatorView setHidden:YES];
        [_indicatorView stopAnimating];
    }
}

#pragma mark -
#pragma mark GUI callbacks

-(void)onAvatarButton:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(tapOnAvatarwithHeaderCell:)])
    {
        [_delegate tapOnAvatarwithHeaderCell:self];
    }
}

@end
