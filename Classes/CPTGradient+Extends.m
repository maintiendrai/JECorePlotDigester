//
//  CPTGradient+Extends.m
//  JECorePlotDigester
//
//  Created by Diana on 8/12/15.
//  Copyright (c) 2015 evideo. All rights reserved.
//

#import "CPTGradient+Extends.h"

@interface CPTGradient()

@property (nonatomic, assign) CPTGradientBlendingMode blendingMode;

@property (nonatomic, readwrite, assign) CPTGradientElement *elementList;

@end

@implementation CPTGradient (Extends)


+(instancetype)fadeinfadeoutGradient
{
    CPTGradient *newInstance = [[self alloc] init];
    
    CPTGradientElement color1;
    
    color1.color.red   = CPTFloat(192.0/255.0);
    color1.color.green = CPTFloat(192.0/255.0);
    color1.color.blue  = CPTFloat(192.0/255.0);
    color1.color.alpha = CPTFloat(0.20);
    color1.position    = CPTFloat(0.0);
    
    CPTGradientElement color2;
    color2.color.red   = CPTFloat(192.0/255.0);
    color2.color.green = CPTFloat(192.0/255.0);
    color2.color.blue  = CPTFloat(192.0/255.0);
    color2.color.alpha = CPTFloat(1.00);
    color2.position    = CPTFloat(0.5);
    
    
    CPTGradientElement color3;
    color3.color.red   = CPTFloat(192.0/255.0);
    color3.color.green = CPTFloat(192.0/255.0);
    color3.color.blue  = CPTFloat(192.0/255.0);
    color3.color.alpha = CPTFloat(0.20);
    color3.position    = CPTFloat(1.0);
    
    [newInstance addElement:&color1];
    [newInstance addElement:&color2];
    [newInstance addElement:&color3];
    
    newInstance.blendingMode = CPTChromaticBlendingMode;
    
    return newInstance;
}

-(void)addElement:(CPTGradientElement *)newElement
{
    CPTGradientElement *curElement = self.elementList;
    
    if ( (curElement == NULL) || (newElement->position < curElement->position) ) {
        CPTGradientElement *tmpNext        = curElement;
        CPTGradientElement *newElementList = malloc( sizeof(CPTGradientElement) );
        if ( newElementList ) {
            *newElementList             = *newElement;
            newElementList->nextElement = tmpNext;
            self.elementList            = newElementList;
        }
    }
    else {
        while ( curElement->nextElement != NULL &&
               !( (curElement->position <= newElement->position) &&
                 (newElement->position < curElement->nextElement->position) ) ) {
                   curElement = curElement->nextElement;
               }
        
        CPTGradientElement *tmpNext = curElement->nextElement;
        curElement->nextElement              = malloc( sizeof(CPTGradientElement) );
        *(curElement->nextElement)           = *newElement;
        curElement->nextElement->nextElement = tmpNext;
    }
}



@end
