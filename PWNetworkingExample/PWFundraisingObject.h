//
//  PWFundraisingObject.h
//  PWNetworkingExample
//
//  Created by Patrick Wiseman on 3/25/16.
//  Copyright © 2016 Patrick Wiseman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWFundraisingObject : NSObject

@property (strong, nonatomic) NSString *fundraiserName;
@property (strong, nonatomic) NSString *fundraisingStatus;
@property (strong, nonatomic) NSNumber *fundedAmount;
@property (strong, nonatomic) NSNumber *numberOfLenders;

-(instancetype)initWithFundraiserName:(NSString *)theName
                    fundraisingStatus:(NSString *)theStatus
                         fundedAmount:(NSNumber *)AnAmount
                      numberOfLenders:(NSNumber *)Anumber;

@end
