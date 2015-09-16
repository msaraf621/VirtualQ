//
//  LookForQueueViewController.m
//  VirtualQ
//
//  Created by GrepRuby on 05/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "LookForQueueViewController.h"
#import "JoinQueueWithCounterViewController.h"
#import "JoinQueueViewController.h"
#import "OpenQueueViewController.h"
#import "LineDetailCell.h"
#import "SWTableViewCell.h"
#import "SlideRigthCustomSegue.h"
#import "SlideLeftCustomSegue.h"
#import "VqAccessory.h"
#import "ADClusterMapView.h"
#import "ADClusterableAnnotation.h"

@interface LookForQueueViewController (){
    int newTranslate;
    CGPoint abortButtonOrigin,searchTextFeildOrigin;
    NSMutableArray *_dataArray;
    //  NSArray *removedIDArray,*newlyInsertedId;
    CLLocation *currentLocation;
    BOOL isUpdateLocation;
    NSTimer *timer;
}

//@property (nonatomic,strong) NSMutableArray* lineIdArray;


@end

@implementation LookForQueueViewController

@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createSession];
    [self applyDefaultStyles];
    [self beginUpdationgLocation];
    [self initLocalization];
    [self addNSNotificationObserver];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    MKCoordinateSpan span = {.latitudeDelta = 0.02, .longitudeDelta =  0.02};
    MKCoordinateRegion region = {[self getCurrentLocation].coordinate, span};
    [self.mapView setRegion:region];
    [self.mapView regionThatFits:region];
    
    [self.mapView setCenterCoordinate:[self getCurrentLocation].coordinate];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    
    self.mapView.showsUserLocation = YES;
    
    //  MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    //  point.coordinate = [self getCurrentLocation].coordinate;
    
    if([VQLine countOfEntities]>0){
        [self refreshData];
    }else{
        [self callApiCheckLocation];
    }
    
    timer =[NSTimer scheduledTimerWithTimeInterval:AUTOMATIC_REFRESH_TIME target:self selector:@selector(methodCallToRefreshData) userInfo:nil repeats:YES];
    // NSLog(@"view did appear");
    
    /* self.lineIdArray=[[NSMutableArray alloc] init];
     
     for (int i=0; i<[_dataArray count]; i++) {
     
     NSDictionary *dic=@{@"lineId":[[_dataArray valueForKey:@"line_id"] objectAtIndex:i],@"latitude":[[_dataArray valueForKey:@"latitude"] objectAtIndex:i], @"longitude":[[_dataArray valueForKey:@"longitude"] objectAtIndex:i]};
     [self.lineIdArray addObject:dic];
     } */
    
}

//Check Token First
-(void)createSession{
    NSLog(@"Look For Queue --- %@",[self class]);
    
    if ([self.vqDefaults valueForKey:@"token"]==nil) {
        NSLog(@" --- %@",self.presentedViewController);
        
        [self.api createSession:@{@"deviceID": [self getDeviceUDID]} success:^(AFHTTPRequestOperation *task, id responseObject) {
            
        } failure:^(AFHTTPRequestOperation *task, NSError *error) {
            
            [self performSelector:@selector(createSession) withObject:nil afterDelay:0];
        }];
    }
}


