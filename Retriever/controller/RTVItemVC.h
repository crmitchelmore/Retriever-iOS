//
//  RTVItemVC.h
//  Retriever
//
//  Created by Chris Mitchelmore on 15/03/2014.
//  Copyright (c) 2014 Retriever Company. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RTVSearchResponse;

@interface RTVItemVC : UIViewController

@property (nonatomic, strong) RTVSearchResponse *searchResponse;

@end
