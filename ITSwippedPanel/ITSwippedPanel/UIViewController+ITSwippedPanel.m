//
//  UIViewController+ITLeftRightSidePanel.m
//  PoC-LeftRightSidePanel
//
//  Created by Vincent Saluzzo on 16/05/13.
//  Copyright (c) 2013 Itelios. All rights reserved.
//

#import "UIViewController+ITSwippedPanel.h"
#import <objc/runtime.h>

static char RootSidePanelResultKey;
//static void *RootSidePanelResultKey;

@implementation UIViewController (ITSwippedPanel)



-(void) setRootSidePanel:(ITSwippedPanel *)rootSidePanel {
    objc_setAssociatedObject(self, &RootSidePanelResultKey, rootSidePanel, OBJC_ASSOCIATION_RETAIN);
}

-(ITSwippedPanel*) rootSidePanel {
    ITSwippedPanel *result = objc_getAssociatedObject(self, &RootSidePanelResultKey);
    return result;
}

@end
