//
//  DefaultCell.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-06-14.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "DefaultCell.h"

@implementation DefaultCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    self.defaultWidthBorder = 10;
    self.defaultHeightBorder = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// Override tableviewcell to set the cell's frame
-(void)setFrame:(CGRect)frame
{
    //    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    frame.origin.x += self.defaultWidthBorder;   // make table start a few pixels right from its origin
    frame.size.width -= 2 * self.defaultWidthBorder;    // decrease table's width
    frame.origin.y += self.defaultHeightBorder;
    frame.size.height -= 2 * self.defaultHeightBorder;  // add a gap between cells
    
    [super setFrame:frame];
}

@end