-(void)applyDefaultStyles
{
    
    _dataArray = [NSMutableArray new];
    self.mapView.showsUserLocation = YES;
    self.mapView.zoomEnabled=YES;
    
    abortButtonOrigin=self.abortButton.center;
    searchTextFeildOrigin=self.searchTextField.center;
    
    //Bring open Line Button to front
    [self.view bringSubviewToFront:self.openLineButton];
    
    // Open Line Button
    [self.openLineButton setBackgroundColor:[UIColor vqOpenLineBubbleColor]];
    [self.openLineButton setAlpha:0.75f];
    self.openLineButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.openLineButton.titleLabel.font=[UIFont vqOpenLineBubbleFont];
    self.openLineButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    NSString *openLineStr=[NSString stringWithFormat:@"Open\nline"];
    [self.openLineButton setTitle:openLineStr forState: UIControlStateNormal];
    
    //Top View
    [self.topView setBackgroundColor:[[UIColor whiteColor]colorWithAlphaComponent:0.5f]];
    
    //Search UI Text Field
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:[UIColor vqBubbleColor]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    // [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFrame:CGRectMake(0, 0, 100, 100)];
    
    //Search Button
    [self.searchButton setBackgroundColor:[UIColor vqBubbleColor]];
    
    self.searchTextField.hidden=YES;
    self.searchTextField.layer.cornerRadius  = 6;
    self.searchTextField.clipsToBounds       = YES;
    //[self.searchTextField.layer setBorderWidth:0.1];
    //[self.searchTextField.layer setBorderColor:[[UIColor vqPulseBubbleColor] CGColor]];
    
    for (UIView *view in [[self.searchTextField.subviews objectAtIndex:0] subviews]){
        if ([NSStringFromClass([view class]) isEqualToString:@"UISearchBarBackground"])
            view.alpha = 0;
    }
    
    
    
    
    //Abort Button
    self.abortButton.hidden=YES;
    [self.abortButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.abortButton setTitleColor:[UIColor vqTableViewTextColor]
                           forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.mapView.delegate = nil;
    [self.mapView removeFromSuperview];
    self.mapView = nil;
    
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    _dataArray=nil;
    [timer invalidate];
    [self removeNSNotificationObserver];
    [self stopUpdatingLocation];
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

#pragma mark - ADClusterMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    
    MKAnnotationView * pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"MapViewAnnotation"];
    if (!pinView) {
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:@"MapViewAnnotation"];
        pinView.image = [UIImage imageNamed:@"map_icon"];
        pinView.canShowCallout = YES;
    }
    else {
        pinView.annotation = annotation;
    }
    return pinView;
}

/*
 - (MKAnnotationView *)mapView:(ADClusterMapView *)mapView viewForClusterAnnotation:(id<MKAnnotation>)annotation {
 MKAnnotationView * pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"ADMapCluster"];
 if (!pinView) {
 pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
 reuseIdentifier:@"ADMapCluster"];
 pinView.image = [UIImage imageNamed:@"marker-small"];
 pinView.canShowCallout = YES;
 }
 else {
 pinView.annotation = annotation;
 }
 return pinView;
 }
 
 
 - (void)mapViewDidFinishClustering:(ADClusterMapView *)mapView {
 NSLog(@"Done");
 }
 
 - (NSInteger)numberOfClustersInMapView:(ADClusterMapView *)mapView {
 return 10;
 }
 
 - (double)clusterDiscriminationPowerForMapView:(ADClusterMapView *)mapView {
 return 1.2;
 }
 
 
 -(void)getArrayForAnnotations{
 
 NSMutableArray *newLineIdArray=[[NSMutableArray alloc] init];
 newlyInsertedId=[[NSMutableArray alloc] init];
 
 for (int i=0; i<[_dataArray count]; i++) {
 
 //  NSNumber *lineId=[[_dataArray valueForKey:@"line_id"] objectAtIndex:i];
 // CLLocation *location=[[CLLocation alloc] initWithLatitude:[[[_dataArray valueForKey:@"latitude"] objectAtIndex:i]doubleValue] longitude:[[[_dataArray valueForKey:@"longitude"] objectAtIndex:i]doubleValue]];
 NSDictionary *dic=@{@"lineId":[[_dataArray valueForKey:@"line_id"] objectAtIndex:i],@"latitude":[[_dataArray valueForKey:@"latitude"] objectAtIndex:i], @"longitude":[[_dataArray valueForKey:@"longitude"] objectAtIndex:i]};
 
 [newLineIdArray addObject:dic];
 
 if (![[self.lineIdArray valueForKey:@"lineId"] containsObject:[[_dataArray valueForKey:@"line_id"] objectAtIndex:i]]) {
 [newlyInsertedId addObject:dic];
 }
 }
 
 NSPredicate *intersectPredicate = [NSPredicate predicateWithFormat:@"NOT(SELF IN %@)", newLineIdArray];
 removedIDArray = [self.lineIdArray filteredArrayUsingPredicate:intersectPredicate];
 NSLog(@"RemovedlineId -- %@",removedIDArray);
 
 self.lineIdArray=newLineIdArray;
 
 } */

