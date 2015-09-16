//
//  ManageQueueViewController.m
//  VirtualQ
//
//  Created by GrepRuby on 04/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "ManageQueueViewController.h"
#import "APRoundedButtonCustomized.h"
#import "QuitQueueViewController.h"
#import "SlideRigthCustomSegue.h"

#define kAlphaValue 0.2

@interface ManageQueueViewController ()

@property (nonatomic,strong) IBOutlet UIButton *quitManageQueueButton;

@property (nonatomic,strong) IBOutlet UILabel *counterLabel;
@property (nonatomic,strong) IBOutlet UILabel *waitingUserLabel;
@property (nonatomic,strong) IBOutlet UILabel *counterStatusLabel;
@property (nonatomic,strong) IBOutlet UILabel *dragNextLabel;

@property (nonatomic,strong) IBOutlet CounterView *bottomView;
@property (nonatomic,strong) IBOutlet UIView *quitViewButtonView;

@property (nonatomic, strong) NSMutableArray *waitersArray;
@property (nonatomic, strong) NSMutableArray *bubbleArray;
@property (nonatomic, strong) NSMutableArray *partySizeLableArray;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic) CGPoint bubbleOriginCenter;
@property (nonatomic) CGRect counterStatusLabelOriginFrame;

@property (nonatomic, strong) VQWaiters *currentlyUpWaiter;

@end

@implementation ManageQueueViewController

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
    [self applyDefaultStyles];
    [self initLocalization];
    
    self.waitersArray = [NSMutableArray new];
    
    // Arrange the bottom view, so that it starts at the bottom of this views frame.
    CGRect bottomViewFrame = self.bottomView.frame;
    bottomViewFrame.origin.x = 0;
    bottomViewFrame.origin.y = self.view.frame.size.height - self.bottomView.frame.size.height;
    self.bottomView.frame = bottomViewFrame;
    self.counterStatusLabelOriginFrame = self.counterStatusLabel.frame;
}


-(void)applyDefaultStyles{
    
    
    
    //Counter View
    [self.bottomView setBackgroundColor:[UIColor vqCounterViewColor]];
    
    //Quit Button
    [self.quitManageQueueButton setBackgroundColor:[UIColor vqCounterViewColor]];
    
    //Counter Label
    [self.counterLabel setText:@"counter"];
    [self.counterLabel setFont:[UIFont vqCounterLabelFont]];
    [self.counterLabel setBackgroundColor:[UIColor vqCounterViewColor]];
    
    //Counter Status Label
    [self.counterStatusLabel setFont:[UIFont vqCounterStatusLabelFont]];
    
    
    //Waiting User- Label
    self.waitingUserLabel.font=[UIFont vqWaitingUserLableFont];
    
    //Drag Next Label
    self.dragNextLabel.hidden=YES;
    [self.dragNextLabel setText:LOCALIZATION(@"dragInNextForCalling")];
    
    
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(goToQuitQueueScreen)];
    [self.quitViewButtonView addGestureRecognizer:singleFingerTap];
    
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}



-(void)viewDidDisappear:(BOOL)animated
{
    [self.timer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

-(void)viewDidAppear:(BOOL)animated{
    
    //    [self changeCounterStatusLabel];
    
    if ([self.identifierName isEqualToString:@"QuitQueue"]) {
        [self reloadData];
    }else{
        [self refreshData];
    }
    
    self.timer =[NSTimer scheduledTimerWithTimeInterval:AUTOMATIC_REFRESH_TIME target:self selector:@selector(methodCallToRefreshData) userInfo:nil repeats:YES];
    
    
    
    
}

-(void)reloadData{
    // Repopulate the waiter data.
    [self.waitersArray removeAllObjects];
    NSArray *allRecords=[VQWaiters findAllSortedBy:@"position" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"position<=6 OR position==nil"]];
    
    
    if (allRecords.count)
    {
        self.currentlyUpWaiter = allRecords[0];
    } else {
        self.currentlyUpWaiter = nil;
    }
    [self.waitersArray addObjectsFromArray:[allRecords subarrayWithRange:NSMakeRange(1, allRecords.count - 1)]];
    

    [self reloadDisplay];
    
}

- (void)reloadDisplay {
    
    [self createBubblesForWaiters:self.waitersArray];
    
    if (self.waitersArray.count > 0){
        self.dragNextLabel.hidden = NO;
    } else {
        self.dragNextLabel.hidden = YES;
    }
    
}

- (void)updateCounterLabel {
    NSString *currentlyUp = LOCALIZATION(@"noOneInTheLine");
    if (![self.currentlyUpWaiter.group_name isEqualToString:@"Empty"]){
        currentlyUp = [NSString stringWithFormat:@"%@ %@",self.currentlyUpWaiter.group_name,LOCALIZATION(@"isUp")];;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.counterStatusLabel.text = currentlyUp;
        
        self.counterStatusLabel.alpha = 1;
    }];
}

