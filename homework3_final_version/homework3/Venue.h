//
//  Venue.h
//  homework3
//
//  Created by Cao Wei on 14-3-25.
//  Copyright (c) 2014年 Cao Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Venue : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * vicinity;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * rate;

@end
