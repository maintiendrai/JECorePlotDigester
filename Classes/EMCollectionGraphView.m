//
//  EMCollectionGraphView.m
//  EMTemperature
//
//  Created by Thinking on 14-3-1.
//  Copyright (c) 2014年 Hu Dennis. All rights reserved.
//

#import "EMCollectionGraphView.h"
#import "JEGraphTheme.h"
#import "CPTGradient+Extends.h"
@interface EMCollectionGraphView()
{
    NSMutableArray *mar_identifiers;
    CPTXYAxis                   *y;
    CPTXYAxis                   *x;
    CPTXYPlotSpace              *plotSpace;
    CPTXYGraph                  *graph;             //画板
    CPTTimeFormatter            *timeFormatter;
    NSTimer                     *timer1;            //定时器
    int                         j;
    int                         r;
    float                       temperatuer;
}

@end


@implementation EMCollectionGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        mar_identifiers     = [[NSMutableArray alloc] init];
        _mar_dataForPlot    = [[NSMutableArray alloc] init];
        _mdic_dataFprPlot   = [[NSMutableDictionary alloc] init];
        //[self drawGraph];
    }
    return self;
}

-(void)start
{
    timer1 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dataOpt) userInfo:nil repeats:YES];
}

-(void)refreshGraphView
{
    //刷新画板
    [graph reloadData];
}

-(void)setAxis
{
    return;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(_minCount) length:CPTDecimalFromFloat(_maxCount + 0.5)];
    NSString *yLength = [NSString stringWithFormat:@"%f", (_maxCount - _minCount) / 2];
    // 大刻度线间距： 50 单位
    y. majorIntervalLength = CPTDecimalFromString ( yLength );
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM.dd"];
    timeFormatter.referenceDate = _firstTime;
}

- (void)drawGraph
{
    j = 0;
    
    graph = [[CPTXYGraph alloc] initWithFrame:self.bounds];
    
    //给画板添加一个主题
    CPTTheme *theme=[[JEGraphTheme alloc] init ];
    [graph applyTheme:theme];
    
    //创建主画板视图添加画板
    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:self.bounds];
    hostingView.hostedGraph = graph;
	[self addSubview:hostingView];
    
    //设置留白
    graph.paddingLeft = 0;
	graph.paddingTop = 0;
	graph.paddingRight = 0;
	graph.paddingBottom = 0;
    
    graph.plotAreaFrame.paddingLeft = 35;
    graph.plotAreaFrame.paddingTop = 10;
    graph.plotAreaFrame.paddingRight = 15;
    graph.plotAreaFrame.paddingBottom = 30;
    
    //设置坐标范围
    plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = NO;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(6*24*60*60+ 60*60*12)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(_minCount) length:CPTDecimalFromFloat(_maxCount + 0.5)];
    
    
    // Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.75;
    majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:CPTFloat(0.2)] colorWithAlphaComponent:CPTFloat(0.75)];
//    majorGridLineStyle.lineGradient = [CPTGradient gradientWithBeginningColor:[CPTColor redColor] endingColor:[CPTColor blueColor]];
//    lineFill整个frame从左往右渐变
    majorGridLineStyle.lineFill = [CPTFill fillWithGradient:[CPTGradient fadeinfadeoutGradient]];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:CPTFloat(0.1)];
//    minorGridLineStyle.lineFill = [CPTFill fillWithGradient:[CPTGradient fadeinfadeoutGradient]];
    
    CPTMutableLineStyle *lineStyle_no = [[CPTMutableLineStyle alloc] init];
    lineStyle_no.lineColor = [CPTColor clearColor];
    lineStyle_no.lineWidth = 0.0f;
    
    //坐标轴的样式
    CPTMutableLineStyle *lineStyle_x = [[CPTMutableLineStyle alloc] init];
    lineStyle_x.lineGradient = CPTGradient.hydrogenSpectrumGradient;
    lineStyle_x.lineWidth = 0.f;
    lineStyle_x.miterLimit = 1.0f;
    lineStyle_x.lineColor = [CPTColor clearColor];

