//
//  HomeViewController.h
//  homework1
//
//  Created by Cao Wei on 14-2-18.
//  Copyright (c) 2014年 Cao Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"

@interface HomeViewController : UIViewController<UITextFieldDelegate>{
    IBOutlet UIView *buttonView;
    IBOutlet UIView *boundary;
    IBOutlet UIButton *cancelButton;
}

@property (nonatomic) MapViewController *nextView;


@property (strong, nonatomic) IBOutlet UITextField *field1;

@property (strong, nonatomic) IBOutlet UITextField *field2;

@property (strong, nonatomic) IBOutlet UITextField *field3;

- (IBAction)setAlert:(id)sender;

@property (strong, nonatomic)UIDynamicAnimator *animator;
@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) IBOutlet UIView *boundary;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
- (IBAction)handle:(UIPanGestureRecognizer *)recognizer;
- (IBAction)searchPlace:(id)sender;
@end
