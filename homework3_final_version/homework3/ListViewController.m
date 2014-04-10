//
//  ListViewController.m
//  homework1
//
//  Created by Cao Wei on 14-3-23.
//  Copyright (c) 2014年 Cao Wei. All rights reserved.
//

#import "ListViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
@import CoreLocation;

@interface ListViewController ()

@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, strong)CLLocationManager *locationManager;
@property(assign)CLLocationCoordinate2D currentLocation;

@property(assign)LocationStatus currentLocationStatus;
@property(assign)NSIndexPath *pathTapped;
@end

@implementation ListViewController
@synthesize qname,ty,rad;



#pragma mark - Loading methods
-(void)awakeFromNib{
}

- (void)viewDidLoad
{
       
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // Start location manager and data source
    self.dataSource = [NSMutableArray new];
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy =kCLLocationAccuracyBest;
    // Start updating location
    [self.locationManager startUpdatingLocation];
    [self.tableView reloadData];

   
    // Manage the condition that user did not enter the query
    // Add an alert
    if ((self.qname.length == 0)&&(self.ty.length ==0)){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No items" message:@"Please go back and enter your query on the main page." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - Tableview Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //get the size based on items in datasource
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CellOne";
    
    // Modify the dequeue cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier  forIndexPath:indexPath];
    
    NSDictionary *data = self.dataSource[indexPath.row];
    
    id potentialString = data[@"name"];
    
    NSNumber *lat = data[@"geometry"][@"location"][@"lat"];
    NSNumber *lng = data[@"geometry"][@"location"][@"lng"];
    
    
    // The process to calculate distance between each venue and user location
    CLLocation *locA=[[CLLocation alloc] initWithLatitude:self.currentLocation.latitude longitude:self.currentLocation.longitude];
    
    CLLocation *locB=[[CLLocation alloc] initWithLatitude:[lat doubleValue] longitude:[lng doubleValue]];
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    
    // Get the distance in Km
    NSString *distancestring =[[NSString alloc] initWithFormat:@"%f",distance/1000];
    
    
    
    if ([potentialString isKindOfClass:[NSString class]]) {
        
        cell.textLabel.text = (NSString*)potentialString;
        
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Distance: %@ km",distancestring] ;
    //TODO: Modify the cell
    return cell;
    
}
#pragma mark - Location Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    // Get current location
    CLLocation *location = locations[0];
    self.currentLocation = location.coordinate;
    [self.locationManager stopUpdatingLocation];
    
    //update tableview by quering for data and reloading data
    [self getData:^{
        
        
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
    }];
    
    
}

#pragma mark - Helpers
-(void)getData:(void(^)())completion{
    
    
    // Start query the Google Places by the url foramt
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&type=%@&name=%@&sensor=true&key=%@", self.currentLocation.latitude, self.currentLocation.longitude,self.rad,self.ty, self.qname, kGOOGLE_API_KEY];
    
    // Convert string to URL
    NSURL *googleRequestURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    
    NSLog(@"List url: %@",googleRequestURL);
    
    // Retrieve the results of the URL
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        //parse out the json data
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:data
                              
                              options:kNilOptions
                              error:&error];
        
        // Get the results
        NSMutableArray* places = [json objectForKey:@"results"];
        
        // Write out the data to the console
        NSLog(@"Google Data: %@", places);
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:places];
        completion();
        
    });
    
    

}

#pragma mark - TableCell delegate
-(void)basicCellButtonPressedAtIndexpath:(NSIndexPath *)path{
    
    self.pathTapped = path;
    [self performSegueWithIdentifier:@"HomeToDetail" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"HomeToDetail"]) {
        
        NSIndexPath *indexpath = [self.tableView indexPathForSelectedRow];
        
        DetailViewController *receiver = segue.destinationViewController;
        
        receiver.data = [self.dataSource objectAtIndex:indexpath.row];
        
        
    }
}

@end


























