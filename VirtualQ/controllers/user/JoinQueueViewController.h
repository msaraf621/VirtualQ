//
//  JoinQueueViewController.h
//  VirtualQ
//
//  Created by GrepRuby on 05/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"

@interface JoinQueueViewController : BaseController

@property (nonatomic, strong) IBOutlet UIButton *joinLineButton;
@property (nonatomic, strong) IBOutlet UIButton *quitLineButton;
@property (nonatomic,strong) IBOutlet UILabel *nameAndAddressLabel;
@property (nonatomic,strong) IBOutlet UILabel *shortDescriptionLabel;

@property (nonatomic,strong) NSDictionary *lineInfoDictionary;
@property (nonatomic,strong) IBOutlet UIView *quitLineButtonView;

@end
