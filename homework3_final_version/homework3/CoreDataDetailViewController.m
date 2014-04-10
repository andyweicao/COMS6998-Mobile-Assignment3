//
//  CoreDataDetailViewController.m
//  homework3
//
//  Created by Cao Wei on 14-3-26.
//  Copyright (c) 2014年 Cao Wei. All rights reserved.
//

#import "CoreDataDetailViewController.h"

@interface CoreDataDetailViewController ()

@end

@implementation CoreDataDetailViewController
@synthesize  detaildata;


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
}

- (void)viewWillAppear:(BOOL)animated{
    self.name.text = detaildata.name;
    self.address.text = detaildata.vicinity;
    self.rate.text = detaildata.rate;
    self.lat.text = detaildata.latitude;
    self.lon.text = detaildata.longitude;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
