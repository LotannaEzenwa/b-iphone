//
//  BBTableSection.h
//  Boredat
//
//  Created by Dmitry Letko on 5/22/12.
//  Copyright (c) 2012 Scand Ltd. All rights reserved.
//

@interface BBTableSection : NSObject
@property (copy, nonatomic, readwrite) NSString *title;
@property (copy, nonatomic, readwrite) NSArray *cells;
@property (copy, nonatomic, readwrite) NSIndexSet *manualRows;
@property (copy, nonatomic, readonly) NSArray *rows;
@property (assign, nonatomic, readonly) NSUInteger cellsCount;
@property (assign, nonatomic, readonly) NSUInteger rowsCount;

+ (id)section;
+ (id)sectionWithTitle:(NSString *)title;

- (id)initWithTitle:(NSString *)title;

- (UITableViewCell *)cellWithIndex:(NSUInteger)index;
- (UITableViewCell *)cellForRow:(NSUInteger)row;

@end
