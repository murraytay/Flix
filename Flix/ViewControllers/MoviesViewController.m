//
//  MoviesViewController.m
//  Flix
//
//  Created by Taylor Murray on 6/27/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import <UIImageView+AFNetworking.h>
#import "DetailViewController.h"
@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong,nonatomic) NSArray *filteredData;
@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
}

-(void) viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}
- (void)fetchMovies{
    // Start the activity indicator
    [self.activityIndicator startAnimating];
    // Do any additional setup after loading the view.
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies"
                                                                           message:@"Unable to connect to Network"
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            
            // create a cancel action
            UIAlertAction *tryAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     // handle cancel response here. Doing nothing will dismiss the view.
                                                                 }];
            // add the cancel action to the alertController
            [alert addAction:tryAction];
            [self presentViewController:alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
            [self fetchMovies];
            
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"%@", dataDictionary);
            // TODO: Get the array of movies
            // TODO: Store the movies in a property to use elsewhere
            // TODO: Reload your table view data
            self.movies = dataDictionary[@"results"];
            //changed for search view
            self.filteredData = self.movies;
            [self.activityIndicator stopAnimating];
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
    
    [task resume];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //changed this for search bar
    return self.filteredData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //GENERIC VERSION
    //UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    //change for search bar from self.movies to filternedData
    NSDictionary *movie = self.filteredData[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    cell.movie = movie;
    
//    [self.favoriteMoviesArray addObject:movie];
//    

    NSMutableArray *oldFavMovies = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"MovieFavorites"] mutableCopy];
    BOOL inFavorites = NO;
    for(NSDictionary* oldMovie in oldFavMovies){
        if([oldMovie[@"title"] isEqualToString:movie[@"title"]]){
            inFavorites = YES;
        }
    }
    if(inFavorites){
        [cell.favoriteButton setImage:[UIImage imageNamed:@"projector_tabbar_item.png"] forState:UIControlStateNormal];
    } else{
        [cell.favoriteButton setImage:[UIImage imageNamed:@"ticket_tabbar_icon.png"] forState:UIControlStateNormal];
    }
    
//    cell.favoriteButton.tag = indexPath;


    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    
    //FOR FADING IN
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
    //use for not fading in
    //[cell.posterView setImageWithURL:posterURL];
    
    
   // cell.textLabel.text = movie[@"title"];
    return cell;
}

//SEARCH BAR STUFF
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length != 0){
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject[@"title"] containsString:searchText];
        }];
        self.filteredData = [self.movies filteredArrayUsingPredicate:predicate];
    } else{
        self.filteredData = self.movies;
    }
    [self.tableView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *tappedMovie = self.movies[indexPath.row];
    DetailViewController *detailViewController = [segue destinationViewController];
    detailViewController.movie = tappedMovie;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.searchBar.showsCancelButton = YES;
}
- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchBar.showsCancelButton = NO;
    [UIView animateWithDuration:.7 animations:^{
        [self.searchBar resignFirstResponder];
    }];
}

@end
