//
//  ViewController.h
//  Qibla
//
//  Created by mhGaber on 10/3/13.
//  Copyright (c) 2013 mhGaber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *needle;
@property (strong, nonatomic) IBOutlet UIImageView *compass;
@property(strong,nonatomic) CLLocationManager *locationManager;

@end