-(void)addAnnotationOnMap{
    
    // [self getArrayForAnnotations];
    
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        
        //  if ([removedIDArray valueForKey:@"latitiude"] == [[_dataArray valueForKey:@"latitiude"] objectAtIndex:i] &&  [self.lineIdArray valueForKey:@"longitude"] == [[_dataArray valueForKey:@"longitude"] objectAtIndex:i] ) {
        
        [self.mapView removeAnnotation:annotation];
        
        /*
         float lat=[annotation coordinate].latitude;
         float lon=[annotation coordinate].longitude;
         
         if ([[removedIDArray valueForKey:@"latitiude"] containsObject:@21.8648045] && [[removedIDArray valueForKey:@"longitude"] containsObject:) {
         [self.mapView removeAnnotation:annotation];
         }
         i++; */
    }
    
    NSMutableArray * annotations = [[NSMutableArray alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        for ( int i=0; i<[_dataArray count]; i++)
        {
            
            float latitude=[[_dataArray[i] valueForKey:@"latitude"] floatValue];
            float longitude=[[_dataArray[i] valueForKey:@"longitude"] floatValue];
            
            NSString *titleStr =[_dataArray[i] valueForKey:@"name"];
            
            ADClusterableAnnotation * annotation = [[ADClusterableAnnotation alloc] initWithDictionary:@{@"coordinates":[[CLLocation alloc] initWithLatitude:latitude longitude:longitude],@"name": titleStr}];
            [annotations addObject:annotation];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //  NSLog(@"Building KD-Tree…");
            [self.mapView addAnnotations:annotations];
        });
    });
    
    annotations=nil;
    
    
    
}
#pragma mark- UITableViewDataSource


-(void)refreshData{
    
    [_dataArray removeAllObjects];
    NSManagedObjectContext *localContext =[NSManagedObjectContext contextForCurrentThread];
    NSArray *allRecords = [VQLine findAllSortedBy:@"distance" ascending:YES withPredicate:nil inContext:localContext];
    [_dataArray addObjectsFromArray:allRecords];
    [self.tableView reloadData];
    [self addAnnotationOnMap];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UNI_VAL(80, 53.5);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // NSLog(@"cell selected at index path %ld:%ld", (long)indexPath.section, (long)indexPath.row);
    //  NSLog(@"selected cell index path is %@", [self.tableView indexPathForSelectedRow]);
//    LineDetailCell *cell = (LineDetailCell*)[self.tableView cellForRowAtIndexPath:indexPath];
//    if(self.selectedIndex){
//        LineDetailCell *oldCell = (LineDetailCell*)[self.tableView cellForRowAtIndexPath:self.selectedIndex];
//        oldCell.backgroundColor = [UIColor vqBackgroundColor];
//        [oldCell.waitingUserLabel setBackgroundColor:[[UIColor vqPulseBubbleColor] colorWithAlphaComponent:0.5f]];
//        [oldCell.arrowAccessory setBackgroundColor:[UIColor vqBackgroundColor]];
//        
//    }
//    cell.backgroundColor = [UIColor vqTeaserStateColor];
//    [cell.waitingUserLabel setBackgroundColor:[UIColor vqPulseBubbleColor]];
//    [cell.arrowAccessory setBackgroundColor:[UIColor vqTeaserStateColor]];
//    self.selectedIndex = indexPath;
    
        NSNumber *lineId=[_dataArray[indexPath.row] valueForKey:@"line_id"];
        [self.vqDefaults setObject:lineId forKey:@"lineId"];
        [self.vqDefaults synchronize];
        
        
        
        [self goToJoinQueueWithCounterScreen:[_dataArray objectAtIndex:indexPath.row]];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableIdentifier = @"LineDetailCell";
    LineDetailCell *cell ;
    if (cell == nil) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:TableIdentifier forIndexPath:indexPath];
        [cell setLeftUtilityButtons:[self leftButtons] WithButtonWidth:UNI_VAL(150, 100)];
        cell.delegate=self;
    }
    cell.backgroundColor = [UIColor whiteColor];
    [cell.waitingUserLabel setBackgroundColor:[[UIColor vqPulseBubbleColor] colorWithAlphaComponent:0.5f]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureCell:cell atIndexPath:indexPath];
    cell.tag=indexPath.row;
    [cell applyDefaultStyle];
    return cell;
}


