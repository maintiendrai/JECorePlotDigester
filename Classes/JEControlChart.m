//
//  JEControlChart.m
//  JECorePlotDigester
//
//  Created by Diana on 8/6/15.
//  Copyright (c) 2015 evideo. All rights reserved.
//


#import "JEControlChart.h"
#import "CPTGradient+Extends.h"
#import "JEGraphTheme.h"
#define N 5

static NSString *const kDataLine    = @"Data Line";
static NSString *const kDataLine1    = @"Data Line1";



@interface JEControlChart()

@property (nonatomic, readwrite, assign) double toplevel;
@property (nonatomic, readwrite, assign) double meanValue;
@property (nonatomic, readwrite, assign) double standardError;

@end

@implementation JEControlChart

@synthesize plotData;
@synthesize plotData1;
@synthesize meanValue;
@synthesize standardError;

+(void)load
{
    [super registerPlotItem:self];
}

-(instancetype)init
{
    if ((self = [super init])) {
    }
    return self;
}

- (void)reloadData
{
    [self renderInView:self.hostView withTheme:nil animated:YES];
}

-(void)generateData
{
    if (!_plotColor) {
        _plotColor = [CPTColor colorWithComponentRed:0/255 green:185/255.0 blue:163/255.0 alpha:1];
    }
    if (!_plotColor1) {
        _plotColor1 = [CPTColor colorWithComponentRed:255/255 green:25/255.0 blue:0/255.0 alpha:1];
    }
    
    
    if (self.plotData) {
        self.toplevel = [((NSNumber *)self.plotData[0]) intValue];
        for (NSInteger i=0; i<self.plotData.count; i++) {
            int tmp = [((NSNumber *)self.plotData[i]) intValue];
            self.toplevel = (self.toplevel < tmp) ? tmp : self.toplevel;
        }
        //    } else {
        //        [self dataTest];
    }
    
}


- (void)dataTest {
    
    if (self.plotData == nil ) {
        _numberOfPoints = 20;
        NSMutableArray *contentArray = [NSMutableArray array];
        NSMutableArray *contentArray1 = [NSMutableArray array];
        
        double sum = 0.0;
        
        double args[N] = { 9, 10, 25, 10, 19};
        
        self.toplevel = args[0];
        
        for (NSUInteger i=0; i<N; i++) {
            self.toplevel = self.toplevel<args[i] ? args[i] : self.toplevel;
            double y = args[i];
            sum += y;
            [contentArray addObject:@(y)];
        }
        
        for ( NSUInteger i=0; i<N; i++ ) {
            self.toplevel = self.toplevel<args[i] ? args[i] : self.toplevel;
            double y = args[sizeof(args)-1-i];
            sum += y;
            [contentArray1 addObject:@(y)];
        }
        
        
        self.plotData = contentArray;
        
        self.plotData1 = contentArray1;
        
        self.meanValue = sum / _numberOfPoints;
        
        
        
        sum = 0.0;
        for ( NSNumber *value in contentArray ) {
            double error = [value doubleValue] - self.meanValue;
            sum += error * error;
        }
        double stdDev = sqrt( ( 1.0 / (_numberOfPoints - 1) ) * sum );
        self.standardError = stdDev / sqrt(_numberOfPoints);
    }
}

