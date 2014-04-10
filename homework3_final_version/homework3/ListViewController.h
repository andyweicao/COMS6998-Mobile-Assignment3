//
//  ListViewController.h
//  homework1
//
//  Created by Cao Wei on 14-3-23.
//  Copyright (c) 2014年 Cao Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


#define kGOOGLE_API_KEY @"AIzaSyA4s32E0NNsoDN67x-5-2yt0QaSr3AOkoM"


typedef NS_ENUM(int, LocationStatus){
    LocationStatusLoading,
    LocationStatusLoaded
};

@interface ListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>{
    NSString *qname;
    NSString *ty;
    NSString *rad;
}
@property (nonatomic) NSString *qname;
@property (nonatomic) NSString *ty;
@property (nonatomic) NSString *rad;

@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