- (void)updateLineSizeLabel {
    int lineSize;
    if (self.currentlyUpWaiter){
        lineSize = self.currentlyUpWaiter.line_size.integerValue;
    } else {
        lineSize = 0;
    }
    NSString *numberOfPeopleStr=[NSString stringWithFormat:@"%d %@",lineSize,LOCALIZATION(@"peopleAreInTheLine")];
    self.waitingUserLabel.text = numberOfPeopleStr;
    
}


- (void)createBubblesForWaiters:(NSArray*)waiters {
    CGFloat positionY = self.view.frame.size.height - self.bottomView.frame.size.height;
    
    if (self.bubbleArray.count < 5){
        self.bubbleArray = [NSMutableArray new];
        self.partySizeLableArray = [NSMutableArray new];
        
        for (int i = 0; i < 5; i++) {
            
            APRoundedButton* bubble = [[APRoundedButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            
        //    bubble.titleLabel.font = [UIFont systemFontOfSize:17];
            [bubble setTitleColor:[UIColor vqBubbleTextColor] forState:UIControlStateNormal];
            [self.bubbleArray addObject:bubble];
            
            UILabel* partySizeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 20)];
            partySizeLable.text = @"Label";
            [self.partySizeLableArray addObject:partySizeLable];
            [self.view addSubview:partySizeLable];
            
            bubble.titleLabel.font  = partySizeLable.font;
            
        }
        
    }
    
    
    
    for (int i = 0; i < 5; i++) {
        
        
        APRoundedButtonCustomized* bubble = self.bubbleArray[i];
        CGRect bubbleFrame = bubble.frame;
        
        UILabel* partySizeLable = self.partySizeLableArray[i];
        CGRect partySizeLableFrame = partySizeLable.frame;
        
        if (bubble.superview == nil){
            [self.view addSubview:bubble];
        }
        
        if (self.bubbleArray.firstObject == bubble) {
            bubbleFrame.size.height = 90;
            bubbleFrame.size.width = 90;
            bubbleFrame.origin.x = (self.view.frame.size.width / 2) - (bubbleFrame.size.width / 2);
            positionY = positionY - 110;
            bubbleFrame.origin.y = positionY;
            partySizeLable.frame = partySizeLableFrame;
            bubble.frame = bubbleFrame;
            
            


            
        } else {
            bubbleFrame.origin.x = (self.view.frame.size.width / 2) - (bubble.frame.size.width / 2);
            positionY = positionY - 80;
            bubbleFrame.origin.y = positionY;
            partySizeLable.frame = partySizeLableFrame;
            bubble.frame = bubbleFrame;
            
            
        }
        
        partySizeLable.center = CGPointMake(CGRectGetMaxX(bubbleFrame) + 80, bubble.center.y - 1);
        partySizeLableFrame.origin.x  = 216;
        partySizeLableFrame.origin.y = partySizeLable.frame.origin.y;
        partySizeLable.frame= partySizeLableFrame;
        [bubble setTitleOfButton:@""];
        
        
        bubble.style = 10;
        
        UILabel *partySizeLabel = self.partySizeLableArray[i];
        
        if (i < waiters.count) {
            VQWaiters *waiter = self.waitersArray[i];
            
            bubble.backgroundColor = [UIColor vqBubbleColor];
            if (bubble.gestureRecognizers.count == 0){
                UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panBubbleWithGestureRecognizer:)];
                panGestureRecognizer.cancelsTouchesInView = YES;
                
                [bubble addGestureRecognizer:panGestureRecognizer];
            }
            
            NSString *designatedTitle = waiter.position.stringValue;
           // bubble.titleLabel.font = [UIFont systemFontOfSize:17];

            if (i == 0){
                designatedTitle = LOCALIZATION(@"Next");
                
       
            //   bubble.layer.affineTransform = CGAffineTransformMakeScale(1.8f, 1.8);
            } else {
            //    bubble.layer.affineTransform = CGAffineTransformMakeScale(1.0f, 1.0);

            }
            
            bubble.titleLabel.text = designatedTitle;
            
            [bubble setTitleOfButton:designatedTitle];
            
            if (waiter.party_size.integerValue > 1){
                partySizeLabel.hidden = NO;
                partySizeLabel.text = [NSString stringWithFormat:@"%@ %@",waiter.party_size,LOCALIZATION(@"people")];
            } else {
                partySizeLable.hidden = YES;
            }
            
            
        } else {
            if (bubble.gestureRecognizers.count > 0){
                [bubble removeGestureRecognizer:bubble.gestureRecognizers[0]];
            }
            partySizeLable.hidden = YES;
            CGFloat alpha = 1.f - (kAlphaValue * i);
            [bubble setBackgroundColor:[[UIColor vqNoUserBubbleColor] colorWithAlphaComponent:alpha]];
            [bubble setNeedsDisplay];
        
            // bubble.backgroundColor =
        }
        
        if (i == 4) {
            bubble.hidden = YES;
            partySizeLable.hidden = YES;
        } else {
            bubble.hidden = NO;
        }
        
    }
}

