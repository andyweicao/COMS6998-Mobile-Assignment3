//
//  HomeViewController.m
//  homework1
//
//  Created by Cao Wei on 14-2-18.
//  Copyright (c) 2014年 Cao Wei. All rights reserved.
//

#import "HomeViewController.h"
#import "MapViewController.h"
#import "ListViewController.h"
#import "MBProgressHUD.h"


@interface HomeViewController ()
@property(nonatomic, strong) NSString *query;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *radius;
@property(assign) BOOL cancel;
@property(assign) MBProgressHUD *hud;
@end

@implementation HomeViewController
@synthesize nextView,field1,field2,field3;
@synthesize buttonView,boundary,cancelButton;

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
	// Do any additional setup after loading the view.
    
    
    // Manage animation
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UIGravityBehavior *grav = [[UIGravityBehavior alloc] initWithItems:@[buttonView]];
    [grav setGravityDirection:CGVectorMake(0.0, 0.2)];
                               
    UICollisionBehavior *coll = [[UICollisionBehavior alloc] initWithItems:@[buttonView]];
    
    [coll addBoundaryWithIdentifier:@"boundary" fromPoint:self.boundary.frame.origin toPoint:CGPointMake(self.boundary.frame.origin.x+self.boundary.frame.size.width, self.boundary.frame.origin.y)];
    
    [self.animator addBehavior:grav];
    [self.animator addBehavior:coll];
    
    
    
    //Set background color as yellow
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    // Add GR
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dismissKeyboard {
    [field1 resignFirstResponder];
    [field2 resignFirstResponder];

    [field3 resignFirstResponder];

    
}


// Realize the segue and pass the data to the next viewcontroller.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSString *qq = [NSString stringWithString:field1.text];
    NSString *tt = [NSString stringWithString:field2.text];
    self.query = [qq stringByReplacingOccurrencesOfString:@" " withString: @"+"];
    self.type = [tt stringByReplacingOccurrencesOfString:@" " withString: @"+"];
    self.radius = [NSString stringWithString:field3.text];

    
    
    if ([segue.identifier isEqualToString:@"go"]) {
        
        MapViewController *receiver = segue.destinationViewController;
        
        receiver.queryname = self.query;
        receiver.type = self.type;
        receiver.radius = self.radius;
        
        
        UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:1];
        ListViewController *newone = (ListViewController*)[nav.viewControllers objectAtIndex:0];
        newone.qname = self.query;
        newone.ty = self.type;
        newone.rad = self.radius;
        

                 
    }
}

- (IBAction)handle:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0,0) inView:self.view];
}

- (IBAction)searchPlace:(id)sender {
    
    [self.view endEditing:YES];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Configure for text only and offset down
    self.hud.mode = MBProgressHUDModeText;
    self.hud.labelText = @"Waiting for requesting...";
    self.hud.margin = 10.f;
    self.hud.yOffset = 150.f;
    self.hud.removeFromSuperViewOnHide = YES;

    
    self.cancel = NO;
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.cancelButton addTarget:self
               action:@selector(cancelSearch:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton setTitle:@"Cancel Request" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    self.cancelButton.frame = CGRectMake(92.0, 270.0, 140.0, 30.0);
    [self.view addSubview:self.cancelButton];
    
    
    double delayInSeconds = 2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        if(self.cancel == NO){
        [self.cancelButton removeFromSuperview];
            [self.hud hide:YES];
        [self performSegueWithIdentifier:@"go" sender:self];
        }
        
        
    });
}
- (IBAction)setAlert:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Instruction" message:@"1.Enter your query name, type and distance in the textfields.\r2.Press search to make the request.\r3.Choose tabs for different views of results." delegate:nil cancelButtonTitle:@"Got it!" otherButtonTitles:nil, nil];
    [alert show];

}

-(void)cancelSearch:(id)sender {
    NSLog(@"Search cancelled");
    self.cancel=YES;
    [self.hud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your search is cancelled!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:1.8];
    [self.cancelButton removeFromSuperview];
}

-(void)dismissAlertView:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

@end
