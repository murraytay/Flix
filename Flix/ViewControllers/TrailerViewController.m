//
//  TrailerViewController.m
//  Flix
//
//  Created by Taylor Murray on 6/28/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "TrailerViewController.h"
#import <WebKit/WebKit.h>
@interface TrailerViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (strong, nonatomic) NSString *youtubeKey;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *baseString = @"https://api.themoviedb.org/3/movie/";
    NSNumber *movie_id = self.movie[@"id"];
    NSString *movie_id_string = [movie_id stringValue];
    NSString *endString = @"/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US";
    NSString *fullString = [baseString stringByAppendingString:movie_id_string];
    NSString *api_urlString = [fullString stringByAppendingString:endString];
    
    NSURL *api_url = [NSURL URLWithString:api_urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:api_url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
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
            self.youtubeKey = dataDictionary[@"results"][0][@"key"];
            
            NSString *baseYoutube = @"https://www.youtube.com/watch?v=";
            
            
            // Do any additional setup after loading the view.
            NSString *youtubeString = [baseYoutube stringByAppendingString:self.youtubeKey];//CHANGE THIS
            
            // Convert the url String to a NSURL object
            NSURL *url = [NSURL URLWithString:youtubeString];
            
            // Place the URL in a URL Request.
            NSURLRequest *request_youtube = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
            
            [self.webView loadRequest:request_youtube];
        }

    }];
    
    [task resume];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