-(void)panBubbleWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    APRoundedButtonCustomized *selectedBubble = (APRoundedButton*)panGestureRecognizer.view;
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.bubbleOriginCenter = panGestureRecognizer.view.center;
        [self.timer invalidate];
        
        self.dragNextLabel.hidden = YES;
        [UIView animateWithDuration:0.8 animations:^{
            selectedBubble.backgroundColor = [UIColor vqOpenLineBubbleColor];

        }];
    }
    
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        if (selectedBubble.center.y > self.bottomView.center.y-20) {
            NSLog(@"Drop");
            selectedBubble.backgroundColor = [UIColor vqBubbleColor];

            [self.bubbleArray removeObject:selectedBubble];
            
            selectedBubble.frame = CGRectMake(0, 0, 50, 50);
            [selectedBubble setTitleOfButton:@""];
            
            [self.bubbleArray addObject:selectedBubble];
            
            
            
            
            
            self.counterStatusLabel.hidden = YES;
            self.counterStatusLabel.alpha = 0;
            self.counterStatusLabel.hidden = NO;
            
            [self callApi:self.waitersArray[0]];
            [self.waitersArray removeObjectAtIndex:0];
            [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.3 options:0 animations:^{
                [self createBubblesForWaiters:self.waitersArray];
                self.counterStatusLabel.frame = self.counterStatusLabelOriginFrame;
                
            } completion:^(BOOL finished) {
                
            }];
            
        }
        
        self.timer =[NSTimer scheduledTimerWithTimeInterval:AUTOMATIC_REFRESH_TIME target:self selector:@selector(methodCallToRefreshData) userInfo:nil repeats:YES];
        
        [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.3 options:0 animations:^{
            [self createBubblesForWaiters:self.waitersArray];
            self.counterStatusLabel.frame = self.counterStatusLabelOriginFrame;
            
        } completion:^(BOOL finished) {
            
        }];
        
        return;
        
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged){
        
        
        CGPoint touchLocation = [panGestureRecognizer locationInView:self.view];
        CGPoint bubbleCenter = panGestureRecognizer.view.center;
        
        if (touchLocation.y >= self.bubbleOriginCenter.y && touchLocation.y <= self.view.frame.size.height-(panGestureRecognizer.view.frame.size.height / 2)) {
            bubbleCenter.y = touchLocation.y;
        }
        
        panGestureRecognizer.view.center = bubbleCenter;
        CGRect counterStatusLabelFrame = self.counterStatusLabel.frame;
        CGRect counterStatusOriginLabelFrame = self.counterStatusLabelOriginFrame;
        
        counterStatusOriginLabelFrame = [self.view convertRect:counterStatusOriginLabelFrame fromView:self.bottomView];
        
        counterStatusLabelFrame = [self.view convertRect:counterStatusLabelFrame fromView:self.bottomView];
        if (CGRectGetMaxY(selectedBubble.frame) >= counterStatusOriginLabelFrame.origin.y ) {
            counterStatusLabelFrame.origin.y = CGRectGetMaxY(selectedBubble.frame);
            self.counterStatusLabel.frame = [self.bottomView convertRect:counterStatusLabelFrame fromView:self.view];
        } else {
            self.counterStatusLabel.frame = self.counterStatusLabelOriginFrame;
        }
        
        
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)refreshData{
    [self callApiToGetListOfWaiters];
}

