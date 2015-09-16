//
//  ManageQueueViewController.h
//  VirtualQ
//
//  Created by GrepRuby on 04/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CounterView.h"
#import "BaseController.h"
#import "APRoundedButton.h"

@interface ManageQueueViewController : BaseController <UIGestureRecognizerDelegate,UIAlertViewDelegate>
-(void)goToQuitQueueScreen;
@property (nonatomic,strong) NSDictionary *lineInfoDic;
@property (nonatomic,strong) NSString *identifierName;

@end
