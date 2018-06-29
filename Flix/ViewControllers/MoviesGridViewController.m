//
//  MoviesGridViewController.m
//  Flix
//
//  Created by Taylor Murray on 6/28/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h"
#import <UIImageView+AFNetworking.h>
#import "DetailViewController.h"
@interface MoviesGridViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *favoriteMovies;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MoviesGridViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    //[self fetchMovies];
    
    UICollectionViewFlowLayout *layout = self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = (self.collectionView.frame.size.width - (postersPerLine-1)*layout.minimumInteritemSpacing)/postersPerLine ;
    CGFloat itemHeight = 1.5*itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    

    
}


- (void) viewWillAppear:(BOOL)animated{
    NSMutableArray *idk = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"10"] mutableCopy];
    if(idk != nil){
        self.favoriteMovies = idk;
    } else{
        self.favoriteMovies = [NSMutableArray new];
    }
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)fetchMovies{
//    // Do any additional setup after loading the view.
//    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/449176/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if (error != nil) {
//            NSLog(@"%@", [error localizedDescription]);
//        }
//        else {
//            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//
//            NSLog(@"%@", dataDictionary);
//            // TODO: Get the array of movies
//            // TODO: Store the movies in a property to use elsewhere
//            // TODO: Reload your table view data
//            self.movies = dataDictionary[@"results"];
//            [self.collectionView reloadData];
//
//        }
//
//    }];
//    [task resume];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    
    
    NSDictionary *movie = self.favoriteMovies[indexPath.item];
    
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    
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
    //[cell.posterView setImageWithURL:posterURL];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.favoriteMovies.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UICollectionViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
    NSDictionary *tappedMovie = self.favoriteMovies[indexPath.item];
    DetailViewController *detailViewController = [segue destinationViewController];
    detailViewController.movie = tappedMovie;
}


@end
