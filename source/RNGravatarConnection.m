/*
 * RNAvatarLogin
 *
 * Created by Ryan Nystrom on 10/2/12.
 * Copyright (c) 2012 Ryan Nystrom. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "RNGravatarConnection.h"
#import "RNAvatarLoginDefines.h"
#import "NSString+MD5.h"

NSString * const kRNGravatarBaseURL = @"http://www.gravatar.com/avatar";

@interface RNGravatarConnection ()

@property (assign, readwrite) BOOL isLoading;

@end

@implementation RNGravatarConnection {
    NSMutableData *_data;
    NSURLConnection *_conn;
}

#pragma mark - NSObject

- (id)init {
    if (self = [super init]) {
        _imageSize = 128.0f;
        _isLoading = NO;
        _scale = 1.0f;
    }
    return self;
}


- (id)initWithDelegate:(NSObject<RNGravatarConnectionDelegate>*)delegate {
    if (self = [self init]) {
        _delegate = delegate;
    }
    return self;
}


#pragma mark - Public

- (void)getAvatarForEmail:(NSString*)email {
    self.isLoading = YES;
    NSString *hashedEmail = [self hashEmail:email];
    // eg http://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200
    NSString *urlString = [NSString stringWithFormat:@"%@/%@?s=%.0f&d=404",kRNGravatarBaseURL,hashedEmail,self.scale * self.imageSize];
    
#ifdef RNAVATARLOGIN_DEBUGGING_MODE
    NSLog(@"%@",urlString);
#endif
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    _conn = [NSURLConnection connectionWithRequest:request delegate:self];
}


- (void)cancel {
    [_conn cancel];
    _conn = nil;
    _data = nil;
    self.isLoading = NO;
}


#pragma mark - Helpers

- (NSString*)hashEmail:(NSString*)email {
    return [email md5];
}


- (void)processCompletedData {
    if (_data && self.delegate) {
        UIImage *image = [[UIImage alloc] initWithData:_data scale:self.scale];
        [self.delegate connectionDidCompleteWithImage:image];
        [[NSNotificationCenter defaultCenter] postNotificationName:kRNAvatarSuccessNotificationKey object:nil];
    }
}


#pragma mark - NSURLConnection

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
#ifdef RNAVATARLOGIN_DEBUGGING_MODE
    NSLog(@"%@",error.localizedDescription);
#endif
    
    [self cancel];
    
    NSDictionary *userInfo = @{kRNAvatarErrorKey : error};
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kRNAvatarErrorNotificationKey object:nil userInfo:userInfo];
    });
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (_data) {
        [_data appendData:data];
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    
#ifdef RNAVATARLOGIN_DEBUGGING_MODE
    NSLog(@"Status Code: %i",httpResponse.statusCode);
#endif
    
	if (httpResponse.statusCode != 200) {
#ifdef RNAVATARLOGIN_DEBUGGING_MODE
        NSLog(@"Request cancelled");
#endif
        [self cancel];
    }
    else {
        _data = [NSMutableData data];
    }
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
#ifdef RNAVATARLOGIN_DEBUGGING_MODE
    NSLog(@"Connection did finish loading");
#endif
    
    [self processCompletedData];
    [self cancel];
}


@end
