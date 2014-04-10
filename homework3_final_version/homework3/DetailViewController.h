//
//  DetailViewController.h
//  homework1
//
//  Created by Cao Wei on 14-3-23.
//  Copyright (c) 2014年 Cao Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController{
    NSManagedObjectContext      *managedObjectContext;
    NSArray *fetchedRecordsArray;

    
}
@property (strong, nonatomic)NSDictionary *data;


@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *vicinity;
@property (strong, nonatomic) IBOutlet UILabel *lat;
@property (strong, nonatomic) IBOutlet UILabel *lng;
@property (strong, nonatomic) IBOutlet UILabel *rate;
@property (strong, nonatomic) IBOutlet UIButton *fav;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSArray *fetchedRecordsArray;
- (IBAction)favorite:(id)sender;



@end
