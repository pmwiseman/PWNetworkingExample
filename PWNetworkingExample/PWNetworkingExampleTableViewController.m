//
//  PWNetworkingExampleTableViewController.m
//  PWNetworkingExample
//
//  Created by Patrick Wiseman on 3/25/16.
//  Copyright © 2016 Patrick Wiseman. All rights reserved.
//

#import "PWNetworkingExampleTableViewController.h"
#import "PWNetworkingExampleTableViewCell.h"
#import "PWFundraisingObject.h"
#import "PWNetworkingExampleDetailViewController.h"


@interface PWNetworkingExampleTableViewController ()

//UI Elements
@property (strong, nonatomic) PWNetworkingExampleTableViewCell *cell;
@property (strong, nonatomic) UIActivityIndicatorView *initialActivityIndicator;
//Data
@property (strong, nonatomic) PWFundraisingObject *fundraisingObject;
@property (strong, nonatomic) NSArray *fundraisingList;
//Networking
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionConfiguration *sessionConfiguration;

@end

//View Constants
static int const navigationBarPlusStatusBarHeight = 64;
//Table View Configurations
static NSString * const cellIdentifier = @"fundraisingCell";

@implementation PWNetworkingExampleTableViewController

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fundraisingList = [[NSArray alloc] init];
    [self setupNavigationBar];
    [self setupTableView];
    [self startInitialLoadIndicator];
    [self sessionConfig];
    [self fetchFundraisingData];
}

#pragma mark - View Setup

//Setup table view
-(void)setupTableView
{
    int tableViewX = 0;
    int tableViewY = 0;
    int tableViewWidth = self.view.frame.size.width;
    int tableViewHeight = self.view.frame.size.height;
    CGRect tableViewFrame = CGRectMake(tableViewX,
                                       tableViewY,
                                       tableViewWidth,
                                       tableViewHeight);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[PWNetworkingExampleTableViewCell class]
           forCellReuseIdentifier:cellIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //Refresh Control
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    //self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(fetchFundraisingData)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

-(void)setupNavigationBar
{
    self.navigationItem.title = @"Fundraising Data";
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
}

-(void)startInitialLoadIndicator
{
    self.initialActivityIndicator =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect initialActivityIndicatorFrame = self.tableView.frame;
    initialActivityIndicatorFrame.origin.y =
    initialActivityIndicatorFrame.origin.y - navigationBarPlusStatusBarHeight;
    self.initialActivityIndicator.frame = self.tableView.frame;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.initialActivityIndicator];
    [self.view bringSubviewToFront:self.initialActivityIndicator];
    [self.initialActivityIndicator startAnimating];
}

#pragma mark - UITableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    return [self.fundraisingList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.fundraisingObject = [self.fundraisingList objectAtIndex:indexPath.row];
    self.cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                     forIndexPath:indexPath];
    self.cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //Set UI Elements of cell
    self.cell.fundraiserNameLabel.text = self.fundraisingObject.fundraiserName;
    if([self.fundraisingObject.fundraisingStatus isEqualToString:@"fundraising"]){
        [self.cell.fundraisingStatusLabel setTextColor:[UIColor greenColor]];
    } else {
        [self.cell.fundraisingStatusLabel setTextColor:[UIColor orangeColor]];
    }
    self.cell.fundraisingStatusLabel.text = self.fundraisingObject.fundraisingStatus;
    NSString *fundraisedAmountString =
    [NSString stringWithFormat:@"Funded Amount: %@", self.fundraisingObject.fundedAmount];
    self.cell.fundedAmountLabel.text = fundraisedAmountString;
    NSString *numberOfLendersString =
    [NSString stringWithFormat:@"Lenders: %@", self.fundraisingObject.numberOfLenders];
    self.cell.numberOfLendersLabel.text = numberOfLendersString;
    
    return self.cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PWFundraisingObject *selectedFundraisingObject =
    [self.fundraisingList objectAtIndex:indexPath.row];
    //Detail View Controller
    PWNetworkingExampleDetailViewController *detailViewController =
    [[PWNetworkingExampleDetailViewController alloc] init];
    detailViewController.view.backgroundColor = [UIColor whiteColor];
    detailViewController.recievedFundraisingObject = selectedFundraisingObject;
    NSLog(@"PASSED OBJECT: %@", detailViewController.recievedFundraisingObject.fundraisingStatus);
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

#pragma mark - Network Setup

-(void)sessionConfig
{
    self.sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [self.sessionConfiguration setHTTPAdditionalHeaders:@{@"Accept": @"application/json"}];
    self.sessionConfiguration.timeoutIntervalForRequest = 30.0f;
}

-(void)fetchFundraisingData
{
    NSString *fundraisingDataUrl = @"http://api.kivaws.org/v1/loans/search.json?status=fundraising";
    if(!self.session){
        self.session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration
                                                     delegate:self
                                                delegateQueue:nil];
    }
    //Download the data
    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithURL:[NSURL URLWithString:fundraisingDataUrl]
                completionHandler:^(NSData * _Nullable data,
                                    NSURLResponse * _Nullable response,
                                    NSError * _Nullable error) {
                    if(!error){
                        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
                        if(urlResponse.statusCode == 200){
                            NSError *jsonError;
                            NSDictionary *responseObject =
                            [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingAllowFragments
                                                              error:&error];
                            NSLog(@"RESPONSE OBJECT: %@", responseObject);
                            
                            NSMutableArray *fundraisingObjectsCollected = [[NSMutableArray alloc] init];
                            if(!jsonError){
                                NSArray *loansArrayContents = responseObject[@"loans"];
                                for(NSDictionary *dictionary in loansArrayContents){
                                    PWFundraisingObject *fundraisingObject =
                                    [[PWFundraisingObject alloc] initWithFundraiserName:dictionary[@"name"]
                                                                      fundraisingStatus:dictionary[@"status"]
                                                                           fundedAmount:dictionary[@"funded_amount"]
                                                                        numberOfLenders:dictionary[@"lender_count"]];
                                    [fundraisingObjectsCollected addObject:fundraisingObject];
                                }
                                
                                self.fundraisingList = fundraisingObjectsCollected;
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                    if([self.refreshControl isRefreshing]){
                                        [self.refreshControl endRefreshing];
                                    } else {
                                        if([self.initialActivityIndicator isDescendantOfView:self.view]){
                                            [self.initialActivityIndicator stopAnimating];
                                            [self.initialActivityIndicator removeFromSuperview];
                                            self.tableView.separatorStyle =
                                            UITableViewCellSeparatorStyleSingleLine;
                                        }
                                    }
                                    [self.tableView reloadData];
                                });
                            }
                        }
                    }
                }];
    
    [dataTask resume];
}

@end
