//
//  MapViewController.h
//  homework1
//
//  Created by Cao Wei on 14-2-18.
//  Copyright (c) 2014年 Cao Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapPoint.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


#define kGOOGLE_API_KEY @"AIzaSyA4s32E0NNsoDN67x-5-2yt0QaSr3AOkoM"

@interface MapViewController :UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    BOOL firstLaunch;
    CLLocationCoordinate2D currentCentre;
    CLLocationCoordinate2D locate;
    int currenDist;
   
}
@property (nonatomic) NSString *queryname;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *radius;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;



@end
