//
//  SimilarMoviesViewController.m
//  Flix
//
//  Created by Taylor Murray on 6/28/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "SimilarMoviesViewController.h"
#import "SimilarMoviesCell.h"
#import <UIImageView+AFNetworking.h>
#import "DetailViewController.h"
@interface SimilarMoviesViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *similarMovies;


@end

@implementation SimilarMoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self fetchMovies];
    
    UICollectionViewFlowLayout *layout = self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = (self.collectionView.frame.size.width - (postersPerLine-1)*layout.minimumInteritemSpacing)/postersPerLine ;
    CGFloat itemHeight = 1.5*itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)fetchMovies{
    // Do any additional setup after loading the view.
    NSNumber *selectedMovieID = self.selectedMovie[@"id"];
    NSString *selectedMovieIDString = [selectedMovieID stringValue];
    
    NSString *baseString = @"https://api.themoviedb.org/3/movie/";
    NSString *endString = @"/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1";
    NSString *fullString = [baseString stringByAppendingString:selectedMovieIDString];
    NSString *api_urlString = [fullString stringByAppendingString:endString];
    
    NSURL *url = [NSURL URLWithString:api_urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"%@", dataDictionary);
            // TODO: Get the array of movies
            // TODO: Store the movies in a property to use elsewhere
            // TODO: Reload your table view data
            self.similarMovies = dataDictionary[@"results"];
            [self.collectionView reloadData];
            
        }
        
    }];
    [task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SimilarMoviesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SimilarMoviesCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.similarMovies[indexPath.item];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    //[cell.posterView setImageWithURL:posterURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:posterURL];
    [cell.posterView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image){
        //imageResponse will be nil if the image is cached
        if(imageResponse){
            NSLog(@"Image was NOT cached, fade in image");
            cell.posterView.alpha = 0.0;
            cell.posterView.image = image;
            
            //animate UIImageView back to alpha 1 over .3 sec
            [UIView animateWithDuration:.7 animations:^{
                cell.posterView.alpha = 1.;
                
            }];
        } else{
            NSLog(@"Image was cached so just update the image");
            cell.posterView.image = image;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError * error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
    
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.similarMovies.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UICollectionViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
    NSDictionary *tappedMovie = self.similarMovies[indexPath.item];
    DetailViewController *detailViewController = [segue destinationViewController];
    detailViewController.movie = tappedMovie;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
