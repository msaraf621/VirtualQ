//
//  LineDetailCell.m
//  VirtualQ
//
//  Created by GrepRuby on 19/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "LineDetailCell.h"

@implementation LineDetailCell

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
-(void)applyDefaultStyle{
  
  //Wait User- Label
   self.waitingUserLabel.layer.cornerRadius=UNI_VAL(32, 25);
   self.waitingUserLabel.textAlignment = NSTextAlignmentCenter;
   self.waitingUserLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin |  UIViewAutoresizingFlexibleRightMargin;
    [self.waitingUserLabel setBackgroundColor:[UIColor vqTableViewCellBubbleColor]];
  //[self.waitingUserLabel setBackgroundColor:[[UIColor vqPulseBubbleColor] colorWithAlphaComponent:0.5f]];
  
  //Setting Color of texts
  self.waitingUserLabel.textColor=[UIColor vqTableViewTextColor];
  self.queueNameLabel.textColor=[UIColor vqTableViewTextColor];
  self.addressLabel.textColor=[UIColor vqTableViewTextColor];
  self.disatnceLabel.textColor=[UIColor vqTableViewTextColor];
  
  //Setting fonts of text
  [self.waitingUserLabel setFont:[UIFont vqLookForQueueWaitingUserFont]];
  self.queueNameLabel.font=[UIFont vqQueueNameFont];
  self.addressLabel.font=[UIFont vqLookForQueueAddressFont];
  self.disatnceLabel.font=[UIFont vqLookForQueueDistanceFont];
  [self.arrowAccessory setBackgroundColor:[UIColor whiteColor]];
 
}

@end
