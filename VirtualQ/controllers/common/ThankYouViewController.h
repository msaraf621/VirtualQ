//
//  ThankYouViewController.h
//  VirtualQ
//
//  Created by GrepRuby on 18/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThankYouView.h"
#import "BaseController.h"

@interface ThankYouViewController : BaseController 

@property (nonatomic,strong) IBOutlet ThankYouView *thankYouView;
@property (nonatomic,strong) IBOutlet UIView *topView;
@property (nonatomic,strong) IBOutlet UIView *bottomView;
@property (nonatomic,strong) IBOutlet UIButton *anyWaitButton;
@property (nonatomic,strong) IBOutlet UILabel *thankYouLabel;
@property (retain, nonatomic) IBOutlet UIButton *signInButton;
@end
