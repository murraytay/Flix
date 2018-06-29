//
//  ReviewsViewController.m
//  Flix
//
//  Created by Taylor Murray on 6/28/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "ReviewsViewController.h"
#import "ReviewsCell.h"
@interface ReviewsViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *reviewTableView;
@property (nonatomic,strong) NSArray *reviews;
@end

@implementation ReviewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.reviewTableView.dataSource = self;
    self.reviewTableView.delegate = self;
    
    [self fetchReviews];
    
    
}

- (void)fetchReviews{
    // Do any additional setup after loading the view.
    NSNumber *selectedMovieID = self.selectedMovie[@"id"];
    NSString *selectedMovieIDString = [selectedMovieID stringValue];
    
    NSString *baseString = @"https://api.themoviedb.org/3/movie/";
    NSString *endString = @"/reviews?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1";
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
            self.reviews = dataDictionary[@"results"];
            
            [self.reviewTableView reloadData];
            
        }
        
    }];
    [task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReviewsCell *reviewCell = [tableView dequeueReusableCellWithIdentifier:@"ReviewsCell"];
    NSDictionary *review = self.reviews[indexPath.row];
    
    
    reviewCell.contentLabel.text = review[@"content"];
    reviewCell.authorLabel.text = review[@"author"];
    return reviewCell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.reviews.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // some code that compute row's height
//    NSString *cellText = self.reviews[indexPath.row][@"content"];
//
//    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
//    CGSize labelSize = [cellText sizeWithFont:cellFont
//                            constrainedToSize:280
//                                lineBreakMode:UILineBreakModeWordWrap];
    
    return 157.0;
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
