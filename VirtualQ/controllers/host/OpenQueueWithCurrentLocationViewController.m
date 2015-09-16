//
//  OpenQueueWithCurrentLocationViewController.m
//  VirtualQ
//
//  Created by GrepRuby on 29/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "OpenQueueWithCurrentLocationViewController.h"
#import "ManageQueueViewController.h"
#import "OpenQueueViewController.h"
#import "SlideLeftCustomSegue.h"
#import "SlideRigthCustomSegue.h"
#import "ACEAutocompleteBar.h"

@interface OpenQueueWithCurrentLocationViewController ()<ACEAutocompleteDataSource, ACEAutocompleteDelegate>{
    
}


@end

@implementation OpenQueueWithCurrentLocationViewController

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
    [self getCountryName];
    [self applyDefaultStyles];
    [self initLocalization];
    
    
    // Do any additional setup after loading the view.
}

-(void)getCountryName{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:[self getCurrentLocation] completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            //String to hold address
            // NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            //Print the location to console
            NSString *countryNameStr=[placemark country];
            NSString *pinCode=[placemark postalCode];
            [self.countryName setText:countryNameStr];
            NSLog(@"I am currently at %@ , %@",pinCode,countryNameStr);
        }
    }];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

-(void)applyDefaultStyles{
    
    //Color for TextField
    [self.streetName setBackgroundColor:[UIColor vqTextField2Color]];
    [self.streetNumber setBackgroundColor:[UIColor vqTextField2Color]];
    [self.cityName setBackgroundColor:[UIColor vqTextField2Color]];
    [self.countryName setBackgroundColor:[UIColor vqTextField2Color]];
    [self.zipCode setBackgroundColor:[UIColor vqTextField2Color]];
    
    //Placeholder in TextField Color
    
    self.streetName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Street Name"  attributes:@{NSForegroundColorAttributeName:[UIColor vqPlaceholderTextColor]}];
    
    self.cityName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"City Name"  attributes:@{NSForegroundColorAttributeName:[UIColor vqPlaceholderTextColor]}];
    
    self.streetNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Number"  attributes:@{NSForegroundColorAttributeName:[UIColor vqPlaceholderTextColor]}];
    
    self.countryName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Country Name"  attributes:@{NSForegroundColorAttributeName:[UIColor vqPlaceholderTextColor]}];
    
    self.zipCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Zip Code"  attributes:@{NSForegroundColorAttributeName:[UIColor vqPlaceholderTextColor]}];
    
    
    // Fonts fo Text Field
    [self.streetName setFont:[UIFont vqTextFieldFont]];
    [self.streetNumber setFont:[UIFont vqTextFieldFont]];
    [self.cityName setFont:[UIFont vqTextFieldFont]];
    [self.countryName setFont:[UIFont vqTextFieldFont]];
    [self.zipCode setFont:[UIFont vqTextFieldFont]];
    
    //Title Lable at top
    self.titleLable.textColor=[UIColor vqOpenLineBubbleColor];
    self.titleLable.font=[UIFont vqOpenAndManageLineFont];
    
    //Quit Manage Queue Button
    [self.quitManageQueueButton setBackgroundColor:[UIColor vqQuitQueueButtonColor]];
    
    // Open Line Button
    [self.openLineButton setBackgroundColor:[UIColor vqOpenLineBubbleColor]];
    self.openLineButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.openLineButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.openLineButton.titleLabel.font=[UIFont vqOpenLineBubbleFont];
    NSString *openLineStr=[NSString stringWithFormat:@"Open\nline"];
    [self.openLineButton setTitle:openLineStr forState: UIControlStateNormal];
    [self.openLineButton setTitleColor:[UIColor vqOpenLineBubbleTextColor]
                              forState:UIControlStateNormal];
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToOpenQueueScreen)];
    [self.OpenQueueButtonView addGestureRecognizer:singleFingerTap];
    
    
    self.cityNameArray = @[@"Vancouver", @"Seattle", @"Portland", @"Sacramento",@"San Francisco",
                           @"Cupertino", @"Berkeley", @"Sunnyvale", @"Monalisa", @"Palo Alto", @"San Jose",
                           @"Santa Cruz",@"Malibu",@"Santa Monica",@"Los Angeles",@"Long Beach",@"Manhattan",@"Newport Beach",
                           @"San Diego",@"Phoenix",@"Montreal",@"New York",@"New Jersey",@"Chicago",@"Nashville",@"Atlanta",
                           @"Orlando",@"Miami",@"Washington",@"Dublin",@"London",@"Berlin",@"Amsterdam",@"Paris",@"Roma",
                           @"Stockholm",@"Athen",@"Marseille",@"Stuttgart",@"Liverpool",@"Istanbul",@"Hong Kong",@"Tokyo",
                           @"Osaka",@"Shanghai",@"Beijing",@"Melbourne",@"Sydney",@"Gold Coast",@"Perth",@"Auckland",@"Wellington",
                           @"Brisbane",@"Singapore",@"Kuala Lumpur",@"Bangalore",@"Mumbai",@" New Delhi",@"Colombo",@"Bahrain",
                           @"Qatar",@"Napoli",@"Palma",@"Madrid",@"Bilbao",@"Vienna",@"Lisboa",@"Grenoble",@"Hamburg",@"Frankfurt",
                           @"Munich",@"Praha",@"Budapest",@"Helsinki",@"Oslo",@"Riga",@"Tallinn",@"Santiago",@"Buenos Aires",
                           @"Sao Paulo",@"Rio de Janeiro",@"Brasilia",@"La Paz",@"Lima",@" New Orleans",@"Oklahoma",@"Denver",
                           @"  Dallas",@"Milwaukee",@"Calgary",@"Key West",@"Hollywood",@" Santa Maria",@"Las Vegas",@"Lyon",@"Seoul"];
    
    [self.cityName setAutocompleteWithDataSource:self
                                        delegate:self
                                       customize:^(ACEAutocompleteInputView *inputView) {
                                           
                                           // customize the view (optional)
                                           inputView.font = [UIFont systemFontOfSize:15];
                                           inputView.textColor = [UIColor vqPlaceholderTextColor];
                                           inputView.backgroundColor = [UIColor vqTextField2Color];
                                           
                                       }];
    
    // show the keyboard
    // [self.cityName becomeFirstResponder];
    
}

