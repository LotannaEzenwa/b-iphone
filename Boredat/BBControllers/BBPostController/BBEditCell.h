//
//  BBEditCell.h
//  Boredat
//
//  Created by Dmitry Letko on 5/22/12.
//  Copyright (c) 2012 Scand Ltd. All rights reserved.
//

@interface BBEditCell : UITableViewCell
@property (retain, nonatomic, readonly) UILabel *textLabel;
@property (retain, nonatomic, readonly) UITextField *textField;
@property (assign, nonatomic, readonly) BOOL isEmpty;

+ (id)editCell;
+ (id)editCellWithName:(NSString*)_name 
				 value:(NSString*)_value 
			   keyType:(UIKeyboardType)_keyType 
			  editable:(BOOL)_editable 
				secure:(BOOL)_secure;

- (id)initWithName:(NSString*)_name 
			 value:(NSString*)_value 
		   keyType:(UIKeyboardType)_keyType 
		  editable:(BOOL)_editable 
			secure:(BOOL)_secure;

@end
