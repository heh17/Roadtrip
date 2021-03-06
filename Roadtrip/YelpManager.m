//
//  YelpManager.m
//  Roadtrip
//
//  Created by Hector Diaz on 7/16/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "YelpManager.h"

static NSString *const clientId = @"My-u0b-xeFD3zRNnFgrTSA";
static NSString *const apiKey = @"twGNW7wA2e3-suEKeND9MKXRf_kyK0t7xJ5P-9vpNuUizaTTG6KN1WOUIYWeYw0EGDDCpHt4AqI862iz3noXhwC7SJYKyuivB4wAp_zKb_4Od7o2xColAUjYiLVGW3Yx";

@implementation YelpManager

- (void)getEventCategories:(void(^)(NSDictionary *categories, NSError *error))completion {
    
    NSURL *url = [NSURL URLWithString:@"https://api.yelp.com/v3/categories"];

    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *headerValue = [NSString stringWithFormat:@"Bearer %@", apiKey];
    
    [request setValue:headerValue forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            
            completion(nil, error);
            
        }
        else {
            
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            completion(dataDictionary, nil);
            
        }
        
    }];
    [task resume];

}
- (void) getEventswithLatitude:(double) latitude withLongitude: (double) longitude withUnixStartDate: (NSString *)startDate withUnixEndDate: (NSString *)endDate withCompletion: (void(^)(NSArray *eventsDictionary, NSError *error))completion {
    
    
    NSString *baseUrlString = @"https://api.yelp.com/v3/events";
    
    NSString *parametersUrlString = [NSString stringWithFormat:@"?latitude=%f&longitude=%f&start_date=%@&end_date=%@&limit=50", latitude, longitude, startDate, endDate];
    
    NSString *urlString = [baseUrlString stringByAppendingString:parametersUrlString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *headerValue = [NSString stringWithFormat:@"Bearer %@", apiKey];
    
    [request setValue:headerValue forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            
            completion(nil, error);
            
        }
        else {
            
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            completion(dataDictionary[@"events"], nil);
            
        }
        
    }];
    [task resume];

}

- (void) getEventsWithCategory: (NSString *) category withLatitude:(double) latitude withLongitude: (double) longitude withUnixStartDate: (NSString *)startDate withUnixEndDate: (NSString *)endDate withCompletion: (void(^)(NSDictionary *eventsDictionary, NSError *error))completion  {
    
    NSString *baseUrlString = @"https://api.yelp.com/v3/events";
    
    NSString *parametersUrlString = [NSString stringWithFormat:@"?categories=%@&latitude=%f&longitude=%f&start_date=%@&end_date=%@&limit=50", category, latitude, longitude, startDate, endDate];
    
    NSString *urlString = [baseUrlString stringByAppendingString:parametersUrlString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];

    NSString *headerValue = [NSString stringWithFormat:@"Bearer %@", apiKey];

    [request setValue:headerValue forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            
            completion(nil, error);
            
        }
        else {
            
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            completion(dataDictionary[@"events"], nil);
            
        }
        
    }];
    [task resume];

}

- (void) getEventsWithCategories: (NSArray *) categories withLatitude:(double) latitude withLongitude: (double) longitude withUnixStartDate: (NSString *)startDate withUnixEndDate: (NSString *)endDate withCompletion: (void(^)(NSArray *eventsDictionary, NSError *error))completion {
    
    NSString *baseUrlString = @"https://api.yelp.com/v3/events";
    
    NSString *parametersUrlString = [NSString stringWithFormat: @"%@&latitude=%f&longitude=%f&start_date=%@&end_date=%@&limit=50", [self getCategoriesParameterFormat:categories], latitude, longitude, startDate, endDate];
    
    NSString *urlString = [baseUrlString stringByAppendingString:parametersUrlString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *headerValue = [NSString stringWithFormat:@"Bearer %@", apiKey];
    
    [request setValue:headerValue forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            
            completion(nil, error);
            
        }
        else {
            
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            completion(dataDictionary[@"events"], nil);
            
        }
        
    }];
    [task resume];
    
}


-(void) getFeaturedEventWithLatitude: (double) latitude withLongitude: (double) longitude withCompletion: (void(^)(NSDictionary *dictionary, NSError *error)) completion {
    
    
    NSString *baseUrlString = @"https://api.yelp.com/v3/events/featured";
    
    NSString *parametersUrlString = [NSString stringWithFormat:@"?latitude=%f&longitude=%f", latitude, longitude];
    
    NSString *urlString = [baseUrlString stringByAppendingString:parametersUrlString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *headerValue = [NSString stringWithFormat:@"Bearer %@", apiKey];
    
    [request setValue:headerValue forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            
            completion(nil, error);
            
        }
        else {
            
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            completion(dataDictionary, nil);
            
        }
        
    }];
    [task resume];
    
    
}


-(void) getBusinessesWithLatitude: (double) latitude withLongitude: (double) longitude withCompletion: (void(^)(NSDictionary *dictionary, NSError *error)) completion{
    
    NSString *baseUrlString = @"https://api.yelp.com/v3/businesses/search";
    
    NSString *parametersUrlString = [NSString stringWithFormat:@"?latitude=%f&longitude=%f", latitude, longitude];
    
    NSString *urlString = [baseUrlString stringByAppendingString:parametersUrlString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *headerValue = [NSString stringWithFormat:@"Bearer %@", apiKey];
    
    [request setValue:headerValue forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            
            completion(nil, error);
            
        }
        else {
            
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            completion(dataDictionary, nil);
            
        }
        
    }];
    [task resume];
    
}

-(void) getRestaurantsWithLatitude: (double) latitude withLongitude: (double) longitude withCategories: (NSArray *) categories withCompletion: (void(^)(NSArray *restaurantsArray, NSError *error)) completion{
    
    NSString *baseUrlString = @"https://api.yelp.com/v3/businesses/search";
    
    NSString *categoriesString = [self getCategoriesParameterFormat:categories];
    
    NSString *parametersUrlString = [NSString stringWithFormat:@"%@&latitude=%f&longitude=%f&radius=16000", categoriesString, latitude, longitude];
    
    NSString *urlString = [baseUrlString stringByAppendingString:parametersUrlString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSLog(@"%@", url);
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *headerValue = [NSString stringWithFormat:@"Bearer %@", apiKey];
    
    [request setValue:headerValue forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            
            completion(nil, error);
            
        }
        else {
            
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            completion(dataDictionary[@"businesses"], nil);
            
        }
        
    }];
    [task resume];
    
}

-(void) getRestaurantReviewsWithId: (NSString *) restaurantId withCompletion: (void(^)(NSDictionary *dictionary, NSError *error)) completion {
    
    NSString *urlString = [NSString stringWithFormat: @"https://api.yelp.com/v3/businesses/%@/reviews", restaurantId];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *headerValue = [NSString stringWithFormat:@"Bearer %@", apiKey];
    
    [request setValue:headerValue forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            
            completion(nil, error);
            
        }
        else {
            
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            completion(dataDictionary[@"reviews"], nil);
            
        }
        
    }];
    [task resume];
    
}


-(NSString *) getCategoriesParameterFormat: (NSArray *) categories {
    
    NSString *string = @"?categories=";
    
    for(NSString *category in categories) {
        
        string = [string stringByAppendingString:[NSString stringWithFormat:@"%@,", category]];
        
    }
    
    return [string substringToIndex: [string length] - 1];
    
}

@end