#pragma  mark - Navigations

-(IBAction)openQueueButtonTapped:(id)sender{
    [self goToOpenQueueScreen];
}

-(IBAction)openLineTapped:(id)sender{
    
    if([self.streetName.text length]==0){
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Please enter street name to open a virtual line."
                                                         message:@""
                                                        delegate:self
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if([self.streetNumber.text length]==0){
        
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Please enter street number to open a virtual line."
                                                         message:@""
                                                        delegate:self
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if([self.cityName.text length]==0){
        
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Please enter city name to open a virtual line."
                                                         message:@""
                                                        delegate:self
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if([self.zipCode.text length]==0){
        
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Please enter zip code to open a virtual line."
                                                         message:@""
                                                        delegate:self
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if([self.countryName.text length]==0){
        
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Please enter country name to open a virtual line."
                                                         message:@""
                                                        delegate:self
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    
    
    
    
    self.openLineButton.enabled=NO;
    self.quitManageQueueButton.enabled=NO;
    self.OpenQueueButtonView.userInteractionEnabled=NO;
    
    
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi) {
            [self addingDictionary];
        }
        else {
            //   NSLog(@"Reachability: %@",AFStringFromNetworkReachabilityStatus(status));
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"No internet Connection"
                                                             message:@"You cannot quit line"
                                                            delegate:self
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles: nil];
            [alert show];
        }
        
    }];
    
    
}
-(void)addingDictionary{
    
    NSMutableDictionary *param=[[NSMutableDictionary alloc] init];
    [param setObject:[self getToken] forKey:@"token"];
    
    if(self.streetName!=nil&&self.streetName.text.length!=0){
        [param setObject:self.streetName.text forKey:@"street1"];
    }
    
    if(self.streetNumber!=nil&&self.streetNumber.text.length!=0){
        [param setObject:self.streetName.text forKey:@"street2"];
    }
    
    if(self.cityName!=nil&&self.cityName.text.length!=0){
        [param setObject:self.cityName.text forKey:@"city"];
    }
    
    if(self.countryName!=nil&&self.countryName.text.length!=0){
        [param setObject:self.countryName.text forKey:@"country"];
    }
    
    if(self.zipCode!=nil&&self.zipCode.text.length!=0){
        [param setObject:self.zipCode.text forKey:@"zip_code"];
    }
    
    if([self.storeDataDictionary objectForKey:@"lineName"]){
        [param setObject:[self.storeDataDictionary objectForKey:@"lineName"] forKey:@"name"];
    }
    
    if([self.storeDataDictionary objectForKey:@"shortDescription"]!=nil){
        [param setObject:[self.storeDataDictionary objectForKey:@"shortDescription"] forKey:@"info"];
    }
    
    [self getLatitudeAndLongitudeByAddressString:param];
    
    //Call api
    //[self callApi:param];  //Commented due to apply geoCodeing
}

-(void)goToOpenQueueScreen {
    
    OpenQueueViewController *openQueue = (OpenQueueViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"OpenQueue"];
    openQueue.storeDataDictionary=self.storeDataDictionary;
    SlideRigthCustomSegue *segue = [[SlideRigthCustomSegue alloc] initWithIdentifier:@"SlideRigthSegue" source:self destination:openQueue];
    [segue presentWithDismissPerformAnimated:YES];
    
}

-(void)callApi:(NSDictionary*)param{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.api openQueue:param success:^(AFHTTPRequestOperation *task, id responseObject) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        // Navigate to manage Queue
        [self goToManageQueueScreen:responseObject];
        
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        
        self.openLineButton.enabled=YES;
        self.quitManageQueueButton.enabled=YES;
        self.OpenQueueButtonView.userInteractionEnabled=YES;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
}

-(void)goToManageQueueScreen:(NSDictionary*)lineInfoDic{
    
    
    self.openLineButton.enabled=YES;
    self.quitManageQueueButton.enabled=YES;
    self.OpenQueueButtonView.userInteractionEnabled=YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    ManageQueueViewController *manageQueue = (ManageQueueViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ManageQueue"];
    manageQueue.lineInfoDic=lineInfoDic;
    SlideLeftCustomSegue *segue = [[SlideLeftCustomSegue alloc] initWithIdentifier:@"SlideLeftSegue" source:self destination:manageQueue];
    [segue presentWithDismissPerformAnimated:YES];
    segue = nil;
    
}

#pragma mark - Method to get latitude and longitude According to Location Address

-(void)getLatitudeAndLongitudeByAddressString:(NSMutableDictionary*)param
{
    CLGeocoder *geocoder = [CLGeocoder new];
    NSString *strAddress = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",self.streetNumber.text,self.streetName.text,self.cityName.text,self.countryName.text,self.zipCode.text];
    
    [geocoder geocodeAddressString:strAddress completionHandler:^(NSArray *placemarks, NSError *error) {
        
        
        
        if (error || placemarks.count == 0 ){
            self.openLineButton.enabled=YES;
            self.quitManageQueueButton.enabled=YES;
            self.OpenQueueButtonView.userInteractionEnabled=YES;
            
            [self showLocationNotFoundDialog];
            
        } else {
            CLPlacemark *first = placemarks[0];
            
            [param setObject:@(first.location.coordinate.latitude).stringValue forKey:@"latitude"];
            [param setObject:@(first.location.coordinate.longitude).stringValue forKey:@"longitude"];
            [self callApi:param];
        }
    }];
    
    
}

- (void)showLocationNotFoundDialog {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"We could not determine your location based on the address you supplied. Please verify the data and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
}

#pragma mark - Return Key for KeyBoard

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==self.streetName)
    {
        [self.streetName resignFirstResponder];
        return NO;
    }
    
    if(textField==self.streetNumber)
    {
        [self.streetNumber resignFirstResponder];
        return NO;
    }
    
    if(textField==self.cityName)
    {
        [self.cityName resignFirstResponder];
        return NO;
    }
    
    if(textField==self.countryName)
    {
        [self.countryName resignFirstResponder];
        return NO;
    }
    
    if(textField==self.zipCode)
    {
        [self.zipCode resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.streetName isFirstResponder] && [touch view] != self.streetName) {
        [self.streetName resignFirstResponder];
    }
    
    if ([self.streetNumber isFirstResponder] && [touch view] != self.streetNumber) {
        [self.streetNumber resignFirstResponder];
    }
    
    if ([self.cityName isFirstResponder] && [touch view] != self.cityName) {
        [self.cityName resignFirstResponder];
    }
    
    if ([self.countryName isFirstResponder] && [touch view] != self.countryName) {
        [self.countryName resignFirstResponder];
    }
    
    if ([self.zipCode isFirstResponder] && [touch view] != self.zipCode) {
        [self.zipCode resignFirstResponder];
    }
    
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - Setting character limit in UITextField

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text = textField.text;
    text = [text stringByReplacingCharactersInRange:range withString:string];
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:textField.font}];
    return (textSize.width< textField.bounds.size.width-15) ? YES : NO;
    
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
    self.titleLable.text=LOCALIZATION(@"openAndManageLine");
    
    NSString *openLineStr=[NSString stringWithFormat:@"%@\n%@",LOCALIZATION(@"Open"),LOCALIZATION(@"line")];
    [self.openLineButton setTitle:openLineStr forState: UIControlStateNormal];
    
    self.streetName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LOCALIZATION(@"streetNamePlaceholder")  attributes:@{NSForegroundColorAttributeName:[UIColor vqPlaceholderTextColor]}];
    
    self.cityName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LOCALIZATION(@"cityNamePlaceholder") attributes:@{NSForegroundColorAttributeName:[UIColor vqPlaceholderTextColor]}];
    
    self.streetNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LOCALIZATION(@"streetNumPlaceholder")  attributes:@{NSForegroundColorAttributeName:[UIColor vqPlaceholderTextColor]}];
    
    self.countryName.attributedPlaceholder = [[NSAttributedString alloc] initWithString: LOCALIZATION(@"countryNamePlaceholder")  attributes:@{NSForegroundColorAttributeName:[UIColor vqPlaceholderTextColor]}];
    
    self.zipCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LOCALIZATION(@"zipCodePlaceholder")   attributes:@{NSForegroundColorAttributeName:[UIColor vqPlaceholderTextColor]}];
    
}