- (void)configureCell:(LineDetailCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    VQLine *line=[_dataArray objectAtIndex:indexPath.row];
    NSString *lineSizeStr=[NSString stringWithFormat:@"%@",line.line_size];
    [cell.waitingUserLabel setText:lineSizeStr];
    [cell.queueNameLabel setText:line.name];
    [cell.addressLabel setText:line.location];
    
    // calc the distance.
    
    CLLocation *lastLocation = self.locationManager.location;
    CLLocation *lineLocation = line.computedLocation;
    NSString *distanceStr = @"";

    if (lastLocation && lineLocation){
        distanceStr = [NSString stringWithFormat:@"%.1fkm",[lastLocation distanceFromLocation:lineLocation] / 1000.f];
    }
    
    [cell.disatnceLabel setText:distanceStr];
    
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [[NSMutableArray alloc] init];
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor vqJoinButtonColor] title:LOCALIZATION(@"join")];
    return leftUtilityButtons;
    
}
# pragma  mark - Update Location

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //NSDate *methodStart = [NSDate date];
    //NSTimeInterval executionTime = [methodStart timeIntervalSinceDate:self.methodEnd];
    self.methodEnd=[NSDate date];
    //NSLog(@"executionTime = %f", executionTime);
    
    // NSLog(@"Update Locations");
    CLLocation *newLocation = [locations lastObject];
    isUpdateLocation=true;
    CLLocation *oldLocation;
    if (locations.count > 1) {
        oldLocation = [locations objectAtIndex:locations.count-1];
    } else {
        oldLocation = nil;
    }
    
    
    if((newLocation.coordinate.latitude!=currentLocation.coordinate.latitude)&&(newLocation.coordinate.longitude!=currentLocation.coordinate.longitude)){
        
        currentLocation=newLocation;
        
        NSNumber *latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
        NSNumber *longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
        
        [self.vqDefaults setObject:latitude forKey:@"latitude"];
        [self.vqDefaults setObject:longitude forKey:@"longitude"];
        [self.vqDefaults synchronize];
        
        //    NSLog(@"OldLocation ---%f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
        //   NSLog(@"NewLocation ---%f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
        
        [self callApiCheckLocation];
    }
    
    
    
}

-(void)stopUpdatingLocation{
    [self.locationManager stopUpdatingLocation];
}

-(void)beginUpdationgLocation{
    
    if(self.locationManager==nil){
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    self.locationManager.delegate = self;

    SEL requestSelector = NSSelectorFromString(@"requestWhenInUseAuthorization");
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined &&
        [self.locationManager respondsToSelector:requestSelector]) {
        // False Alert Warning. //MH
        [self.locationManager performSelector:requestSelector withObject:NULL];
    } else {
        [self.locationManager startUpdatingLocation];
    }
    
    self.locationManager.distanceFilter = 100;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    currentLocation = [self.locationManager location];
    [self.locationManager startUpdatingLocation];
    //  NSLog(@"%f %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    NSNumber *latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
    
    [self.vqDefaults setObject:latitude forKey:@"latitude"];
    [self.vqDefaults setObject:longitude forKey:@"longitude"];
    [self.vqDefaults synchronize];
        
}

