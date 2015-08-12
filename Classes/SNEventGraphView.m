//
//  SNEvnetGraphView.m
//  SNVideo
//
//  Created by Thinking on 14-11-10.
//  Copyright (c) 2014年 StarNet智能家居研发部. All rights reserved.
//

#import "SNEventGraphView.h"
//#import "EMCollectionGraphView.h"
#import "JECurvedPlotView.h"
//#import "SNEventReport.h"


@interface SNEventReportInfo : NSObject

@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) NSDate* date;

@end

@implementation SNEventReportInfo


@end

@interface SNEventGraphView ()
{
    NSDictionary            *dic_data;
    JECurvedPlotView   *view_emGraph;
    SNEventType             e_type;
}

@end

@implementation SNEventGraphView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame data:(NSDictionary *)dic_t
{
    if (self == [super initWithFrame:frame]) {
        
        SNEventReportInfo* info1 = [[SNEventReportInfo alloc]init];
        info1.count = 1;
        info1.date = [NSDate dateWithTimeIntervalSinceNow:-24*60*60];
        SNEventReportInfo* info11 = [[SNEventReportInfo alloc]init];
        info11.count = 3;
        info11.date = [NSDate dateWithTimeIntervalSinceNow:-12*60*60];
        
        
        SNEventReportInfo* info2 = [[SNEventReportInfo alloc]init];
        info2.count = 2;
        info2.date = [NSDate dateWithTimeIntervalSinceNow:24*60*60];
        SNEventReportInfo* info3 = [[SNEventReportInfo alloc]init];
        info3.count = 3.5;
        info3.date = [NSDate dateWithTimeIntervalSinceNow:48*60*60];

        
        NSArray *objectArray1 = [[NSArray alloc]initWithObjects:info1, info11, info2, info3, nil];
//        NSArray *objectArray2 = [[NSArray alloc]initWithObjects:info2, nil];
//        NSArray *objectArray3 = [[NSArray alloc]initWithObjects:info3, nil];
        
        if (!dic_t) {
            dic_data = [[NSDictionary alloc] initWithObjectsAndKeys:objectArray1, @"ES01", nil];
        } else {
            dic_data = [[NSDictionary alloc] initWithDictionary:dic_t];
        }
        
        view_emGraph = [[JECurvedPlotView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [view_emGraph setBackgroundColor:[UIColor clearColor]];
        [self addSubview:view_emGraph];
        [self setChartAxis];
        [self selectEventTypeAll];
        
    }
    
    return self;
}


- (void)setChartAxis
{
    NSArray *ar_event_t = [dic_data objectForKey:@"ES01"];
    view_emGraph.firstTime = [NSDate dateWithTimeIntervalSinceNow:-48*60*60];
    for (int j = 0; j < ar_event_t.count; j++) {
        SNEventReportInfo *eInfo = [ar_event_t objectAtIndex:j];
        int vaule = (int)eInfo.count;
        NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %d", vaule);
        //设置y坐标轴值为5的倍数，避免中间出现小数点坐标。
        if (j == 0) {
//            view_emGraph.firstTime = eInfo.date;
            view_emGraph.maxCount  = vaule % 5 == 0? vaule: (vaule / 5 + 1) * 5;
            view_emGraph.maxCount  = view_emGraph.maxCount == 0? 5: view_emGraph.maxCount;//y坐标轴最小长度为5
            view_emGraph.minCount  = vaule % 5 == 0? vaule: vaule / 5 * 5;
        } else {
            if (vaule > view_emGraph.maxCount) {
                view_emGraph.maxCount = vaule % 5 == 0? vaule: (vaule / 5 + 1) * 5;
                view_emGraph.maxCount  = view_emGraph.maxCount == 0? 5: view_emGraph.maxCount;//y坐标轴最小长度为5
            }
            if (vaule < view_emGraph.minCount) {
                view_emGraph.minCount = vaule % 5 == 0? vaule: vaule / 5 * 5;
            }
        }
    }
    
//    NSArray *ar_event_t2 = [dic_data objectForKey:@"ES02"];
//    for (int j = 0; j < ar_event_t2.count; j++) {
//        SNEventReportInfo *eInfo = [ar_event_t2 objectAtIndex:j];
//        NSDate  *date_t = eInfo.date;
//        
//        if (j == 0 && (view_emGraph.firstTime == nil || [date_t timeIntervalSinceDate:view_emGraph.firstTime] < 0)) {
//            view_emGraph.firstTime = eInfo.date;
//        }
//        int vaule = (int)eInfo.count;
//        if (vaule > view_emGraph.maxCount) {
//            view_emGraph.maxCount = vaule % 5 == 0? vaule: (vaule / 5 + 1) * 5;
//            view_emGraph.maxCount  = view_emGraph.maxCount == 0? 5: view_emGraph.maxCount;//y坐标轴最小长度为5
//        }
//        if (vaule < view_emGraph.minCount) {
//            view_emGraph.minCount = vaule % 5 == 0? vaule: vaule / 5 * 5;
//        }
//    }
//    
//    NSArray *ar_event_t3 = [dic_data objectForKey:@"EP01"];
//    for (int j = 0; j < ar_event_t3.count; j++) {
//        SNEventReportInfo *eInfo = [ar_event_t3 objectAtIndex:j];
//        NSDate  *date_t = eInfo.date;
//        if (j == 0 && (view_emGraph.firstTime == nil || [date_t timeIntervalSinceDate:view_emGraph.firstTime] < 0)) {
//            view_emGraph.firstTime = eInfo.date;
//        }
//        int vaule = (int)eInfo.count;
//        if (vaule > view_emGraph.maxCount) {
//            view_emGraph.maxCount = vaule % 5 == 0? vaule: (vaule / 5 + 1) * 5;
//            view_emGraph.maxCount  = view_emGraph.maxCount == 0? 5: view_emGraph.maxCount;
//        }
//        if (vaule < view_emGraph.minCount) {
//            view_emGraph.minCount = vaule % 5 == 0? vaule: vaule / 5 * 5;
//        }
//    }
    
    [view_emGraph drawGraph];
}

- (void)addChartLineWithData:(NSDictionary *)dic_event type:(NSString *)typeKey
{
    NSArray *ar_event = [dic_event objectForKey:typeKey];
//    if ([typeKey isEqualToString:@"EP01"]) {
//        [view_emGraph addLineWithIdentifier:@"EP01" color:[CPTColor colorWithComponentRed:235/255.0 green:67/255.0 blue:92/255.0 alpha:1]];
//    }else if ([typeKey isEqualToString:@"ES01"]){
    [view_emGraph addLineWithIdentifier:typeKey color:[CPTColor colorWithComponentRed:55/255.0 green:156/255.0 blue:250/255.0 alpha:1]];
//    }else if ([typeKey isEqualToString:@"ES02"]){
//        [view_emGraph addLineWithIdentifier:@"ES02" color:[CPTColor colorWithComponentRed:156/255.0 green:68/255.0 blue:195/255.0 alpha:1]];
//    }
    
    for (int j = 0; j < ar_event.count; j++) {
        SNEventReportInfo *eInfo = [ar_event objectAtIndex:j];
        NSDate  *date_t = eInfo.date;
        NSTimeInterval interval = [date_t timeIntervalSinceDate:view_emGraph.firstTime];
        NSString *xp = [NSString stringWithFormat:@"%d", (int)interval];
        NSString *yp = [NSString stringWithFormat:@"%d", (int)eInfo.count];
        NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
        [[view_emGraph.mdic_dataFprPlot valueForKey:typeKey] addObject:point1];
    }
}

- (void)refreshChartView:(NSDictionary *)dic_t
{
    for (UIView *v_t in self.subviews) {
        if (v_t == view_emGraph) {
            [v_t removeFromSuperview];
            view_emGraph = nil;
        }
    }
    
    dic_data = nil;
    dic_data = [[NSDictionary alloc] initWithDictionary:dic_t];
    
    view_emGraph = [[JECurvedPlotView alloc] initWithFrame:CGRectMake(0, 0, 320, 210)];
    [view_emGraph setBackgroundColor:[UIColor clearColor]];
    
    [self setChartAxis];
    [self addSubview:view_emGraph];
    
//    switch (e_type) {
//        case event_type_all:
//        {
//            [self selectEventTypeAll];
//        }
//            break;
//        case event_type_EP01:
//        {
//            [self selectEventTypeRed];
//        }
//            break;
//        case event_type_ES01:
//        {
            [self selectEventTypeYellow];
//        }
//            break;
//        case event_type_ES02:
//        {
//            [self selectEventTypePurle];
//        }
//            break;
//            
//        default:
//            break;
//    }
    
}

#pragma mark - selectType
- (void)selectEventType:(SNEventType)type_T
{
//    switch (type_T) {
//        case event_type_all:
//            [self selectEventTypeAll];
//            break;
//        case event_type_EP01:
//            [self selectEventTypeRed];
//            break;
//        case event_type_ES01:
            [self selectEventTypeYellow];
//            break;
//        case event_type_ES02:
//            [self selectEventTypePurle];
//            break;
//        default:
//            break;
//    }
}

- (void)selectEventTypeAll
{
    [view_emGraph.mdic_dataFprPlot removeAllObjects];
    
//    [self addChartLineWithData:dic_data type:@"EP01"];
    [self addChartLineWithData:dic_data type:@"ES01"];
//    [self addChartLineWithData:dic_data type:@"ES02"];
    [view_emGraph refreshGraphView];
    
    e_type = event_type_all;
}
//
//- (void)selectEventTypeRed
//{
//    [view_emGraph.mdic_dataFprPlot removeAllObjects];
//   
//    [self addChartLineWithData:dic_data type:@"EP01"];
//    [view_emGraph refreshGraphView];
//    
//    e_type = event_type_EP01;
//}

- (void)selectEventTypeYellow
{
    [view_emGraph.mdic_dataFprPlot removeAllObjects];
    
    [self addChartLineWithData:dic_data type:@"ES01"];
    [view_emGraph refreshGraphView];  
    
    e_type = event_type_ES01;
}
//
//- (void)selectEventTypePurle
//{
//    [view_emGraph.mdic_dataFprPlot removeAllObjects];
//   
//    [self addChartLineWithData:dic_data type:@"ES02"];
//    [view_emGraph refreshGraphView];
//    
//    e_type = event_type_ES02;
//}


@end
