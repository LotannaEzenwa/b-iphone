//
//  BBEditCell.m
//  Boredat
//
//  Created by Dmitry Letko on 5/22/12.
//  Copyright (c) 2012 Scand Ltd. All rights reserved.
//

#import "BBEditCell.h"


#define TextLabelTag 5295
#define TextFieldTag 5296


@interface BBEditCell ()

- (void)onTextFieldDidFinish:(id)sender;

@end;


@implementation BBEditCell


static const CGFloat cFontSize = 17.0;
static const CGFloat cSideOffset = 10.0;
static const CGFloat cSideOffset2x = cSideOffset * 2.0f;
static const CGFloat cLabelWidth = 95.0;


+ (id)editCell
{
	return [[self new] autorelease];
}

+ (id)editCellWithName:(NSString *)name 
				 value:(NSString *)value 
			   keyType:(UIKeyboardType)keyType 
			  editable:(BOOL)editable 
				secure:(BOOL)secure
{
	return [[[self alloc] initWithName:name value:value keyType:keyType editable:editable secure:secure] autorelease];
}

- (id)init
{
	return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}

- (id)initWithName:(NSString *)name 
			 value:(NSString *)value 
		   keyType:(UIKeyboardType)keyType 
		  editable:(BOOL)editable 
			secure:(BOOL)secure
{
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	
	if (self != nil)
	{
		UILabel *textLabel = self.textLabel;
		textLabel.text = name;
		
		UITextField *textField = self.textField;
		textField.text = value;
		textField.keyboardType = keyType;
		textField.enabled = editable;
		textField.secureTextEntry = secure;
	}
	
	return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier
{
    self = [super initWithStyle:style reuseIdentifier:identifier];
	
    if (self != nil)
	{
		self.backgroundColor = [UIColor whiteColor];
		self.opaque = YES;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
			
		
		UILabel *textLabel = [UILabel new];
		textLabel.backgroundColor = [UIColor clearColor];
		textLabel.textAlignment = UITextAlignmentLeft;
		textLabel.font = [UIFont boldSystemFontOfSize:cFontSize];
		textLabel.textColor = [UIColor darkTextColor];
		textLabel.tag = TextLabelTag;
				
		UITextField *textField = [UITextField new];
		[textField addTarget:self action:@selector(onTextFieldDidFinish:) forControlEvents:(UIControlEventEditingDidEnd | UIControlEventEditingDidEndOnExit)];	
		textField.backgroundColor = [UIColor clearColor];
		textField.textAlignment = UITextAlignmentLeft;
		textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		textField.returnKeyType = UIReturnKeyDone;
		textField.font = [UIFont systemFontOfSize:cFontSize];
		textField.minimumFontSize = cFontSize;
		textField.adjustsFontSizeToFitWidth = YES;
		textField.textColor = [UIColor colorWithRed:0.21875f green:0.328125f blue:0.52734375f alpha:1];
		textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		textField.tag = TextFieldTag;
		
		
		[self.contentView addSubview:textLabel];
		[self.contentView addSubview:textField];
				
		
		[textLabel release];
		[textField release];
    }
	
    return self;
}


#pragma mark -

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{		
	if (selected == YES) 
	{		
		if ([self canBecomeFirstResponder] == YES) 
		{			
			if ([self becomeFirstResponder] == YES) 
			{
				[super setSelected:YES animated:animated];
			}
		}
	}
	else
	{		
		if ([self canResignFirstResponder] == YES)		
		{			
			if ([self resignFirstResponder] == YES)
			{
				[super setSelected:NO animated:animated];
			}
		}
	}
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	
	const CGRect bounds = self.contentView.bounds;
	const CGFloat width = CGRectGetWidth(bounds);
	const CGFloat height = CGRectGetHeight(bounds);
	const CGFloat textLabelMinX = cSideOffset;
	const CGFloat textLabelWidth = cLabelWidth;
	const CGFloat textFieldMinX = cLabelWidth + cSideOffset2x;
	const CGFloat textFieldWidth = width - (textFieldMinX + cSideOffset);
	
	self.textLabel.frame = CGRectMake(textLabelMinX, 0, textLabelWidth, height);
	self.textField.frame = CGRectMake(textFieldMinX, 0, textFieldWidth, height);
}


#pragma mark -
#pragma mark UIResponder

- (BOOL)isFirstResponder
{
	return [self.textField isFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
	return [self.textField canBecomeFirstResponder];
}

- (BOOL)becomeFirstResponder
{
	return [self.textField becomeFirstResponder];
}

- (BOOL)canResignFirstResponder
{
	return [self.textField canResignFirstResponder];
}

- (BOOL)resignFirstResponder
{
	return [self.textField resignFirstResponder];
}


#pragma mark -
#pragma mark private

- (UILabel *)textLabel
{
	return (UILabel *)[self.contentView viewWithTag:TextLabelTag];
}

- (UITextField *)textField
{
	return (UITextField *)[self.contentView viewWithTag:TextFieldTag];
}

- (BOOL)isEmpty
{
	return (self.textField.text.length == 0);
}


#pragma mark -

- (void)onTextFieldDidFinish:(id)sender
{	
	[(UITextField *)sender resignFirstResponder];
}

@end