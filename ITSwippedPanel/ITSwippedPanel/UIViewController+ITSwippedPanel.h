//
//  UIViewController+ITLeftRightSidePanel.h
//  PoC-LeftRightSidePanel
//
//  Created by Vincent Saluzzo on 16/05/13.
//  Copyright (c) 2013 Itelios. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ITSwippedPanel.h"

@interface UIViewController (ITSwippedPanel)

@property (nonatomic, retain) ITSwippedPanel* rootSidePanel;

@end
