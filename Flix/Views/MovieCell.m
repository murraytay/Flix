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
- (IBAction)favoriteButton:(UIButton *)sender {
    
    
    NSMutableArray *oldFavMovies = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"10"] mutableCopy];
    if(oldFavMovies != nil){
        [oldFavMovies addObject:self.movie];
        
        [[NSUserDefaults standardUserDefaults] setObject:oldFavMovies forKey:@"10"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"Movie was added");
    } else{
        NSMutableArray *noFavMoviesYet = [NSMutableArray arrayWithObject:self.movie];
        [[NSUserDefaults standardUserDefaults] setObject:noFavMoviesYet forKey:@"10"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"Movie was added");
    }

    
    
}
@end
