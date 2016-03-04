//
//  BBUsersPlotView.m
//  Boredat
//
//  Created by Anton Kolosov on 10/9/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBUsersPlotView.h"

@interface BBUsersPlotView ()

{
    CGFloat _maxAxisY;
    CGFloat _maxAxisX;
}

@property (strong, nonatomic, readwrite) CPTGraphHostingView *scatterPlotView;
@property (strong, nonatomic, readwrite) CPTGraph *scatterGraph;
@property (strong, nonatomic, readwrite) CPTScatterPlot *scatterPlot;
@property (strong, nonatomic, readwrite) CPTGraphHostingView *barPlotView;
@property (strong, nonatomic, readwrite) CPTGraph *barGraph;
@property (strong, nonatomic, readwrite) CPTBarPlot *barPlot;

@end

@implementation BBUsersPlotView

#pragma mark -
#pragma mark Initialization

- (id)initWithMaxYValue:(CGFloat)maxValue withMaxXValue:(CGFloat)xValue
{
    self = [super init];
    if (self)
    {
        _maxAxisY = maxValue;
        _maxAxisX = xValue;
        _yAxisPoints = [NSArray new];
        [self configureScatterPlot];
    }
    return self;
}


#pragma mark -
#pragma mark Public methods

- (void)setYAxisPoints:(NSArray *)yAxisPoints
{
    _yAxisPoints = [yAxisPoints copy];
    [self.scatterGraph reloadData];
}

#pragma mark -
#pragma mark Private methods§

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _scatterPlotView.frame = CGRectMake(5.0f, 25.0f, 300.0f, 100.0f);
    _scatterGraph.frame = _scatterPlotView.bounds;
    _scatterPlot.frame = _scatterGraph.bounds;
    _barPlotView.frame = CGRectMake(10.0f, 125.0f, 300.0f, 60.0f);
    _barGraph.frame = _barPlotView.bounds;
}

- (void)configureScatterPlot
{
    [self addSubview:self.scatterPlotView];
    self.scatterPlotView.hostedGraph = self.scatterGraph;
     
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) self.scatterGraph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0.0f]
                                                    length:[NSNumber numberWithFloat:_maxAxisX]];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0.0f]
                                                    length:[NSNumber numberWithFloat:_maxAxisY]];
    
    [self.scatterGraph addPlot:self.scatterPlot toPlotSpace:plotSpace];

    [self configureAxisForGraph:self.scatterGraph];
}