-(void)methodCallToRefreshData{
    [self refreshData];
}

-(void)callApiToGetListOfWaiters{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi) {
            
            [self.api getListOfWaiters:@{@"lineId":[self getLineId],@"token":[self getToken]} success:^(AFHTTPRequestOperation *task, id responseObject) {
                
                [self reloadData];
                [self updateLineSizeLabel];
                
                
                [self updateCounterLabel];
                
            } failure:^(AFHTTPRequestOperation *task, NSError *error) {
                [self reloadData];
            }];
        }
        else{
            [self reloadData];
        }
        //   NSLog(@"Reachability: %@",AFStringFromNetworkReachabilityStatus(status));
        
    }];
}



#pragma mark- Navigation

-(void)goToQuitQueueScreen{
    
    [self.timer invalidate];
    QuitQueueViewController *quitQueue = (QuitQueueViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"QuitQueue"];
    quitQueue.lineInfoDic=self.lineInfoDic;
    SlideRigthCustomSegue *segue = [[SlideRigthCustomSegue alloc] initWithIdentifier:@"SlideRigthSegue" source:self destination:quitQueue];
    [segue presentWithDismissPerformAnimated:YES];
    segue = nil;
    
}

-(IBAction)quitQueueButtonTapped:(id)sender{
    [self goToQuitQueueScreen];
}


#pragma  mark- Drag and Drop Animation


-(void)callApi:(VQWaiters *)waiter {
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            self.quitManageQueueButton.enabled=NO;
            self.quitViewButtonView.userInteractionEnabled=NO;
            
            //Pull Waiter to Up Position
            NSDictionary *param=@{@"token":[self getToken], @"waiter_id":waiter.waiters_id, @"lineId":[self getLineId]};
            [self.api pullWaiterIntoUpPosition:param success:^(AFHTTPRequestOperation *task, id responseObject) {
                [self finalizeNetworkCall];
            } failure:^(AFHTTPRequestOperation *task, NSError *error) {
                [self finalizeNetworkCall];
            }];
        } else {
            [self reloadData];
        }
        NSLog(@"Reachability: %@",AFStringFromNetworkReachabilityStatus(status));
        
    }];
    
}

- (void)finalizeNetworkCall {
    [self refreshData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.quitManageQueueButton.enabled=YES;
    self.quitViewButtonView.userInteractionEnabled=YES;
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
    [self.counterLabel setText:LOCALIZATION(@"counter")];
    [self.counterStatusLabel setText:LOCALIZATION(@"noOneInTheLine")];
}

-(void)initLocalization{
    self.arrayOfLanguages = [[[Localisator sharedInstance] availableLanguagesArray] copy];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLanguageChangedNotification:)
                                                 name:kNotificationLanguageChanged
                                               object:nil];
    [self configureViewFromLocalisation];
    
}


@end
