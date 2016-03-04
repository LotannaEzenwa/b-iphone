//
//  BBUsersPlotView.h
//  Boredat
//
//  Created by Anton Kolosov on 10/9/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import <CorePlot/ios/CorePlot.h>

@interface BBUsersPlotView : UIView <CPTPlotDataSource, CPTBarPlotDataSource, CPTBarPlotDelegate>

@property (copy, nonatomic, readwrite) NSArray *yAxisPoints;

@property (nonatomic, readwrite) CGFloat maxX;
@property (nonatomic, readwrite) CGFloat maxY;

- (id)initWithMaxYValue:(CGFloat)maxValue withMaxXValue:(CGFloat)xValue;

@end
