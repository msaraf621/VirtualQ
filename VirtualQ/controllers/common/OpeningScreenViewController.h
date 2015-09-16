//
//  OpeningScreenViewController.h
//  VirtualQ
//
//  Created by GrepRuby on 04/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"

@interface OpeningScreenViewController : BaseController <CLLocationManagerDelegate>

@property (nonatomic,strong) NSString *identifierName;
@property (assign) BOOL isCurrentPage;
@end
