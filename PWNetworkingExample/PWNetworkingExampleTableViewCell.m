//
//  PWNetworkingExampleTableViewCell.m
//  PWNetworkingExample
//
//  Created by Patrick Wiseman on 3/25/16.
//  Copyright © 2016 Patrick Wiseman. All rights reserved.
//

#import "PWNetworkingExampleTableViewCell.h"

@implementation PWNetworkingExampleTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if(self){
        //Fundraiser Label
        int fundraiserNameLabelX = 8;
        int fundraiserNameLabelY = 8;
        int fundraiserNameLabelWidth = 200;
        int fundraiserNameLabelHeight = 31;
        CGRect fundraiserNameLabelFrame = CGRectMake(fundraiserNameLabelX,
                                              fundraiserNameLabelY,
                                              fundraiserNameLabelWidth,
                                              fundraiserNameLabelHeight);
        self.fundraiserNameLabel = [[UILabel alloc] initWithFrame:fundraiserNameLabelFrame];
        [self addSubview:self.fundraiserNameLabel];
        //Funded Amout Label
        int fundedAmountLabelWidth = 150;
        int fundedAmountLabelX = 8;
        int fundedAmountLabelHeight = 21;
        int fundedAmountLabelY = fundraiserNameLabelY + fundraiserNameLabelHeight + 2;
        CGRect fundedAmountLabelFrame = CGRectMake(fundedAmountLabelX,
                                                   fundedAmountLabelY,
                                                   fundedAmountLabelWidth,
                                                   fundedAmountLabelHeight);
        self.fundedAmountLabel = [[UILabel alloc] initWithFrame:fundedAmountLabelFrame];
        self.fundedAmountLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:self.fundedAmountLabel];
        //Fundraising Status Label
//        int fundraisingStatusLabelWidth = 150;
//        int fundraisingStatusLabelX = [[UIScreen mainScreen] bounds].size.width
//        - fundraisingStatusLabelWidth - 8;
//        int fundraisingStatusLabelY = fundraiserNameLabelY;
//        int fundraisingStatusLabelHeight = 21;
//        CGRect fundraisingStatusLabelFrame = CGRectMake(fundraisingStatusLabelX,
//                                                        fundraisingStatusLabelY,
//                                                        fundraisingStatusLabelWidth,
//                                                        fundraisingStatusLabelHeight);
//        self.fundraisingStatusLabel = [[UILabel alloc] initWithFrame:fundraisingStatusLabelFrame];
//        self.fundraisingStatusLabel.font = [UIFont systemFontOfSize:14.0];
//        self.fundraisingStatusLabel.textAlignment = NSTextAlignmentRight;
//        [self addSubview:self.fundraisingStatusLabel];
        //Number of Lenders Label
//        int numberOfLendersLabelX = fundraisingStatusLabelX;
//        int numberOfLendersLabelY = fundedAmountLabelY;
//        int numberOfLendersLabelWidth = 150;
//        int numberOfLendersLabelHeight = 21;
//        CGRect numberOfLendersLabelFrame = CGRectMake(numberOfLendersLabelX,
//                                                      numberOfLendersLabelY,
//                                                      numberOfLendersLabelWidth,
//                                                      numberOfLendersLabelHeight);
//        self.numberOfLendersLabel = [[UILabel alloc] initWithFrame:numberOfLendersLabelFrame];
//        self.numberOfLendersLabel.textAlignment = NSTextAlignmentRight;
//        self.numberOfLendersLabel.font = [UIFont systemFontOfSize:14.0];
//        [self addSubview:self.numberOfLendersLabel];
    }
    
    return self;
}

@end