- (void)configureAxisForGraph:(CPTGraph *)graph
{
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) graph.axisSet;
    
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
	axisTitleStyle.color = [CPTColor blackColor];
	axisTitleStyle.fontName = @"Helvetica";
	axisTitleStyle.fontSize = 12.0f;
	CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
	axisLineStyle.lineWidth = 2.0f;
	axisLineStyle.lineColor = [CPTColor blackColor];
	CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
	axisTextStyle.color = [CPTColor blackColor];
	axisTextStyle.fontName = @"Helvetica";
	axisTextStyle.fontSize = 11.0f;
	CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
	tickLineStyle.lineColor = [CPTColor blackColor];
	tickLineStyle.lineWidth = 2.0f;
    
    CPTAxis *x = axisSet.xAxis;
	x.axisLineStyle = axisLineStyle;
	x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.labelTextStyle = axisTextStyle;
	x.labelOffset = 20.0f;
	x.majorTickLineStyle = axisLineStyle;
    x.minorTickLineStyle = axisLineStyle;
	x.majorTickLength = 4.0f;
	x.minorTickLength = 2.0f;
	x.tickDirection = CPTSignPositive;
	NSInteger majorIncrementX = 4;
	NSInteger minorIncrementX = 1;
	CGFloat xMax = 20.0f;
	NSMutableSet *xLabels = [NSMutableSet set];
	NSMutableSet *xMajorLocations = [NSMutableSet set];
	NSMutableSet *xMinorLocations = [NSMutableSet set];
	for (NSInteger j = 0; j <= xMax; j += minorIncrementX)
    {
		NSInteger mod = j % majorIncrementX;
		if (mod == 0)
        {
			CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%li", (long)j/4] textStyle:x.labelTextStyle];
            label.alignment = CPTAlignmentCenter;
            NSNumber *location = [NSNumber numberWithInteger:j];
			label.tickLocation = location;
			label.offset = -x.majorTickLength - x.labelOffset;
			if (label)
            {
				[xLabels addObject:label];
			}
            
			[xMajorLocations addObject:[location copy]];
		}
        else
        {
			[xMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
		}
	}
	x.axisLabels = xLabels;
	x.majorTickLocations = xMajorLocations;
	x.minorTickLocations = xMinorLocations;
    
    
    
	    
    CPTAxis *y = axisSet.yAxis;
	y.axisLineStyle = axisLineStyle;
	y.labelingPolicy = CPTAxisLabelingPolicyNone;
	y.labelTextStyle = axisTextStyle;
	y.labelOffset = 20.0f;
	y.majorTickLineStyle = axisLineStyle;
    y.minorTickLineStyle = axisLineStyle;
	y.majorTickLength = 4.0f;
	y.minorTickLength = 2.0f;
	y.tickDirection = CPTSignPositive;
	NSInteger majorIncrement = 10.0f;
	NSInteger minorIncrement = 5.0f;
	CGFloat yMax = 200.0f; 
	NSMutableSet *yLabels = [NSMutableSet set];
	NSMutableSet *yMajorLocations = [NSMutableSet set];
	NSMutableSet *yMinorLocations = [NSMutableSet set];
	for (NSInteger j = minorIncrement; j <= yMax; j += minorIncrement)
    {
		NSUInteger mod = j % majorIncrement;
		if (mod == 0)
        {
			CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%li", (long)j] textStyle:y.labelTextStyle];
            label.alignment = CPTAlignmentCenter;
            NSNumber *location = [NSNumber numberWithInteger:j];
			label.tickLocation = location;
			label.offset = -y.majorTickLength - y.labelOffset;
			if (label)
            {
				[yLabels addObject:label];
			}
            
			[yMajorLocations addObject:[location copy]];
		}
        else
        {
			[yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
		}
	}
	y.axisLabels = yLabels;
	y.majorTickLocations = yMajorLocations;
	y.minorTickLocations = yMinorLocations;
    
}

- (void)configureBarPlot
{
    [self addSubview:self.barPlotView];
    self.barPlotView.hostedGraph = self.barGraph;
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.barGraph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0.0f]
                                                    length:[NSNumber numberWithFloat:40]];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0.0f]
                                                    length:[NSNumber numberWithFloat:50]];
    
    [self.barGraph addPlot:self.barPlot toPlotSpace:plotSpace];
    [self configureAxisForGraph:self.barGraph];
}

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords
{
    if ([plotnumberOfRecords.identifier isEqual:@"Volume Plot"])
    {
        return 40;
    }
    else
    {
        return [_yAxisPoints count];
    }
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    if ([plot.identifier isEqual:@"Volume Plot"])
    {
        if (fieldEnum == CPTScatterPlotFieldX)
        {
            return [NSNumber numberWithFloat:index + 0.3];
        }
        else
        {
            NSInteger randomNumber = arc4random() % 40;
            return [NSNumber numberWithInteger:randomNumber];
        }
    }
    else
    {
        if (fieldEnum == CPTScatterPlotFieldX)
        {
            return [NSNumber numberWithInteger:index];
        }
        else
        {
            NSInteger number = [_yAxisPoints[index] integerValue];
            return [NSNumber numberWithInteger:number];
        }
    }
}

- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
    return (id)[NSNull null];
}

#pragma mark -
#pragma mark Properties getters

- (void)setMaxX:(CGFloat)maxX
{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) self.scatterGraph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0.0f]
                                                    length:[NSNumber numberWithFloat:maxX]];

    [self.scatterGraph reloadData];
}

- (void)setMaxY:(CGFloat)maxY
{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) self.scatterGraph.defaultPlotSpace;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0.0f]
                                                    length:[NSNumber numberWithFloat:maxY + 2]];
    [self.scatterGraph reloadData];
}

