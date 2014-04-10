//
//  AppDelegate.h
//  homework1
//
//  Created by Cao Wei on 14-2-18.
//  Copyright (c) 2014年 Cao Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "ListViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
    
@property (strong, nonatomic) UIWindow *window;




@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(NSArray*)getData;


@end
