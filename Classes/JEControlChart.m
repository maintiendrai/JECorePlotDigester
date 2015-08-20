#import "JEControlChart.h"
#import "CPTGradient+Extends.h"
#import "JEGraphTheme.h"

static NSString *const kDataLine    = @"Data Line";

static NSString *const kDataLine1    = @"Data Line1";



@interface JEControlChart()


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
    if ( (self = [super init]) ) {
        //        self.title   = @"Control Chart";
        //        self.section = kLinePlots;
    }
    
    return self;
}

- (void)reloadData
{
    [self renderInView:self.hostView withTheme:nil animated:YES];
}

-(void)generateData
{
    if ( self.plotData == nil ) {
        _numberOfPoints = 30;
        NSMutableArray *contentArray = [NSMutableArray array];
        NSMutableArray *contentArray1 = [NSMutableArray array];
        
        double sum = 0.0;
        
        double args[30] = { 9, 10, 25, 10, 19, 0, 26, 25, 22, 18, 13, 10 ,15, 25, 16, 0, 2, 19, 15, 20, 21, 8, 4, 15, 24, 13, 10, 9, 12, 20};
        
        
        for ( NSUInteger i = 0; i < _numberOfPoints; i++ ) {
            double y = args[i];
            sum += y;
            [contentArray addObject:@(y)];
        }
        
        for ( NSUInteger i = 0; i < _numberOfPoints; i++ ) {
            double y = args[_numberOfPoints-1-i];
            sum += y;
            [contentArray1 addObject:@(y)];
        }
        
        
        self.plotData = contentArray;
//        self.plotData1 = contentArray1;
//
//        self.meanValue = sum / numberOfPoints;
//
//        sum = 0.0;
//        for ( NSNumber *value in contentArray ) {
//            double error = [value doubleValue] - self.meanValue;
//            sum += error * error;
//        }
//        double stdDev = sqrt( ( 1.0 / (numberOfPoints - 1) ) * sum );
//        self.standardError = stdDev / sqrt(numberOfPoints);
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
    
    [graph applyTheme:[[JEGraphTheme alloc] init]];
    
    
    graph.plotAreaFrame.masksToBorder = NO;
    
    // Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.75;
    majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:CPTFloat(0.2)] colorWithAlphaComponent:CPTFloat(0.75)];
    majorGridLineStyle.lineFill = [CPTFill fillWithGradient:[CPTGradient fadeinfadeoutGradient]];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:CPTFloat(0.1)];
    
    
    NSNumberFormatter *labelFormatter = [[NSNumberFormatter alloc] init];
    labelFormatter.maximumFractionDigits = 0;
    
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor lightGrayColor];
    //    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 10.0f;
    
    // Axes
    // X axis
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.labelingPolicy     = CPTAxisLabelingPolicyAutomatic;
    x.majorGridLineStyle = majorGridLineStyle;
    x.minorGridLineStyle = minorGridLineStyle;
    x.labelFormatter     = labelFormatter;
    x.labelTextStyle     = titleStyle;
    x.orthogonalCoordinateDecimal = CPTDecimalFromString (@"0" );
    x.minorTicksPerInterval = 0;//主刻度中显示的细分刻度的数目
    x.preferredNumberOfMajorTicks = 6;
    x.axisLineStyle               = nil;
    x.majorTickLineStyle          = nil;
    x.minorTickLineStyle          = nil;
    
    
    // Y axis
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy     = CPTAxisLabelingPolicyAutomatic;
    y.majorGridLineStyle = majorGridLineStyle;
    y.minorGridLineStyle = minorGridLineStyle;
    y.labelFormatter     = labelFormatter;
    y.labelTextStyle     = titleStyle;
    y.minorTicksPerInterval = 0;//主刻度中显示的细分刻度的数目
    y.majorTickLength = 15;
    //    y.preferredNumberOfMajorTicks = 3;
    //    y.minorTicksPerInterval = 20;
    y.axisLineStyle               = nil;
    y.majorTickLineStyle          = nil;
    y.minorTickLineStyle          = nil;
    
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth          = 2.0;
    lineStyle.lineColor          = [CPTColor colorWithComponentRed:0/255 green:185/255.0 blue:163/255.0 alpha:1];
    //    lineStyle.lineGradient       = [CPTGradient fadeinfadeoutGradient];
    
    
    CPTMutableLineStyle *lineStyle1 = [CPTMutableLineStyle lineStyle];
    lineStyle1.lineWidth          = 2.0;
    lineStyle1.lineColor          = [CPTColor redColor];
    lineStyle1.lineGradient       = [CPTGradient fadeinfadeoutGradient];
    
    
    // Data line 画线
    CPTScatterPlot *linePlot = [[CPTScatterPlot alloc] init];
    linePlot.identifier = kDataLine;
    
    linePlot.dataLineStyle = lineStyle;
    linePlot.interpolation = CPTScatterPlotInterpolationCurved; //曲线
    
    
    linePlot.dataSource = self;
    [graph addPlot:linePlot];
    
    
    // Data line 画线
    CPTScatterPlot *linePlot1 = [[CPTScatterPlot alloc] init];
    linePlot1.identifier = kDataLine1;
    linePlot1.dataLineStyle = lineStyle1;
    linePlot1.interpolation = CPTScatterPlotInterpolationCurved; //曲线
    
    
    linePlot1.dataSource = self;
    //    [graph addPlot:linePlot1];
    
    
    // Add plot symbols
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor colorWithComponentRed:0/255 green:185/255.0 blue:163/255.0 alpha:1];
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill      = [CPTFill fillWithColor:[CPTColor whiteColor]];
    plotSymbol.lineStyle = symbolLineStyle;
    plotSymbol.size      = CGSizeMake(6.0, 6.0);
    linePlot.plotSymbol  = plotSymbol;
    
    linePlot1.plotSymbol = plotSymbol;
    
    
    // Auto scale the plot space to fit the plot data
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    [plotSpace scaleToFitPlots:@[linePlot]];
    
    // Adjust visible ranges so plot symbols along the edges are not clipped
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1) length:CPTDecimalFromFloat(31)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-3) length:CPTDecimalFromFloat(35)];
    
    x.orthogonalCoordinateDecimal = yRange.location;
    y.orthogonalCoordinateDecimal = xRange.location;
    
    
    
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

@end
