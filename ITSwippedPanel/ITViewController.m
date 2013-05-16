//
//  ITViewController.m
//  PoC-LeftRightSidePanel
//
//  Created by Vincent Saluzzo on 16/05/13.
//  Copyright (c) 2013 Itelios. All rights reserved.
//

#import "ITViewController.h"

@interface ITViewController ()

@end

@implementation ITViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction) tapOnLeftSidePanel:(id)sender {
    if([self.rootSidePanel leftSizeIsVisible]) {
        [self.rootSidePanel hideLeftSideViewController];
    } else {
        [self.rootSidePanel showLeftSideViewController];
    }
}

-(IBAction) tapOnRightSidePanel:(id)sender {
    if([self.rootSidePanel rightSizeIsVisible]) {
        [self.rootSidePanel hideRightSideViewController];
    } else {
        [self.rootSidePanel showRightSideViewController];
    }
}


@end
