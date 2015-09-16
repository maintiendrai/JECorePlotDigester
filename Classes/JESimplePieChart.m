//
//  JESimplePieChart.m
//  JECorePlotDigester
//
//  Created by Diana on 8/6/15.
//  Copyright (c) 2015 evideo. All rights reserved.
//

#import "JESimplePieChart.h"
#import "JEGraphTheme.h"

@interface JESimplePieChart()


@property (nonatomic, readwrite) NSUInteger offsetIndex;
@property (nonatomic, readwrite) CGFloat sliceOffset;

@end

@implementation JESimplePieChart

@synthesize plotData;
@synthesize offsetIndex;
@synthesize sliceOffset;

+(void)load
{
    [super registerPlotItem:self];
    
}

-(instancetype)init
{
    if ( (self = [super init]) ) {
        [self digesterColor];
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
        self.plotData = @[@20.0];
        self.plotColor = [NSMutableArray arrayWithArray: @[[CPTColor colorWithComponentRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1]]];
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
    graph.axisSet                     = nil;
    
    
    // Add pie chart
    CPTPieChart *piePlot = [[CPTPieChart alloc] init];
    piePlot.dataSource = self;
    piePlot.pieRadius  = MIN( CPTFloat(0.7) * (hostingView.frame.size.height - CPTFloat(2.0) * graph.paddingLeft) / CPTFloat(2.0),
                             CPTFloat(0.4) * (hostingView.frame.size.width - CPTFloat(2.0) * graph.paddingTop) / CPTFloat(2.0) );
    
    piePlot.overlayFill    = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1]];
    
    piePlot.identifier     = self.title;
    piePlot.startAngle     = CPTFloat(0);

    piePlot.sliceDirection = CPTPieDirectionCounterClockwise;
    piePlot.pieInnerRadius = self.pieInnerRadius ? self.pieInnerRadius : 70;
    
    
    piePlot.delegate = self;
    [graph addPlot:piePlot];
    
    if ( animated ) {
        [CPTAnimation animate:piePlot
                     property:@"startAngle"
                         from:CPTFloat(M_PI)
                           to:CPTFloat(M_PI)
                     duration:0
                    withDelay:0
               animationCurve:CPTAnimationCurveLinear
                     delegate:self];
    }
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
    return nil;
}

#pragma mark -
#pragma mark CPTPieChartDelegate Methods

-(void)plot:(CPTPlot *)plot dataLabelWasSelectedAtRecordIndex:(NSUInteger)index
{
    NSLog(@"Data label for '%@' was selected at index %d.", plot.identifier, (int)index);
}

-(void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)index
{
    NSLog(@"Slice was selected at index %d. Value = %f", (int)index, [self.plotData[index] floatValue]);
    
    self.offsetIndex = NSNotFound;
    
    NSMutableArray *newData = [[NSMutableArray alloc] init];
    NSUInteger dataCount    = (NSUInteger)lrint( ceil(10.0 * arc4random() / (double)UINT32_MAX) ) + 1;
    for ( NSUInteger i = 1; i < dataCount; i++ ) {
        [newData addObject:@(100.0 * arc4random() / (double)UINT32_MAX)];
    }
    NSLog(@"newData: %@", newData);
    
    self.plotData = newData;
    
    [plot reloadData];
}

#pragma mark -
#pragma mark CPTLegendDelegate Methods

-(void)legend:(CPTLegend *)legend legendEntryForPlot:(CPTPlot *)plot wasSelectedAtIndex:(NSUInteger)idx
{
    NSLog(@"Legend entry for '%@' was selected at index %lu.", plot.identifier, (unsigned long)idx);
    
    [CPTAnimation animate:self
                 property:@"sliceOffset"
                     from:(idx == self.offsetIndex ? NAN : 0.0)
                       to:(idx == self.offsetIndex ? 0.0 : 35.0)
                 duration:0.5
           animationCurve:CPTAnimationCurveCubicOut
                 delegate:nil];
    
    self.offsetIndex = idx;
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return self.plotData.count;
}

-(id)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSNumber *num;
    
    if ( fieldEnum == CPTPieChartFieldSliceWidth ) {
        num = self.plotData[index];
    }
    else {
        num = @(index);
    }
    
    return num;
}

-(NSAttributedString *)attributedLegendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
{
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    UIColor *sliceColor = [CPTPieChart defaultPieSliceColorForIndex:index].uiColor;
//    UIFont *labelFont   = [UIFont fontWithName:@"Helvetica" size:self.titleSize * CPTFloat(0.5)];
#else
    NSColor *sliceColor = [CPTPieChart defaultPieSliceColorForIndex:index].nsColor;
//    NSFont *labelFont   = [NSFont fontWithName:@"Helvetica" size:self.titleSize * CPTFloat(0.5)];
#endif
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Pie Slice %lu", (unsigned long)index]];
    [title addAttribute:NSForegroundColorAttributeName
                  value:sliceColor
                  range:NSMakeRange(4, 5)];
    
    return title;
}

- (void)digesterColor {
    self.plotColor = [NSMutableArray array];
    [self.plotColor addObject:[CPTColor colorWithComponentRed:254/255.0 green:211/255.0 blue:0/255.0 alpha:1]];
    [self.plotColor addObject:[CPTColor colorWithComponentRed:255/255.0 green:103/255.0 blue:82/255.0 alpha:1]];
    [self.plotColor addObject:[CPTColor colorWithComponentRed:0/255.0 green:192/255.0 blue:232/255.0 alpha:1]];
    [self.plotColor addObject:[CPTColor colorWithComponentRed:250/255.0 green:158/255.0 blue:0/255.0 alpha:1]];
    [self.plotColor addObject:[CPTColor colorWithComponentRed:148/255.0 green:246/255.0 blue:133/255.0 alpha:1]];
    [self.plotColor addObject:[CPTColor colorWithComponentRed:80/255.0 green:192/255.0 blue:232/255.0 alpha:1]];
    
//    [self.plotColor addObject:[CPTColor colorWithComponentRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1]];
}


-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx
{
    
    if (idx < self.plotColor.count) {
        return [[CPTFill alloc]initWithColor:(CPTColor*)self.plotColor[idx]];
    } else {
        return [[CPTFill alloc]initWithColor:[CPTColor colorWithComponentRed:100/255.0 green:192/255.0 blue:232/255.0 alpha:1]];
    }
    
}

#pragma mark -
#pragma mark Accessors

-(void)setSliceOffset:(CGFloat)newOffset
{
    if ( newOffset != sliceOffset ) {
        sliceOffset = newOffset;
        
        [self.graphs[0] reloadData];
        
        if ( newOffset == 0.0 ) {
            self.offsetIndex = NSNotFound;
        }
    }
}

#pragma mark -
#pragma mark Animation Delegate

-(void)animationDidStart:(id)operation
{
    ((CPTPieChart*)((CPTAnimationOperation*)operation).boundObject).overlayFill = nil;
}

-(void)animationDidFinish:(CPTAnimationOperation *)operation
{
}

-(void)animationCancelled:(CPTAnimationOperation *)operation
{
}

-(void)animationWillUpdate:(CPTAnimationOperation *)operation
{
}

-(void)animationDidUpdate:(CPTAnimationOperation *)operation
{
}


@end