-(void)callThisFunctionAtInterval{
    /*[NSTimer scheduledTimerWithTimeInterval:2 target:self
     selector:@selector(callThisFunctionAtInterval) userInfo:nil repeats:NO];
     if(!self.methodEnd){
     self.methodEnd = [NSDate date];
     }
     NSTimeInterval executionTime = [[NSDate date] timeIntervalSinceDate:self.methodEnd];
     NSNumber *latitude = (NSNumber*)[self.vqDefaults  objectForKey:@"latitude"];
     NSNumber *longitude = (NSNumber*)[self.vqDefaults  objectForKey:@"longitude"];
     // NSLog(@"Interval Call");
     if(executionTime > 2 && self.isCalledAPI==FALSE && ([latitude floatValue] != 0 && [longitude floatValue] != 0)   ){
     latitude = @0;
     longitude = @0;
     self.vqDefaults = [NSUserDefaults standardUserDefaults];
     [self.vqDefaults setObject:latitude forKey:@"latitude"];
     [self.vqDefaults setObject:longitude forKey:@"longitude"];
     [self.vqDefaults synchronize];
     NSLog(@"API Call to get all lines");
     [self callApiToGetAllLines];
     //  self.isCalledAPI=true;
     
     }*/
}

#pragma mark- Annotation Click events


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    //  NSLog(@"Annotation clik--- %f",view.center.x);
    
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    
    LineDetailCell *detailCell = (LineDetailCell*)cell;
    
    switch (state) {
        case 0:
            detailCell.backgroundColor = [UIColor whiteColor];
            detailCell.waitingUserLabel.backgroundColor = [[UIColor vqPulseBubbleColor]colorWithAlphaComponent:0.5f];
            detailCell.arrowAccessory.backgroundColor=[UIColor whiteColor];
            timer =[NSTimer scheduledTimerWithTimeInterval:AUTOMATIC_REFRESH_TIME target:self selector:@selector(methodCallToRefreshData) userInfo:nil repeats:YES];
            //    NSLog(@"utility buttons closed");
            break;
            
        case 1:{
            
            [timer invalidate];
            detailCell.backgroundColor = [UIColor vqTeaserStateColor];
            detailCell.waitingUserLabel.backgroundColor = [UIColor vqPulseBubbleColor];
            [detailCell.arrowAccessory setBackgroundColor:[UIColor vqTeaserStateColor]];
            NSInteger indexPath = detailCell.tag;
            VQLine *line = [_dataArray objectAtIndex:indexPath];
            //  NSLog(@"Line joined : %@",line.line_id);
            //    NSLog(@"Line joined : %@",line);
            [self.vqDefaults setObject:line.line_id forKey:@"lineId"];
            [self.vqDefaults synchronize];
            
            [self goToJoinQueueWithCounterScreen:[_dataArray objectAtIndex:indexPath]];
            
            //    NSLog(@"left utility buttons open");
            
        }
            
            break;
            
        case 2:
            //      NSLog(@"right utility buttons open");
            break;
        default:
            
            break;
    }
}



- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    
    LineDetailCell *detailCell = (LineDetailCell*)cell;
    
    switch (index) {
        case 0:{
            //      NSLog(@"left button 0 was pressed");
            [timer invalidate];
            [self removeNSNotificationObserver];
            
            NSInteger indexPath = detailCell.tag;
            // NSLog(@"%d",indexPath);
            NSNumber *lineId=[_dataArray[indexPath] valueForKey:@"line_id"];
            [self.vqDefaults setObject:lineId forKey:@"lineId"];
            [self.vqDefaults synchronize];
            
            
            
            [self goToJoinQueueWithCounterScreen:[_dataArray objectAtIndex:indexPath]];
            
            
        }
            break;
            
        default:
            break;
    }
}
// click event on right utility button
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    
}



- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}

#pragma mark- Navigation to another screens

-(IBAction)openLineButtonTapped:(id)sender{
    [timer invalidate];
    [self removeNSNotificationObserver];
    OpenQueueViewController *openQueue = (OpenQueueViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"OpenQueue"];
    SlideLeftCustomSegue *segue = [[SlideLeftCustomSegue alloc] initWithIdentifier:@"SlideLeftSegue" source:self destination:openQueue];
    [segue presentWithDismissPerformAnimated:YES];
}