-(void)initLocalization{
    self.arrayOfLanguages = [[[Localisator sharedInstance] availableLanguagesArray] copy];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLanguageChangedNotification:)
                                                 name:kNotificationLanguageChanged
                                               object:nil];
    [self configureViewFromLocalisation];
    
}

#pragma mark - Autocomplete Delegate

- (void)textField:(UITextField *)textField didSelectObject:(id)object inInputView:(ACEAutocompleteInputView *)inputView
{
    textField.text = object; // NSString
}



#pragma mark - Autocomplete Data Source

- (NSUInteger)minimumCharactersToTrigger:(ACEAutocompleteInputView *)inputView
{
    return 1;
}

- (void)inputView:(ACEAutocompleteInputView *)inputView itemsFor:(NSString *)query result:(void (^)(NSArray *items))resultBlock;
{
    if (resultBlock != nil) {
        // execute the filter on a background thread to demo the asynchronous capability
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            // execute the filter
            
            NSMutableArray *array;
            
            if (self.cityName.isFirstResponder) {
                array = [self.cityNameArray mutableCopy];
            }
            
            NSMutableArray *data = [NSMutableArray array];
            for (NSString *s in array) {
                if ([s hasPrefix:query]) {
                    [data addObject:s];
                }
            }
            
            // return the filtered array in the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                resultBlock(data);
            });
        });
    }
}

@end
