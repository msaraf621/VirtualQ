//
//  LookForQueueViewController.h
//  VirtualQ
//
//  Created by GrepRuby on 05/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SWTableViewCell.h"
#import "BaseController.h"
#import "VqAccessory.h"
#import "LineDetailCell.h"


@interface LookForQueueViewController : BaseController <MKMapViewDelegate,SWTableViewCellDelegate,UITableViewDelegate, UITableViewDataSource ,UISearchBarDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@property (nonatomic,strong)  IBOutlet UIButton *openLineButton;
@property (nonatomic,strong)  IBOutlet UIButton *searchButton;
@property (nonatomic,strong)  IBOutlet UIButton *abortButton;


@property (nonatomic,strong) IBOutlet UISearchBar *searchTextField;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic,strong) IBOutlet UIView *topView;

@property (nonatomic,strong) NSIndexPath *selectedIndex;
@property (nonatomic,strong) NSDate *methodEnd;

- (void)configureCell:(LineDetailCell *)cell atIndexPath:(NSIndexPath *)indexPath;
-(void)refreshData;


@end