-(IBAction)searchButtonTapped:(id)sender{
    int translateAbortButton=self.view.frame.size.width-(self.abortButton.frame.size.width*UNI_VAL(2, 1.25));
    int translateSearchTextField=self.view.frame.size.width-(self.searchTextField.frame.size.width/2.75);
    [UIView animateWithDuration:0.3 animations:^{
        self.searchTextField.hidden=NO;
        self.abortButton.hidden=NO;
        self.searchButton.hidden=YES;
        self.openLineButton.hidden=YES;
        self.abortButton.center=CGPointMake(self.abortButton.center.x+translateAbortButton, self.abortButton.center.y);
        self.searchTextField.center=CGPointMake(self.searchTextField.center.x+translateSearchTextField, self.searchTextField.center.y);
        
    } completion:^(BOOL finished) {
        
    }];
}

-(IBAction)abortButtonTapped:(id)sender{
    
    [self.searchTextField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.abortButton.center=abortButtonOrigin;
        self.searchTextField.center=searchTextFeildOrigin;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.abortButton.hidden=YES;
            self.searchButton.hidden=NO;
            self.openLineButton.hidden=NO;
            
        } completion:^(BOOL finished) {
            
            [self callApiCheckLocation];
            timer =[NSTimer scheduledTimerWithTimeInterval:AUTOMATIC_REFRESH_TIME target:self selector:@selector(methodCallToRefreshData) userInfo:nil repeats:YES];
            self.searchTextField.hidden=YES;
            
        }];
    }];
}

-(void)goToJoinQueueWithCounterScreen:(NSDictionary*)lineInfoDictionary{
    
    JoinQueueWithCounterViewController *joinQueueWithCounter = (JoinQueueWithCounterViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"JoinQueueWithCounter"];
    joinQueueWithCounter.lineInfoDictionary=lineInfoDictionary;
    SlideRigthCustomSegue *segue = [[SlideRigthCustomSegue alloc] initWithIdentifier:@"SlideRigthSegue" source:self destination:joinQueueWithCounter];
    [segue presentWithDismissPerformAnimated:YES];
    
    
}

-(void)goToJoinQueueScreen:(NSDictionary*)lineInfoDictionary{
    
    JoinQueueViewController *joinQueue = (JoinQueueViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"JoinQueue"];
    joinQueue.lineInfoDictionary=lineInfoDictionary;
    SlideRigthCustomSegue *segue = [[SlideRigthCustomSegue alloc] initWithIdentifier:@"SlideRigthSegue" source:self destination:joinQueue];
    [segue presentPerformAnimated:YES];
    
}

#pragma mark - Setting character limit in UITextField

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text = textField.text;
    text = [text stringByReplacingCharactersInRange:range withString:string];
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:textField.font}];
    return (textSize.width< textField.bounds.size.width-15) ? YES : NO;
    
}

# pragma mark- Return Key for keyboards

-(BOOL)textFieldShouldReturn:(UISearchBar *)textField
{
    if(textField==self.searchTextField)
    {
        [self.searchTextField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [timer invalidate];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi) {
            
            [self.api getLineBySearchTerm:@{@"search_term":searchBar.text,@"userLocation":[self getCurrentLocation]} success:^(AFHTTPRequestOperation *task, id responseObject) {
                [self refreshData];
                
            } failure:^(AFHTTPRequestOperation *task, NSError *error) {
                
            }];
        }
        //  NSLog(@"Reachability: %@",AFStringFromNetworkReachabilityStatus(status));
    }];
    [searchBar resignFirstResponder];
}


- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string {
    
    NSString *text = searchBar.text;
    text = [text stringByReplacingCharactersInRange:range withString:string];
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont vqTextFieldFont]}];
    return (textSize.width< searchBar.bounds.size.width-70) ? YES : NO;
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorized){
        [self.locationManager startUpdatingLocation];
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        
        
        self.mapView.showsUserLocation = YES;
    }
}