//    lineStyle_x.lineColor = [CPTColor colorWithComponentRed:23/255.0 green:129/255.0 blue:135/255.0 alpha:1];
//    lineStyle_x.lineGradient = [CPTGradient gradientWithBeginningColor:[CPTColor redColor] endingColor:[CPTColor blueColor]];
    
    
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor lightGrayColor];
    //    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 10.0f;
    
    
    //设置坐标刻度大小
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) graph.axisSet ;

    x = axisSet.xAxis;
    x.majorGridLineStyle = majorGridLineStyle;
    x.minorGridLineStyle = minorGridLineStyle;

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM.dd"];
    timeFormatter = [[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter];
    timeFormatter.referenceDate = _firstTime;
    x.labelFormatter = timeFormatter;
    x.majorIntervalLength = CPTDecimalFromFloat(24*60*60*2);//设置坐标轴的单位长度必须在x.labelTextStyle = titleStyle;（标注坐标点）这个之前否则坐标多会卡死
    x.majorTickLineStyle = lineStyle_x;
    x.axisLineStyle = lineStyle_x;
    x.labelTextStyle = titleStyle;
    // 大刻度线间距： 50 单位
//    x. majorIntervalLength = CPTDecimalFromString (@"50");
    // 坐标原点： 0
    x. orthogonalCoordinateDecimal = CPTDecimalFromString (@"0" );
    x.minorTicksPerInterval = 0;//主刻度中显示的细分刻度的数目
    
    
   // x.majorGridLineStyle = lineStyle_x;
    // x.labelingPolicy = CPTAxisLabelingPolicyAutomatic;//计算拖动后的刻度
    
    y = axisSet.yAxis ;
    
    y.majorGridLineStyle = majorGridLineStyle;
    y.minorGridLineStyle = minorGridLineStyle;
    
    y.minorTicksPerInterval = 0;
    y.axisLineStyle = lineStyle_x;  //坐标轴样式设置
    //设置y轴小数点位数
    NSNumberFormatter *labelFormatter = [[NSNumberFormatter alloc] init];
    [labelFormatter setMaximumFractionDigits:1];
    [labelFormatter setMinimumIntegerDigits:1];
    // x.labelFormatter = labelFormatter;
    y.labelFormatter = labelFormatter;
    
    NSString *yLength = [NSString stringWithFormat:@"%f", (_maxCount - _minCount) / 2];
    // 大刻度线间距： 50 单位
    y. majorIntervalLength = CPTDecimalFromString ( yLength );
    y. majorTickLineStyle = lineStyle_x;   //其它Y分线段
//    y.majorGridLineStyle = lineStyle_no;
    // 坐标原点： 0
    y.orthogonalCoordinateDecimal = CPTDecimalFromCGFloat(0);//CPTDecimalFromString (@"-100");
    
    y.labelTextStyle = titleStyle;
    
    
    //    //添加触摸功能
    //    [self addTouchPlot:self.view];

//    y.axisConstraints = [CPTConstraints constraintWithRelativeOffset:-0.1];

    j = 0;
    r = 0;
    
//    [timer1 fire];
}

- (void) dataOpt
{
    return;
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:_firstTime];
    NSLog(@"====%d", (int)interval);
    
    for (int i = 0; i < mar_identifiers.count; i++) {
        NSString *identifier = [mar_identifiers objectAtIndex:i];
        NSString *xp = [NSString stringWithFormat:@"%d",(int)interval];
        int iy = (rand()%(25-8*i));
        NSString *yp = [NSString stringWithFormat:@"%d",iy];
        NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
        [[_mdic_dataFprPlot valueForKey:identifier] addObject:point1];
    }
    
//    NSString *xp = [NSString stringWithFormat:@"%d",(int)interval];
//    int iy = (rand()%25);
//    NSString *yp = [NSString stringWithFormat:@"%d",iy];
//    NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
//    [_mar_dataForPlot addObject:point1];
//    
//    int iy2 = (rand()%10);
//    NSString *yp2 = [NSString stringWithFormat:@"%d",iy2];
//    NSMutableDictionary *point2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp2, @"y", nil];
//    [mar_data2 addObject:point2];
    
    
    //刷新画板
    [graph reloadData];
    // j = j + 1;
    
}

#pragma mark -  button action
-(void)bgButtonAction:(id)sender{
    
//    graphViewCtr *graphVC = [[graphViewCtr alloc] initWithPlotData:self.array_dataForPlot];
//    [self presentModalViewController:graphVC animated:YES];
    //[self.navigationController pushViewController:graphVC animated:YES];
    [_delegate backgroundButtonAction:sender];
}

-(void)infoButtonAction:(id)sender{
    
    [_delegate gotoInfoButtonAction:sender];
}

