//
//  SNEvnetGraphView.h
//  SNVideo
//
//  Created by Thinking on 14-11-10.
//  Copyright (c) 2014年 StarNet智能家居研发部. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int, SNEventType) {
    event_type_all = 0,         //所有事件
    event_type_EP01,            //沉迷报警
    event_type_ES01,            //高分贝报警
    event_type_ES02,            //玻璃破碎报警
    
};

@interface SNEventGraphView : UIView


- (id)initWithFrame:(CGRect)frame data:(NSDictionary *)dic_t;

- (void)refreshChartView:(NSDictionary *)dic_t;

- (void)selectEventType:(SNEventType)type_T;

@end
