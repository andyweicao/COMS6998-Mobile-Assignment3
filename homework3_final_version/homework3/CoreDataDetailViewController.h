//
//  CoreDataDetailViewController.h
//  homework3
//
//  Created by Cao Wei on 14-3-26.
//  Copyright (c) 2014年 Cao Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"

@interface CoreDataDetailViewController : UIViewController

@property (strong, nonatomic)Venue *detaildata;


@property (strong, nonatomic) IBOutlet UILabel *name;

@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *rate;
@property (strong, nonatomic) IBOutlet UILabel *lat;
@property (strong, nonatomic) IBOutlet UILabel *lon;

@end
