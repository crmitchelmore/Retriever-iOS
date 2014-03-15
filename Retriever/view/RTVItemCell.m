//
//  RTVItemCell.m
//  Retriever
//
//  Created by Chris Mitchelmore on 15/03/2014.
//  Copyright (c) 2014 Retriever Company. All rights reserved.
//

#import "RTVItemCell.h"
//Model
#import "RTVItem.h"
@interface RTVItemCell ()
@property (weak, nonatomic) IBOutlet UILabel *displayName;

@end
@implementation RTVItemCell

- (void)setItem:(RTVItem *)item
{
    _item = item;
    self.displayName.text = item.displayName;
}

@end
