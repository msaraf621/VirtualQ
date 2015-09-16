//
//  LineDetailCell.h
//  VirtualQ
//
//  Created by GrepRuby on 19/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "VqAccessory.h"


@interface LineDetailCell : SWTableViewCell

@property (nonatomic,strong) IBOutlet UILabel *waitingUserLabel;
@property (nonatomic,strong) IBOutlet UILabel *queueNameLabel;
@property (nonatomic,strong) IBOutlet UILabel *addressLabel;
@property (nonatomic,strong) IBOutlet UILabel *disatnceLabel;
@property (nonatomic,strong) IBOutlet VqAccessory *arrowAccessory;


-(void)applyDefaultStyle;

@end
