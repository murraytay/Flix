//
//  MovieCell.m
//  Flix
//
//  Created by Taylor Murray on 6/27/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void) setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    CGFloat fontSize = selected ? 29.0 : 21.0;
    self.titleLabel.font = [self.titleLabel.font fontWithSize:fontSize];
}
@end
