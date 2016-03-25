//
//  PWNetworkingExampleDetailViewController.m
//  PWNetworkingExample
//
//  Created by Patrick Wiseman on 3/25/16.
//  Copyright © 2016 Patrick Wiseman. All rights reserved.
//

#import "PWNetworkingExampleDetailViewController.h"

@interface PWNetworkingExampleDetailViewController ()

@end

static int const navigationBarPlusStatusBarHeight = 64;

@implementation PWNetworkingExampleDetailViewController

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupView];
}

#pragma mark - Setup Navigation

-(void)setupNavigation
{
    self.navigationItem.title = @"Details";
}

#pragma mark - Setup View

-(void)setupView
{
    //Name Title Label
    int nameLabelWidth = 200;
    int nameLabelHeight = 40;
    int nameLabelY = navigationBarPlusStatusBarHeight + 10;
    int nameLabelX = (self.view.frame.size.width - nameLabelWidth)/2;
    CGRect nameLabelFrame = CGRectMake(nameLabelX,
                                       nameLabelY,
                                       nameLabelWidth,
                                       nameLabelHeight);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameLabelFrame];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:24.0];
    nameLabel.text = self.recievedFundraisingObject.fundraiserName;
    [self.view addSubview:nameLabel];
    //Status Label
    int statusLabelWidth = 150;
    int statusLabelHeight = 21;
    int statusLabelX = (self.view.frame.size.width - statusLabelWidth)/2;
    int statusLabelY = nameLabelY + nameLabelHeight + 10;
    CGRect statusLabelFrame = CGRectMake(statusLabelX,
                                         statusLabelY,
                                         statusLabelWidth,
                                         statusLabelHeight);
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:statusLabelFrame];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.text = [NSString stringWithFormat:@"status: %@",
                        self.recievedFundraisingObject.fundraisingStatus];
    [self.view addSubview:statusLabel];
}

@end