#pragma mark - Notification methods for Localization

- (void) receiveLanguageChangedNotification:(NSNotification *) notification
{
    if ([notification.name isEqualToString:kNotificationLanguageChanged])
    {
        [self configureViewFromLocalisation];
    }
}

-(void)configureViewFromLocalisation
{
    NSString *openLineStr=[NSString stringWithFormat:@"%@\n%@",LOCALIZATION(@"Open"),LOCALIZATION(@"line")];
    [self.openLineButton setTitle:openLineStr forState: UIControlStateNormal];
    [self.searchTextField setPlaceholder:LOCALIZATION(@"searchForLocation")];
    [self.abortButton setTitle:LOCALIZATION(@"cancel") forState:UIControlStateNormal];
    
}

-(void)initLocalization{
    self.arrayOfLanguages = [[[Localisator sharedInstance] availableLanguagesArray] copy];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLanguageChangedNotification:)
                                                 name:kNotificationLanguageChanged
                                               object:nil];
    [self configureViewFromLocalisation];
    
}



#pragma mark- Round Off Number

-(NSString*)roundOffNumber:(NSNumber*)number{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:1];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    NSString *numberString = [formatter stringFromNumber:number];
    NSInteger num=[number floatValue];
    if(num>99){
        numberString=[NSString stringWithFormat:@"%ld",(long)num];
    }
    
    return numberString;
}

#pragma mark- Call api

-(void)callApi{
    
    [self.api getLine:@{@"userLocation": [self getCurrentLocation]} success:^(AFHTTPRequestOperation *task, id responseObject) {
        [self refreshData];
        //  NSLog(@"API call ---- Current location.");
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        [self refreshData];
        
    }];
    
}


-(void)callApiToGetAllLines{
    [self.api getAllLine:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
        [self refreshData];
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        [self refreshData];
    }];
}

-(void)callApiCheckLocation{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // switch to a background thread and perform your expensive operation
                if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
                    
                    //       NSLog(@"Location Service enabled");
                    //Calling api
                    NSNumber *latitude = (NSNumber*)[self.vqDefaults  objectForKey:@"latitude"];
                    NSNumber *longitude = (NSNumber*)[self.vqDefaults  objectForKey:@"longitude"];
                    if ([latitude isEqualToNumber:@0] && [longitude isEqualToNumber:@0]){
                        [self callApiToGetAllLines];
                    }
                    else{
                        [self callApi];
                    }
                }
                else
                {
                    //      NSLog(@"Location Service disabled");
                    [self callApiToGetAllLines];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // switch back to the main thread to update your UI
                    
                });
            });
            
        }
        //    NSLog(@"Reachability: %@",AFStringFromNetworkReachabilityStatus(status));
    }];
    
}

#pragma mark- NSNotification Method

-(void)removeNSNotificationObserver{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

-(void)addNSNotificationObserver{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}




- (void)appDidBecomeActive:(NSNotification *)notification {
    
    if([self isKindOfClass:[LookForQueueViewController class]]){
        [self beginUpdationgLocation];
        [self callApiCheckLocation];
        
        MKCoordinateSpan span = {.latitudeDelta = 0.001, .longitudeDelta =  0.001};
        MKCoordinateRegion region = {[self getCurrentLocation].coordinate, span};
        [self.mapView setRegion:region];
        [self.mapView regionThatFits:region];
        self.mapView.showsUserLocation = YES;
        [self.mapView setCenterCoordinate:[self getCurrentLocation].coordinate];
        
    }else{
    }
}


- (void)appDidEnterForeground:(NSNotification *)notification {
    if([self isKindOfClass:[LookForQueueViewController class]]){
    }else{
    }
    
}


-(void)methodCallToRefreshData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Call your function or whatever work that needs to be done
        //Code in this part is run on a background thread
        
        //    NSLog(@"Refresh Data- Look Queue");
        [self callApiCheckLocation];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            //Stop your activity indicator or anything else with the GUI
            //Code here is run on the main thread
            
        });
    });
    
}


@end
