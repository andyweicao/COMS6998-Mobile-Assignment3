//
//  MapViewController.m
//  homework1
//
//  Created by Cao Wei on 14-2-18.
//  Copyright (c) 2014年 Cao Wei. All rights reserved.
//


#import "MapViewController.h"
#import "AppDelegate.h"
#import <CoreLocation/Corelocation.h>


@interface MapViewController ()
@property(nonatomic, strong) NSString *latit;
@property(nonatomic, strong) NSString *longi;


@end 

@implementation MapViewController
@synthesize mapView,queryname;



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
    //Make this controller the delegate for the map view.
    self.mapView.delegate = self;
    
    
    
    //Instantiate a location object.
    locationManager = [[CLLocationManager alloc] init];
    
    //Make this controller the delegate for the location manager.
    [locationManager setDelegate:self];
    
    //Set some paramater for the location object.
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [locationManager startUpdatingLocation];
    
    // Ensure that we can view our own location in the map view.
    [self.mapView setShowsUserLocation:YES];
    
    //Set the first launch instance variable to allow the map to zoom on the user location when first launched.
    firstLaunch=YES;
    
    [self setAlert];
    
    
    
   
  /*
    double delayInSeconds = 2.6;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        [self queryGooglePlaces];

    });
    
   */
}





- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations[0];
    locate.latitude = location.coordinate.latitude;
    locate.longitude = location.coordinate.longitude;
    
    [locationManager stopUpdatingLocation];
    
    double delayInSeconds = 2.6;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        [self queryGooglePlaces];
        
    });

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    mapView=nil;
    locationManager=nil;
    
}

-(void) queryGooglePlaces
{
    double lati = locate.latitude;
    double lon = locate.longitude;
    
    
    // Start query the Google Places by the url.
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&type=%@&name=%@&sensor=true&key=%@", lati, lon, self.radius, self.type, self.queryname, kGOOGLE_API_KEY];
    
    //Set the string as URL object.
    NSURL *googleRequestURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    
    NSLog(@"Google url: %@", googleRequestURL);
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* places = [json objectForKey:@"results"];
    
    //Write out the data to the console.
    NSLog(@"Google Data: %@", places);
    
    if (([places count] == 0)&&((self.queryname.length !=0)||(self.type.length !=0))){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No matching results!" message:@"Please go back and enter another query." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }

    
    
    //Plot the data in the places array onto the map with the plotPostions method.
    [self plotPositions:places];
    
    
}

- (void)plotPositions:(NSArray *)data
{
    //Remove any existing annotations, user location blue dot remains.
    for (id<MKAnnotation> annotation in mapView.annotations)
    {
        if ([annotation isKindOfClass:[MapPoint class]])
        {
            [mapView removeAnnotation:annotation];
        }
    }
    
    
    //Take data of each place from the Google API's results.
    for (int i=0; i<[data count]; i++)
    {
        
        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary* place = [data objectAtIndex:i];
        
        //There is a specific NSDictionary object that gives us location info.
        NSDictionary *geo = [place objectForKey:@"geometry"];
        
        
        //Get name and address info for adding to a pin.
        NSString *name=[place objectForKey:@"name"];
        NSString *vicinity=[place objectForKey:@"vicinity"];
        
        //Get the lat and long for the location.
        NSDictionary *loc = [geo objectForKey:@"location"];
        
        //Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;
        
        //Set the lat and long.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        
        //Create a new annotiation.
        MapPoint *placeObject = [[MapPoint alloc] initWithName:name address:vicinity coordinate:placeCoord];
        
        
        [mapView addAnnotation:placeObject];
    }
}


#pragma mark - MKMapViewDelegate methods.


- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    
    //Zoom back to the user location after adding a new set of annotations.
    
    //Get the center point of the visible map.
    CLLocationCoordinate2D centre = [mv centerCoordinate];
    
    MKCoordinateRegion region;
    
    double distance = [self.radius doubleValue];

    if (firstLaunch) {
        region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate,distance,distance);
        firstLaunch=NO;
    }else {
        //Set the center point to the visible region of the map and change the radius to the query distance
        region = MKCoordinateRegionMakeWithDistance(centre,currenDist,currenDist);
    }
    
    //Set the visible region of the map.
    [mv setRegion:region animated:YES];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    //Define our reuse indentifier.
    static NSString *identifier = @"MapPoint";
    
    
    if ([annotation isKindOfClass:[MapPoint class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    //Get the east and west points on the map so we calculate the distance (zoom level) of the current map view.
    MKMapRect mRect = self.mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    //Set our current distance instance variable.
    currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    
    //Set our current centre point on the map instance variable.
    currentCentre = self.mapView.centerCoordinate;
}

- (void) setAlert{
    if ((self.queryname.length == 0)&&(self.type.length == 0)){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You typed nothing!" message:@"Please go back and enter your query." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
