//
//  workoutCell.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-01-01.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "WorkoutCell.h"

@implementation WorkoutCell : UITableViewCell

CGFloat workoutWidthBorder = 10;
CGFloat workoutHeightBorder = 2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// Override tableviewcell to set the cell's frame
-(void)setFrame:(CGRect)frame
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    frame.origin.x += workoutWidthBorder;   // make table start a few pixels right from its origin
    frame.size.width -= 2 * workoutWidthBorder;    // decrease table's width
    frame.origin.y += workoutHeightBorder;
    frame.size.height -= 2 * workoutHeightBorder;  // add a gap between cells
    
    [super setFrame:frame];
}

@end
