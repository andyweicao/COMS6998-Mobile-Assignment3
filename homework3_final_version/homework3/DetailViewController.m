//
//  DetailViewController.m
//  homework1
//
//  Created by Cao Wei on 14-3-23.
//  Copyright (c) 2014年 Cao Wei. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "Venue.h"
#import "AppDelegate.h"
@import CoreLocation;
@interface DetailViewController ()


@end

@implementation DetailViewController

@synthesize  managedObjectContext,fetchedRecordsArray;


#pragma mark - Loading delegate
- (void)viewDidLoad
{
    //[super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    // Set core data setting
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.fetchedRecordsArray = [appDelegate getData];
    
    NSLog(@"in data:%@",self.fetchedRecordsArray);


    
    // Set the basic information from the data
    self.titleLabel.text = self.data[@"name"];
    self.vicinity.text = self.data[@"vicinity"];
    if(self.data[@"rating"] == NULL){
        self.rate.text = @"Not rated";
    
    }
    else {
        self.rate.text = [NSString stringWithFormat:@"%@ of 5.0", self.data[@"rating"]];
    }
        
    [self.imageView setImageWithURL:[NSURL URLWithString:self.data[@"icon"]]];
    NSNumber *lati = self.data[@"geometry"][@"location"][@"lat"];
    NSNumber *longti = self.data[@"geometry"][@"location"][@"lng"];
    self.lat.text = [lati stringValue];
    self.lng.text = [longti stringValue];
    
    
    // Identify whether the object is in the "Favorites"
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Venue" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"vicinity like %@ and name like%@",self.vicinity.text, self.titleLabel.text];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *matchingData = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    NSLog(@"in match data:%@",matchingData);

    //int count=0;
    //for (NSManagedObject *obj in matchingData){
        if (matchingData == nil||[matchingData count] == 0) {
            [self.fav setSelected:NO];
            [self.fav setTitle:@"Add to Favorites" forState:UIControlStateNormal];
        }
        else if (matchingData == nil||[matchingData count] != 0){
            [self.fav setSelected:YES];
            [self.fav setTitle:@"In the Favorites" forState:UIControlStateNormal];

        }
      //  count++;
    
    [self.managedObjectContext save:&error];
    
    
   

    
    
}

- (IBAction)favorite:(id)sender {
    
    
    // Manage add to favorites
    if(![self.fav isSelected]){
        NSLog(@"saveData");
        Venue *venue = (Venue *)[NSEntityDescription insertNewObjectForEntityForName:@"Venue" inManagedObjectContext:managedObjectContext];
        venue.name = self.data[@"name"];;
        venue.vicinity = self.data[@"vicinity"];
        venue.latitude = self.lat.text;
        venue.longitude = self.lng.text;
        venue.rate = self.rate.text;
        
        NSError *error;
        
        // here's where the actual save happens, and if it doesn't we print something out to the console
        if (![managedObjectContext save:&error])
        {
            NSLog(@"Problem saving: %@", [error localizedDescription]);
        }
        
        // **** log objects currently in database ****
        // create fetch object, this object fetch's the objects out of the database
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Venue" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        for (NSManagedObject *info in fetchedObjects)
        {
            NSLog(@"Venue name: %@", [info valueForKey:@"name"]);
            NSLog(@"Venue address: %@", [info valueForKey:@"vicinity"]);
            NSLog(@"Venue rate: %@", [info valueForKey:@"rate"]);
        }
        
        [self.fav setTitle:@"In the Favorites" forState:UIControlStateNormal];
        
        //.titleLabel.text = @"In the Favotires";

        
    }
    
    // Manage delete from the favorites
    
    if([self.fav isSelected]){
        
        
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Venue" inManagedObjectContext:managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        [request setEntity:entityDesc];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"vicinity like %@ and name like%@",self.vicinity.text, self.titleLabel.text];
        [request setPredicate:predicate];
        
        NSError *error;
        NSArray *matchingData = [self.managedObjectContext executeFetchRequest:request error:&error];
        
        int count=0;
        for (NSManagedObject *obj in matchingData){
            [self.managedObjectContext deleteObject:obj];
            NSLog(@"delete name: %@", [obj valueForKey:@"name"]);
            NSLog(@"delete address: %@", [obj valueForKey:@"vicinity"]);
            NSLog(@"delete rate: %@", [obj valueForKey:@"rate"]);
            ++count;
        }
        [self.managedObjectContext save:&error];
        
        [self.fav setTitle:@"Add to Favorites" forState:UIControlStateNormal];

        
    }
    
    [self.fav setSelected:![sender isSelected]];
    
    

    
}

@end