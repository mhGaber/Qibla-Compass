//
//  ViewController.m
//  Qibla
//
//  Created by mhGaber on 10/3/13.
//  Copyright (c) 2013 mhGaber. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize needle,compass,locationManager;
CLLocationCoordinate2D  currentLocation;
CLLocationDirection     currentHeading;
CLLocationDirection     cityHeading;
#define toRad(X) (X*M_PI/180.0)
#define toDeg(X) (X*180.0/M_PI)
#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

- (void)viewDidLoad
{
    [super viewDidLoad];
	currentHeading=0.0;
    


    
    //  isArabic=[starter isArabic];
    
  
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    
    if([CLLocationManager locationServicesEnabled]){
        [locationManager startUpdatingLocation];
    }
    [locationManager startUpdatingHeading];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    currentLocation = newLocation.coordinate;
    
    [self updateHeadingDisplays];
}
- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading{
  	float oldRad =  -manager.heading.trueHeading * M_PI / 180.0f;
	float newRad =  -newHeading.trueHeading * M_PI / 180.0f;
	CABasicAnimation *theAnimation;
	theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	theAnimation.fromValue = [NSNumber numberWithFloat:oldRad];
	theAnimation.toValue=[NSNumber numberWithFloat:newRad];
	theAnimation.duration = 0.5f;
	[compass.layer addAnimation:theAnimation forKey:@"animateMyRotation"];
	compass.transform = CGAffineTransformMakeRotation(newRad);
	NSLog(@"%f (%f) => %f (%f)", manager.heading.trueHeading, oldRad, newHeading.trueHeading, newRad);
    // if (newHeading.headingAccuracy < 0)
    //    return;
    
    // Use the true heading if it is valid.
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ?
                                       newHeading.trueHeading : newHeading.magneticHeading);
    
    
    cityHeading = [self directionFrom:currentLocation ];
    
    
    currentHeading = theHeading;

    [self updateHeadingDisplays];
    
    
    
}
- (void)updateHeadingDisplays {
    // Animate Compass
    
    
    [UIView     animateWithDuration:0.6
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             CGAffineTransform headingRotation = CGAffineTransformRotate(CGAffineTransformIdentity, (CGFloat)toRad(cityHeading)-toRad(currentHeading));
                             
                             needle.transform = headingRotation;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    
    
    
}

-(CLLocationDirection) directionFrom: (CLLocationCoordinate2D) startPt  {
    
    double lat1 = toRad(startPt.latitude);
    double lat2 = toRad(21.4266700 );
    double lon1 = toRad(startPt.longitude);
    double lon2 = toRad(39.8261100);
    double dLon = (lon2-lon1);
    
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double brng = toDeg(atan2(y, x));
    
    brng = (brng+360);
    brng = (brng>360)? (brng-360) : brng;
    
    return brng;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