#pragma mark - dataSourceOpt

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
//    if ([plot.identifier isEqual:@"Green Plot"]) {
//        return [_mar_dataForPlot count];
//    }else{
//        return [mar_data2 count];
//    }
//    
    for (int i = 0; i < mar_identifiers.count; i++) {
        NSString *identifier = [mar_identifiers objectAtIndex:i];
        if ([plot.identifier isEqual:identifier]) {
            NSArray *ar_plot = [_mdic_dataFprPlot valueForKey:identifier];
            return [ar_plot count];
            break;
        }
    }
    
    return 0;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSString *key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
    NSNumber *num = nil;
    //让视图偏移
//	if ( [(NSString *)plot.identifier isEqualToString:@"Green Plot"]) {
//        num = [[_mar_dataForPlot objectAtIndex:index] valueForKey:key];
//        if ( fieldEnum == CPTScatterPlotFieldX ) {
//			num = [NSNumber numberWithDouble:[num doubleValue]];
//            
//		}
//        
//    }else{
//        num = [[mar_data2 objectAtIndex:index] valueForKey:key];
//        if ( fieldEnum == CPTScatterPlotFieldX ) {
//            num = [NSNumber numberWithDouble:[num doubleValue]];
//            
//        }
//    }
    
    for (int i = 0; i < mar_identifiers.count; i++) {
        NSString *identifier = [mar_identifiers objectAtIndex:i];
        if ([plot.identifier isEqual:identifier]) {
            num = [[[_mdic_dataFprPlot valueForKey:identifier] objectAtIndex:index] valueForKey:key];
            if ( fieldEnum == CPTScatterPlotFieldX ) {
                num = [NSNumber numberWithDouble:[num doubleValue]];
                
            }
            if ([key isEqualToString:@"y"]) {
//                Dlog(@"=yyyy===%@", num);
            }
            break;
        }
    }
    
    //添加动画效果
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.duration = 0.5f;
    fadeInAnimation.removedOnCompletion = NO;
    fadeInAnimation.fillMode = kCAFillModeForwards;
    fadeInAnimation.toValue = [NSNumber numberWithFloat:2.0];
    [plot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
    
    return num;
}

#pragma  mark 添加折线图
- (void)addLineWithIdentifier:(NSString *)identifier color:(CPTColor *)lineColor
{
    
    [mar_identifiers addObject:identifier];
    NSMutableArray *ar_t = [[NSMutableArray alloc] init];
    [_mdic_dataFprPlot setObject:ar_t forKey:identifier];
    
    //创建绿色区域  (线)
    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
    dataSourceLinePlot.identifier = identifier;
    
    //支持点击节点显示数据
    CPTPlotSymbol *cptPlotSymbol    = [CPTPlotSymbol plotSymbol];
    //cptPlotSymbol.fill              = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:63/255.0 green:180/255.0 blue:200/255.0 alpha:1]];
    cptPlotSymbol.fill              = [CPTFill fillWithColor:lineColor];
    cptPlotSymbol.size              = CGSizeMake(10.0, 10.0);
    dataSourceLinePlot.plotSymbol   = cptPlotSymbol;
    // Set plot delegate, to know when symbols have been touched
    dataSourceLinePlot.delegate                        = self;
    dataSourceLinePlot.plotSymbolMarginForHitDetection = 5.0f;
    
    // Make the data source line use curved interpolation
    dataSourceLinePlot.interpolation = CPTScatterPlotInterpolationCurved;

    
    //设置绿色区域边框的样式
    CPTMutableLineStyle *lineStyle = [dataSourceLinePlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth = 2.f;
   // lineStyle.lineColor = [CPTColor colorWithComponentRed:63/255.0 green:180/255.0 blue:200/255.0 alpha:1];
    lineStyle.lineColor = lineColor;
    dataSourceLinePlot.dataLineStyle = lineStyle;
    //设置透明实现添加动画
    dataSourceLinePlot.opacity = 0.0f;
    
    //设置数据元代理
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    
    // 在图形上添加一些小圆点符号（节点）
    CPTMutableLineStyle *symbolLineStylePoint = [[ CPTMutableLineStyle alloc] init];
    symbolLineStylePoint.lineColor = lineColor;// 描边
    symbolLineStylePoint.lineWidth = 2.f;
    
    CPTPlotSymbol *plotSymbol = [ CPTPlotSymbol ellipsePlotSymbol];// 符号类型：椭圆
    plotSymbol.fill = [ CPTFill fillWithColor:[CPTColor whiteColor]];// 填充色：蓝色
    plotSymbol.lineStyle = symbolLineStylePoint;// 描边
    plotSymbol.size = CGSizeMake ( 6.0 , 6.0 );// 符号大小： 10*10
    dataSourceLinePlot.plotSymbol = plotSymbol;
}

@end