- (void)renderInGraphHostingView:(CPTGraphHostingView *)hostingView withTheme:(CPTTheme *)theme animated:(BOOL)animated
{
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    CGRect bounds = hostingView.bounds;
#else
    CGRect bounds = NSRectToCGRect(hostingView.bounds);
#endif
    
    
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:bounds];
    [self addGraph:graph toHostingView:hostingView];
    
    [graph applyTheme:[[JEGraphTheme alloc] init]];
    
    
    graph.plotAreaFrame.masksToBorder = NO;
    
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth          = 2.0;
    lineStyle.lineColor          = _plotColor;
    
    
    //Data line
    CPTScatterPlot *linePlot = [[CPTScatterPlot alloc] init];
    linePlot.identifier = kDataLine;
    
    linePlot.dataLineStyle = lineStyle;
    linePlot.interpolation = CPTScatterPlotInterpolationCurved; //curve
    
    
    linePlot.dataSource = self;
    [graph addPlot:linePlot];
    
    
    //Auto scale the plot space to fit the plot data
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    [plotSpace scaleToFitPlots:@[linePlot]];
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.65) length:CPTDecimalFromFloat(self.numberOfPoints-0.5)];
    
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5) length:CPTDecimalFromFloat(self.toplevel+5)];
    
    // Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.75;
    majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:CPTFloat(0.2)] colorWithAlphaComponent:CPTFloat(0.75)];
    majorGridLineStyle.lineFill = [CPTFill fillWithGradient:[CPTGradient fadeinfadeoutGradient]];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:CPTFloat(0.1)];
    
    //coordinate label format
    NSNumberFormatter *labelFormatter = [[NSNumberFormatter alloc] init];
    labelFormatter.maximumFractionDigits = 0;
    
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor lightGrayColor];
    titleStyle.fontSize = 10.0f;
    
    // Axes
    // X axis
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.labelingPolicy     = CPTAxisLabelingPolicyEqualDivisions;
    x.majorGridLineStyle = majorGridLineStyle;
    x.minorGridLineStyle = minorGridLineStyle;
    x.labelFormatter     = labelFormatter;
    x.labelTextStyle     = titleStyle;
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"-0.1");
    x.minorTicksPerInterval = 0;//sub scale
    x.preferredNumberOfMajorTicks = 8;
    x.axisLineStyle               = nil;
    x.majorTickLineStyle          = nil;
    x.minorTickLineStyle          = nil;
    
    // Y axis
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy     = CPTAxisLabelingPolicyEqualDivisions;
    y.majorGridLineStyle = majorGridLineStyle;
    y.minorGridLineStyle = minorGridLineStyle;
    y.labelFormatter     = labelFormatter;
    y.labelTextStyle     = titleStyle;
    y.minorTicksPerInterval = 0;//sub scale
    y.preferredNumberOfMajorTicks = 3;
    y.majorTickLength = 15;
    y.axisLineStyle               = nil;
    y.majorTickLineStyle          = nil;
    y.minorTickLineStyle          = nil;
    y.orthogonalCoordinateDecimal = CPTDecimalFromDouble(2.0);
    
    
    // plotData 1 modify
    if (plotData1) {
        
        CPTMutableLineStyle *lineStyle1 = [CPTMutableLineStyle lineStyle];
        lineStyle1.lineWidth          = 2.0;
        lineStyle1.lineColor          = _plotColor1;
        
        CPTScatterPlot *linePlot1 = [[CPTScatterPlot alloc] init];
        linePlot1.identifier = kDataLine1;
        linePlot1.dataLineStyle = lineStyle1;
        linePlot1.interpolation = CPTScatterPlotInterpolationCurved; //曲线
        linePlot1.dataSource = self;
        [graph addPlot:linePlot1];
        
    }
    
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if ( plot.identifier == kDataLine ) {
        return self.plotData.count;
    }
    if (plot.identifier == kDataLine1) {
        return self.plotData1.count;
    }
    else {
        return 5;
    }
}

-(double)doubleForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    double number = NAN;
    
    switch ( fieldEnum ) {
        case CPTScatterPlotFieldX:
            if ( plot.identifier == kDataLine ) {
                number = (double)index;
            } else if (plot.identifier == kDataLine1) {
                number = (double)index;
            }
            break;
            
        case CPTScatterPlotFieldY:
            if ( plot.identifier == kDataLine ) {
                number = [self.plotData[index] doubleValue];
            } else if (plot.identifier == kDataLine1) {
                number = [self.plotData1[index] doubleValue];
            }
            break;
    }
    
    return number;
}

-(CPTPlotSymbol *)symbolForScatterPlot:(CPTScatterPlot *)plot recordIndex:(NSUInteger)idx
{
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = _plotColor;
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill      = [CPTFill fillWithColor:[CPTColor whiteColor]];
    plotSymbol.lineStyle = symbolLineStyle;
    plotSymbol.size      = CGSizeMake(6.0, 6.0);
    
    CPTMutableLineStyle *symbolLineStyle1 = [CPTMutableLineStyle lineStyle];
    symbolLineStyle1.lineColor = _plotColor1;
    CPTPlotSymbol *plotSymbol1 = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol1.fill      = [CPTFill fillWithColor:[CPTColor whiteColor]];
    plotSymbol1.lineStyle = symbolLineStyle1;
    plotSymbol1.size      = CGSizeMake(6.0, 6.0);
    
    
    if (plot.identifier == kDataLine) {
        if (idx == 1 || plotData.count == idx+1) {
            return plotSymbol;
        }
    }
    
    if (plot.identifier == kDataLine1) {
        if (idx == 1 || plotData1.count == idx+1) {
            return plotSymbol1;
        }
    }
    
    return nil;
}

@end
