//
//  ITLeftRightSidePanelViewController.m
//  PoC-LeftRightSidePanel
//
//  Created by Vincent Saluzzo on 16/05/13.
//  Copyright (c) 2013 Itelios. All rights reserved.
//

#import "ITSwippedPanel.h"
#import "UIViewController+ITSwippedPanel.h"

@interface ITSwippedPanel ()

@property (nonatomic, retain) UISwipeGestureRecognizer* leftSwipeGestureRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer* rightSwipeGestureRecognizer;
@property (nonatomic, retain) UITapGestureRecognizer* leftTapGestureRecognizer;
@property (nonatomic, retain) UITapGestureRecognizer* rightTapGestureRecognizer;

-(void) callSelectorOnDelegates:(SEL)selector;


-(void) handleSwipe:(UIGestureRecognizer*)gestureRecognizer;
-(void) handleTap:(UIGestureRecognizer*)gestureRecognizer;

@end

@implementation ITSwippedPanel

-(id) initWithRootViewController:(UIViewController *)rootViewController {
    self = [super init];
    if(self) {
        
        _delegates = [NSMutableArray array];
        
        self.rightSideWidth = self.leftSideWidth = DEFAULT_PANEL_WIDTH;
        self.animationTime = DEFAULT_ANIMATION_TIME;
        
        self.leftHoverIndicatorPosition = self.rightHoverIndicatorPosition = ITLeftRightSidePanelIndicatorPositionMiddle;
        
        self.mainViewController = rootViewController;
        self.mainViewController.rootSidePanel = self;
        
        self.handleSwipeGesture = self.handleSwipeGestureLeftPanel = self.handleSwipeGestureRightPanel = YES;
        
        [self addChildViewController:self.mainViewController];
        [self.mainViewController removeFromParentViewController];
        [self.view addSubview:self.mainViewController.view];
        
        self.mainViewController.view.frame = self.view.bounds;
        
        self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        self.leftSwipeGestureRecognizer.numberOfTouchesRequired = self.rightSwipeGestureRecognizer.numberOfTouchesRequired = 2;
        self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        
        self.leftTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        self.rightTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        
        self.leftTapGestureRecognizer.numberOfTouchesRequired = self.rightTapGestureRecognizer.numberOfTouchesRequired = 1;
        self.leftTapGestureRecognizer.numberOfTapsRequired = self.rightTapGestureRecognizer.numberOfTapsRequired = 1;
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(self.leftHoverIndicator && self.leftSideViewController) {
        
        [self.leftHoverIndicator removeFromSuperview];
        
        CGSize leftHoverSize = self.leftHoverIndicator.bounds.size;
        
        CGFloat originY;
        if(self.leftHoverIndicatorPosition == ITLeftRightSidePanelIndicatorPositionBottom) {
            originY = self.view.bounds.size.height - leftHoverSize.height;
        } else if(self.leftHoverIndicatorPosition == ITLeftRightSidePanelIndicatorPositionMiddle) {
            originY = self.view.bounds.size.height/2.0f - leftHoverSize.height/2.0f;
        } else {
            originY = self.view.bounds.origin.y;
        }
        
        CGPoint origin = CGPointMake(0.0f, originY);
        
        CGRect beginFrame = CGRectMake(origin.x - leftHoverSize.width, origin.y, leftHoverSize.width, leftHoverSize.height);
        CGRect finishFrame = CGRectMake(origin.x, origin.y, leftHoverSize.width, leftHoverSize.height);
        
        self.leftHoverIndicator.frame = beginFrame;
        
        [self.view addSubview:self.leftHoverIndicator];
        
        [UIView animateWithDuration:self.animationTime animations:^() {
            self.leftHoverIndicator.frame = finishFrame;
        }];
        
        [self.leftHoverIndicator addGestureRecognizer:self.leftTapGestureRecognizer];
    }
    
    if(self.rightHoverIndicator && self.rightSideViewController) {
        [self.rightHoverIndicator removeFromSuperview];
        
        CGSize rightHoverSize = self.rightHoverIndicator.bounds.size;
        
        CGFloat originY;
        if(self.rightHoverIndicatorPosition == ITLeftRightSidePanelIndicatorPositionBottom) {
            originY = self.view.bounds.size.height - rightHoverSize.height;
        } else if(self.rightHoverIndicatorPosition == ITLeftRightSidePanelIndicatorPositionMiddle) {
            originY = self.view.bounds.size.height/2.0f - rightHoverSize.height/2.0f;
        } else {
            originY = self.view.bounds.origin.y;
        }
        
        CGPoint origin = CGPointMake(self.view.bounds.size.width - rightHoverSize.width, originY);
        
        CGRect beginFrame = CGRectMake(origin.x + rightHoverSize.width, origin.y, rightHoverSize.width, rightHoverSize.height);
        CGRect finishFrame = CGRectMake(origin.x, origin.y, rightHoverSize.width, rightHoverSize.height);
        
        self.rightHoverIndicator.frame = beginFrame;
        
        [self.view addSubview:self.rightHoverIndicator];
        
        [UIView animateWithDuration:self.animationTime animations:^() {
            self.rightHoverIndicator.frame = finishFrame;
        }];
        
        [self.rightHoverIndicator addGestureRecognizer:self.rightTapGestureRecognizer];
    }
    
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
}

-(void) setLeftSideViewController:(UIViewController *)leftSideViewController {
    if(self.leftSideViewController) {
        self.leftSideViewController.rootSidePanel = nil;
    }
    
    self->_leftSideViewController = leftSideViewController;
    leftSideViewController.rootSidePanel = self;
}

-(void) setRightSideViewController:(UIViewController *)rightSideViewController {
    if(self.leftSideViewController) {
        self.rightSideViewController.rootSidePanel = nil;
    }
    
    self->_rightSideViewController = rightSideViewController;
    rightSideViewController.rootSidePanel = self;
}

-(void) showLeftSideViewController {
    if(self.leftSideViewController) {
        if([self rightSizeIsVisible]) {
            [self hideRightSideViewController];
        }
        
        [self callSelectorOnDelegates:@selector(leftRightSidePanelwillShowLeftPanel:)];
        
        CGRect leftFrame = CGRectMake(-self.leftSideWidth, 0, self.leftSideWidth, self.view.bounds.size.height);

        self.leftSideViewController.view.frame = leftFrame;
        [self addChildViewController:self.leftSideViewController];
        [self.view addSubview:self.leftSideViewController.view];
        
        [UIView animateWithDuration:self.animationTime animations:^() {
            CGRect rootFrame = self.mainViewController.view.frame;
            rootFrame.origin.x = self.leftSideWidth;
            self.mainViewController.view.frame = rootFrame;
            
            CGRect newLeftFrame = leftFrame;
            newLeftFrame.origin.x = 0.0f;
            
            self.leftSideViewController.view.frame = newLeftFrame;
            
            if(self.leftHoverIndicator) {
                CGRect leftHoverFrame = self.leftHoverIndicator.frame;
                leftHoverFrame.origin.x = leftHoverFrame.origin.x + self.leftSideWidth;
                self.leftHoverIndicator.frame = leftHoverFrame;
            }
            
            if(self.rightHoverIndicator) {
                CGRect rightHoverFrame = self.rightHoverIndicator.frame;
                rightHoverFrame.origin.x = rightHoverFrame.origin.x + self.leftSideWidth;
                self.rightHoverIndicator.frame = rightHoverFrame;
            }
            
        } completion:^(BOOL finished) {
            [self callSelectorOnDelegates:@selector(leftRightSidePaneldidShowLeftPanel:)];
        }];
    }
}

-(void) showRightSideViewController {
    if(self.rightSideViewController) {
        if([self leftSizeIsVisible]) {
            [self hideLeftSideViewController];
        }
        
        [self callSelectorOnDelegates:@selector(leftRightSidePanelwillShowRightPanel:)];
        
        CGRect rightFrame = CGRectMake(self.view.bounds.size.width, 0, self.rightSideWidth, self.view.bounds.size.width);
        
        self.rightSideViewController.view.frame = rightFrame;
        [self addChildViewController:self.rightSideViewController];
        [self.view addSubview:self.rightSideViewController.view];
        
        [UIView animateWithDuration:self.animationTime animations:^() {
            CGRect rootFrame = self.mainViewController.view.frame;
            rootFrame.origin.x = -self.rightSideWidth;
            self.mainViewController.view.frame = rootFrame;
            
            CGRect newRightFrame = rightFrame;
            newRightFrame.origin.x = self.view.bounds.size.width-self.rightSideWidth;
            self.rightSideViewController.view.frame = newRightFrame;
            
            if(self.leftHoverIndicator) {
                CGRect leftHoverFrame = self.leftHoverIndicator.frame;
                leftHoverFrame.origin.x = leftHoverFrame.origin.x - self.rightSideWidth;
                self.leftHoverIndicator.frame = leftHoverFrame;
            }
            
            if(self.rightHoverIndicator) {
                CGRect rightHoverFrame = self.rightHoverIndicator.frame;
                rightHoverFrame.origin.x = rightHoverFrame.origin.x - self.rightSideWidth;
                self.rightHoverIndicator.frame = rightHoverFrame;
            }
            
        } completion:^(BOOL finished) {
            [self callSelectorOnDelegates:@selector(leftRightSidePaneldidShowRightPanel:)];
        }];
    }
}

-(void) hideLeftSideViewController {
    if(self.leftSideViewController) {
        
        [self callSelectorOnDelegates:@selector(leftRightSidePanelwillHideLeftPanel:)];
        
        CGRect leftFrame = self.leftSideViewController.view.frame;
        leftFrame.origin.x = -self.leftSideWidth;
        
        [UIView animateWithDuration:self.animationTime animations:^() {
            
            self.mainViewController.view.frame = self.view.bounds;
            self.leftSideViewController.view.frame = leftFrame;
            
            if(self.leftHoverIndicator) {
                CGRect leftHoverFrame = self.leftHoverIndicator.frame;
                leftHoverFrame.origin.x = leftHoverFrame.origin.x - self.leftSideWidth;
                self.leftHoverIndicator.frame = leftHoverFrame;
            }
            
            if(self.rightHoverIndicator) {
                CGRect rightHoverFrame = self.rightHoverIndicator.frame;
                rightHoverFrame.origin.x = rightHoverFrame.origin.x - self.leftSideWidth;
                self.rightHoverIndicator.frame = rightHoverFrame;
            }
            
        } completion:^(BOOL finished) {
            
            [self.leftSideViewController.view removeFromSuperview];
            [self.leftSideViewController removeFromParentViewController];
            
            [self callSelectorOnDelegates:@selector(leftRightSidePaneldidHideLeftPanel:)];
            
        }];
        
    }
}

-(void) hideRightSideViewController {
    if(self.rightSideViewController) {
        
        [self callSelectorOnDelegates:@selector(leftRightSidePanelwillHideRightPanel:)];
        
        CGRect rightFrame = self.rightSideViewController.view.frame;
        rightFrame.origin.x = self.view.bounds.size.width;
        
        [UIView animateWithDuration:self.animationTime animations:^() {
            
            self.mainViewController.view.frame = self.view.bounds;
            self.rightSideViewController.view.frame = rightFrame;
            
            if(self.leftHoverIndicator) {
                CGRect leftHoverFrame = self.leftHoverIndicator.frame;
                leftHoverFrame.origin.x = leftHoverFrame.origin.x + self.rightSideWidth;
                self.leftHoverIndicator.frame = leftHoverFrame;
            }
            
            if(self.rightHoverIndicator) {
                CGRect rightHoverFrame = self.rightHoverIndicator.frame;
                rightHoverFrame.origin.x = rightHoverFrame.origin.x + self.rightSideWidth;
                self.rightHoverIndicator.frame = rightHoverFrame;
            }
            
        } completion:^(BOOL finished) {
            
            [self.rightSideViewController.view removeFromSuperview];
            [self.rightSideViewController removeFromParentViewController];
            
            [self callSelectorOnDelegates:@selector(leftRightSidePaneldidHideRightPanel:)];
            
        }];
    }
}



-(BOOL) leftSizeIsVisible {
    if(self.leftSideViewController) {
        if([self.leftSideViewController parentViewController]) {
            if([self.view.subviews containsObject:self.leftSideViewController.view]) {
                return YES;
            } else {
                return NO;
            }
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

-(BOOL) rightSizeIsVisible {
    if(self.rightSideViewController) {
        if([self.rightSideViewController parentViewController]) {
            if([self.view.subviews containsObject:self.rightSideViewController.view]) {
                return YES;
            } else {
                return NO;
            }
        } else {
            return NO;
        }
    } else {
        return NO;
    }

}



#pragma mark - Private methods
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

-(void) callSelectorOnDelegates:(SEL)selector {
    for (id delegate in self.delegates) {
        if(delegate && [delegate respondsToSelector:selector]) {
            [delegate performSelector:selector withObject:self];
        }
    }
}


-(void) handleSwipe:(UIGestureRecognizer*)gestureRecognizer {
    if(self.handleSwipeGesture) {
        if(((UISwipeGestureRecognizer*)gestureRecognizer).direction == UISwipeGestureRecognizerDirectionLeft ) {
            // right
            if([self leftSizeIsVisible]) {
                if(self.handleSwipeGestureLeftPanel) [self hideLeftSideViewController];
            } else {
                if(![self rightSizeIsVisible]) {
                    if(self.handleSwipeGestureRightPanel) [self showRightSideViewController];
                }
            }
        } else if( ((UISwipeGestureRecognizer*)gestureRecognizer).direction == UISwipeGestureRecognizerDirectionRight ) {
            // left
            if([self rightSizeIsVisible]) {
                if(self.handleSwipeGestureRightPanel) [self hideRightSideViewController];
            } else {
                if(![self leftSizeIsVisible]) {
                    if(self.handleSwipeGestureLeftPanel) [self showLeftSideViewController];
                }
            }
        }
    }
}

-(void) handleTap:(UIGestureRecognizer*)gestureRecognizer {
    if( ((UITapGestureRecognizer*)gestureRecognizer).state == UIGestureRecognizerStateEnded ) {
        if(gestureRecognizer == self.leftTapGestureRecognizer) {
            if([self leftSizeIsVisible]) {
                [self hideLeftSideViewController];
            } else {
                [self showLeftSideViewController];
            }
        } else if(gestureRecognizer == self.rightTapGestureRecognizer) {
            if([self rightSizeIsVisible]) {
                [self hideRightSideViewController];
            } else {
                [self showRightSideViewController];
            }
        }
    }
}

@end
