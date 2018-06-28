//
//  DetailViewController.m
//  Flix
//
//  Created by Taylor Murray on 6/27/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "DetailViewController.h"
#import <UIImageView+AFNetworking.h>
#import "TrailerViewController.h"
#import "SimilarMoviesViewController.h"
@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *smallPosterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIButton *SeeSimilarButton;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [self.smallPosterView setImageWithURL:posterURL];
    NSString *backgroundURLString = self.movie[@"backdrop_path"];
    NSString *fullBackgroundURLString = [baseURLString stringByAppendingString:backgroundURLString];
    NSURL *backgroundURL = [NSURL URLWithString:fullBackgroundURLString];
    [self.backgroundView setImageWithURL:backgroundURL];
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    self.dateLabel.text = self.movie[@"release_date"];
    [self.titleLabel sizeToFit];
    [self.dateLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    
    CGFloat maxHeight = self.synopsisLabel.frame.origin.y + self.synopsisLabel.frame.size.height;
    self.scrollView.contentSize = CGSizeMake(self.synopsisLabel.frame.size.width, maxHeight);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"similarMoviesSegue"]){
        SimilarMoviesViewController *similarMoviesController = [segue destinationViewController];
        similarMoviesController.selectedMovie = self.movie;
    } else{
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        TrailerViewController *trailerViewController = [segue destinationViewController];
        trailerViewController.movie = self.movie;
    }
}




@end