- (CPTGraphHostingView *)scatterPlotView
{
    if (_scatterPlotView == nil)
    {
        _scatterPlotView = [CPTGraphHostingView new];
        _scatterPlotView.allowPinchScaling = NO;
    }
    
    return _scatterPlotView;
}

- (CPTGraph *)scatterGraph
{
    if (_scatterGraph == nil)
    {
        _scatterGraph = [CPTXYGraph new];
        _scatterGraph.plotAreaFrame.masksToBorder = NO;
        
        
        CPTTheme *theme = [CPTTheme themeNamed:kCPTStocksTheme];
        [_scatterGraph applyTheme:theme];
   
        _scatterGraph.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
        _scatterGraph.plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
        
        _scatterGraph.paddingRight = 0.0f;
        _scatterGraph.paddingLeft = 30.0f;
        _scatterGraph.paddingBottom = 0.0f;
        _scatterGraph.paddingTop = 0.0f;
    
        _scatterGraph.plotAreaFrame.cornerRadius  = 0.0f;
        CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
        borderLineStyle.lineColor = [CPTColor blackColor];
        borderLineStyle.lineWidth = 1.0f;
        _scatterGraph.plotAreaFrame.borderLineStyle = borderLineStyle;
    }
    
    return _scatterGraph;
}

- (CPTScatterPlot *)scatterPlot
{
    if (_scatterPlot == nil)
    {
        _scatterPlot = [CPTScatterPlot new];
        _scatterPlot.identifier = @"Data Source Plot";
        _scatterPlot.dataLineStyle = nil;
        _scatterPlot.dataSource = self;
        _scatterPlot.cachePrecision = CPTPlotCachePrecisionDouble;
        
        CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
        lineStyle.lineWidth = 1.0f;
        lineStyle.lineColor = [CPTColor blackColor];
        _scatterPlot.dataLineStyle = lineStyle;
        
        CPTColor *areaColor = [CPTColor colorWithComponentRed:25.0/255.0 green:32.0/255.0 blue:52.0/255.0 alpha:1.0];
        CPTColor *endColor = [CPTColor colorWithComponentRed:85.0/255.0 green:91.0/255.0 blue:107.0/255.0 alpha:1.0];
        CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:endColor];
        areaGradient.angle = 90.0f;
        _scatterPlot.areaBaseValue = [NSNumber numberWithDouble:0.0];
    }
    
    return _scatterPlot;
}

- (CPTGraphHostingView *)barPlotView
{
    if (_barPlotView == nil)
    {
        _barPlotView = [CPTGraphHostingView new];
        _barPlotView.allowPinchScaling = NO;
    }
    
    return _barPlotView;
}

- (CPTGraph *)barGraph
{
    if (_barGraph == nil)
    {
        _barGraph = [CPTXYGraph new];
        _barGraph.plotAreaFrame.masksToBorder = YES;
        CPTTheme *theme = [CPTTheme themeNamed:kCPTStocksTheme];
        [_barGraph applyTheme:theme];
        
        _barGraph.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
        _barGraph.plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
        
        _barGraph.paddingRight = 0.0f;
        _barGraph.paddingLeft = 30.0f;
        _barGraph.paddingBottom = 0.0f;
        _barGraph.paddingTop = 0.0f;

        _barGraph.plotAreaFrame.cornerRadius  = 0.0f;
        CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
        borderLineStyle.lineColor = [CPTColor blackColor];
        borderLineStyle.lineWidth = 1.0f;
        _barGraph.plotAreaFrame.borderLineStyle = borderLineStyle;
    }
    
    return _barGraph;
}

- (CPTBarPlot *)barPlot
{
    if (_barPlot == nil)
    {
        _barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blackColor] horizontalBars:NO];
        _barPlot.dataSource = self;
        _barPlot.fill = [CPTFill fillWithColor:[CPTColor blackColor]];
        _barPlot.barWidth = [NSNumber numberWithFloat:0.2];
        _barPlot.identifier = @"Volume Plot";
        _barPlot.cachePrecision = CPTPlotCachePrecisionDouble;
    }
    
    return _barPlot;
}

@end
