//
//  MSPViewModelCommonSignals.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/30/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import "MSPViewModelCommonSignals.h"
#import <AFNetworking.h>

@implementation MSPViewModelCommonSignals

-(RACSignal *)imageDownloadedSignal: (NSURL *)urlToThumbnail
{
    
    return [RACSignal createSignal:^RACDisposable *(id subscriber) {
        
        
        NSURLRequest *thumbnailRequest = [NSURLRequest requestWithURL:urlToThumbnail];
        NSLog(@"Attempting to fetch image at URL: %@", urlToThumbnail);
        
        AFHTTPRequestOperation *op =[AFImageRequestOperation imageRequestOperationWithRequest:thumbnailRequest imageProcessingBlock:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [subscriber sendNext:image];
            [subscriber sendCompleted];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"Error fetching image: %@", error);
        }];
                                      
        [op start];
        
        return nil;
    }];
    
}
@end
