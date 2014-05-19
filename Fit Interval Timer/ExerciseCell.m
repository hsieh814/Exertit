//
//  ExerciseCell.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 3/17/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "ExerciseCell.h"

@implementation ExerciseCell : UITableViewCell

CGFloat widthBorder = 10;
CGFloat heightBorder = 2;

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

- (IBAction)buttonClicked:(id)sender
{
    if (sender == self.deleteButton) {
        NSLog(@"clicked delete button");
    } else  if (sender == self.favButton) {
        NSLog(@"clicked fav button");
    } else {
        NSLog(@"clicked neither");
    }
}


// Override tableviewcell to set the cell's frame
-(void)setFrame:(CGRect)frame
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    frame.origin.x += widthBorder;   // make table start a few pixels right from its origin
    frame.size.width -= 2 * widthBorder;    // decrease table's width
    frame.origin.y += heightBorder;
    frame.size.height -= 2 * heightBorder;  // add a gap between cells
    
    [super setFrame:frame];
}

@end
