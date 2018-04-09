//
//  AppDelegate.h
//  PC
//
//  Created by Kelly Brown on 2018-04-04.
//  Copyright © 2018 Kelly Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) ViewController *mainViewController;

@end

