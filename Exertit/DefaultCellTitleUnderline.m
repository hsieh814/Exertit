//
//  DefaultCellTitle.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-06-14.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "DefaultCellTitleUnderline.h"

@implementation DefaultCellTitleUnderline

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
- (void)drawRect:(CGRect)rect
{
    // Draw a line to underline DefaultCell's title
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [themeNavBar CGColor]);
    CGContextSetLineWidth(context, 3.0);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, 280, 0.0);
    CGContextDrawPath(context, kCGPathStroke);
}


@end
