//
//  JEBarChart.m
//  JECorePlotDigester
//
//  Created by Diana on 8/6/15.
//  Copyright (c) 2015 evideo. All rights reserved.
//

#import "JEBarChart.h"
#import "JEGraphTheme.h"

@interface JEBarChart()

@end

@implementation JEBarChart

@synthesize plotData;

+(void)load
{
    [super registerPlotItem:self];
}

-(instancetype)init
{
    if ( (self = [super init]) ) {
        self.title   = @"JE Bar Chart";
        self.section = kBarPlots;
    }

    return self;
}

-(void)generateData
{
    self.plotCount = 2;
    if ( self.plotData == nil ) {
        NSMutableArray *contentArray = [NSMutableArray array];
        for ( NSUInteger i = 0; i < 8; i++ ) {
            [contentArray addObject:@(5.0 * arc4random() / (double)UINT32_MAX + 5.0)];
        }
        self.plotData = contentArray;
    }
    if ( self.plotData1 == nil ) {
        NSMutableArray *contentArray = [NSMutableArray array];
        for ( NSUInteger i = 0; i < 8; i++ ) {
            [contentArray addObject:@(5.0 * arc4random() / (double)UINT32_MAX + 5.0)];
        }
        self.plotData1 = contentArray;
    }
}

-(void)renderInGraphHostingView:(CPTGraphHostingView *)hostingView withTheme:(CPTTheme *)theme animated:(BOOL)animated
{
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    CGRect bounds = hostingView.bounds;
#else
    CGRect bounds = NSRectToCGRect(hostingView.bounds);
#endif

    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:bounds];
    [self addGraph:graph toHostingView:hostingView];
    
    //给画板添加一个主题
    [graph applyTheme:[[JEGraphTheme alloc] init]];

    graph.plotAreaFrame.paddingLeft   += self.titleSize * CPTFloat(2.5);
    graph.plotAreaFrame.paddingTop    += self.titleSize * CPTFloat(1.25);
    graph.plotAreaFrame.paddingRight  += self.titleSize;
    graph.plotAreaFrame.paddingBottom += self.titleSize;
    graph.plotAreaFrame.masksToBorder  = NO;

    // Create grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 1.0;
    majorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.75];

    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 1.0;
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.25];
    
    majorGridLineStyle.lineFill = [CPTFill fillWithGradient:[CPTGradient fadeinfadeoutGradient]];

    // Create axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    {
        x.majorIntervalLength         = CPTDecimalFromInteger(1);
        x.minorTicksPerInterval       = 0;
        x.orthogonalCoordinateDecimal = CPTDecimalFromInteger(0);
        x.majorGridLineStyle          = nil;       //x轴不划线
        x.minorGridLineStyle          = nil;       //x轴不划线
        x.axisLineStyle               = nil;
        x.majorTickLineStyle          = nil;
        x.minorTickLineStyle          = nil;
        x.labelFormatter              = nil;
    }

    CPTXYAxis *y = axisSet.yAxis;
    {
        y.majorIntervalLength         = CPTDecimalFromInteger(10);
        y.minorTicksPerInterval       = 9;
        y.axisConstraints             = [CPTConstraints constraintWithLowerOffset:0.0];
        y.preferredNumberOfMajorTicks = 3;   //y轴比对线的条数
        y.majorGridLineStyle          = majorGridLineStyle;
        y.minorGridLineStyle          = minorGridLineStyle;
        y.axisLineStyle               = nil;
        y.majorTickLineStyle          = nil;
        y.minorTickLineStyle          = nil;
//        y.labelOffset                 = self.titleSize * CPTFloat(0.375);
        y.labelRotation               = CPTFloat(M_PI_2);
        y.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;

//        y.titleOffset = self.titleSize * CPTFloat(1.25);
    }

    [self generateBarPlots:graph];

}


- (void)generateBarPlots:(CPTGraph*)graph
{
    // Create a bar line style
    CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineWidth = 1.0;
    barLineStyle.lineColor = [CPTColor whiteColor];
    
    
    for (int i=0; i<2; i++) {
        // Create bar plot
        CPTBarPlot *barPlot = [[CPTBarPlot alloc] init];
        barPlot.lineStyle         = barLineStyle;
        barPlot.barWidth          = CPTDecimalFromFloat(_plotCount ==2 ? 0.35f : 0.5f); // bar is 75% of the available space
        barPlot.barsAreHorizontal = NO;
        barPlot.dataSource        = self;
        barPlot.identifier        = [NSString stringWithFormat:@"%d", i];
        barPlot.barOffset         = CPTDecimalFromFloat(-0.25f+i*0.5);
        
        [graph addPlot:barPlot];
        if (i==0) {
            // Plot space
            CPTMutablePlotRange *barRange = [[barPlot plotRangeEnclosingBars] mutableCopy];
            [barRange expandRangeByFactor:CPTDecimalFromDouble(1.15)];
            
            CPTXYPlotSpace *barPlotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
            barPlotSpace.xRange = barRange;
            barPlotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(19.0f)];
        }
    }
    
}


#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return self.plotData.count;
}


-(NSArray *)numbersForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndexRange:(NSRange)indexRange
{
    NSArray *nums = nil;

    switch ( fieldEnum ) {
        case CPTBarPlotFieldBarLocation:
            nums = [NSMutableArray arrayWithCapacity:indexRange.length];
            for ( NSUInteger i = indexRange.location; i < NSMaxRange(indexRange); i++ ) {
                [(NSMutableArray *)nums addObject : @(i)];
            }
            break;

        case CPTBarPlotFieldBarTip:
            nums = [self.plotData objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:indexRange]];
            if ([plot.identifier isEqual:@"1"]) {
                nums = [self.plotData1 objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:indexRange]];
            }
            break;

        default:
            break;
    }

    return nums;
}

-(CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)index
{
    CPTColor *color = [CPTColor colorWithComponentRed:0/255.0 green:197/255.0 blue:173/255.0 alpha:1];
    if ([barPlot.identifier isEqual: @"1"]) {
        return [CPTFill fillWithColor:[CPTColor blackColor]];
    }
 
    return [CPTFill fillWithColor:color];
}


@end
