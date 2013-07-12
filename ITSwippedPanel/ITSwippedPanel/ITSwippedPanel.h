//
//  ITLeftRightSidePanelViewController.h
//  PoC-LeftRightSidePanel
//
//  Created by Vincent Saluzzo on 16/05/13.
//  Copyright (c) 2013 Itelios. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULT_PANEL_WIDTH 320.0f
#define DEFAULT_ANIMATION_TIME 0.2f


typedef NS_ENUM(NSUInteger, ITLeftRightSidePanelIndicatorPosition) {
    ITLeftRightSidePanelIndicatorPositionTop,
    ITLeftRightSidePanelIndicatorPositionMiddle,
    ITLeftRightSidePanelIndicatorPositionBottom
};

@class ITSwippedPanel;

@protocol ITLeftRightSidePanelDelegate <NSObject>

@optional

-(void) leftRightSidePanelwillShowLeftPanel:(ITSwippedPanel*)rootPanel;
-(void) leftRightSidePaneldidShowLeftPanel:(ITSwippedPanel*)rootPanel;

-(void) leftRightSidePanelwillShowRightPanel:(ITSwippedPanel*)rootPanel;
-(void) leftRightSidePaneldidShowRightPanel:(ITSwippedPanel*)rootPanel;

-(void) leftRightSidePanelwillHideLeftPanel:(ITSwippedPanel*)rootPanel;
-(void) leftRightSidePaneldidHideLeftPanel:(ITSwippedPanel*)rootPanel;

-(void) leftRightSidePanelwillHideRightPanel:(ITSwippedPanel*)rootPanel;
-(void) leftRightSidePaneldidHideRightPanel:(ITSwippedPanel*)rootPanel;

@end

@interface ITSwippedPanel : UIViewController

@property (nonatomic, retain) UIView* leftHoverIndicator;
@property (nonatomic, assign) ITLeftRightSidePanelIndicatorPosition leftHoverIndicatorPosition;

@property (nonatomic, retain) UIView* rightHoverIndicator;
@property (nonatomic, assign) ITLeftRightSidePanelIndicatorPosition rightHoverIndicatorPosition;

@property (nonatomic, retain) UIViewController* leftSideViewController;
@property (nonatomic, retain) UIViewController* rightSideViewController;
@property (nonatomic, retain) UIViewController* mainViewController;

@property (nonatomic, assign) CGFloat leftSideWidth;
@property (nonatomic, assign) CGFloat rightSideWidth;

@property (nonatomic, assign) CGFloat animationTime;

@property (nonatomic, readonly) NSMutableArray* delegates;

@property (nonatomic, assign) BOOL handleSwipeGesture;
@property (nonatomic, assign) BOOL handleSwipeGestureLeftPanel;
@property (nonatomic, assign) BOOL handleSwipeGestureRightPanel;
@property (nonatomic, assign) BOOL handleTapOnMainViewToHideSidePanel;

-(BOOL) leftSizeIsVisible;
-(BOOL) rightSizeIsVisible;

-(id) initWithRootViewController:(UIViewController*)rootViewController;

-(void) showLeftSideViewController;
-(void) showRightSideViewController;

-(void) hideLeftSideViewController;
-(void) hideRightSideViewController;


@end
