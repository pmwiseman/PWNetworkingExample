//
//  PWFundraisingObject.m
//  PWNetworkingExample
//
//  Created by Patrick Wiseman on 3/25/16.
//  Copyright © 2016 Patrick Wiseman. All rights reserved.
//

#import "PWFundraisingObject.h"

@implementation PWFundraisingObject

-(instancetype)init
{
    return self;
}

-(instancetype)initWithFundraiserName:(NSString *)theName
                    fundraisingStatus:(NSString *)theStatus
                         fundedAmount:(NSNumber *)anAmount
                      numberOfLenders:(NSNumber *)aNumber
{
    self = [super init];
    if(self){
        self.fundraiserName = theName;
        self.fundraisingStatus = theStatus;
        self.fundedAmount = anAmount;
        self.numberOfLenders = aNumber;
    }
    
    return self;
}

@end
