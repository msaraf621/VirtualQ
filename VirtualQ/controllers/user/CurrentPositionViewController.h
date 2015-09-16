//
//  CurrentPositionViewController.h
//  VirtualQ
//
//  Created by GrepRuby on 05/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"

@interface CurrentPositionViewController : BaseController

@property (nonatomic,strong) NSDictionary *lineInfoDictionary;
@property (nonatomic,strong) NSDictionary *userInfoDictionary;
@property (nonatomic,strong) NSString *identifierName;
@property (nonatomic,strong) IBOutlet UIScrollView *scrollView;
@end
