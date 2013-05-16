//
//  ITAppDelegate.h
//  PoC-LeftRightSidePanel
//
//  Created by Vincent Saluzzo on 16/05/13.
//  Copyright (c) 2013 Itelios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ITSwippedPanel;
@class ITViewController;

@interface ITAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ITViewController *viewController;

@property (nonatomic, retain) UIViewController* leftSidePanel;
@property (nonatomic, retain) UIViewController* rightSidePanel;

@property (nonatomic, retain) ITSwippedPanel* rootSidePanel;
@end
