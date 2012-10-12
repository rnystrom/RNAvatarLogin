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

#import "RNAvatarLogin.h"
#import <CommonCrypto/CommonDigest.h>
#import <QuartzCore/QuartzCore.h>

#pragma mark - Constants
NSString * const kRNAvatarErrorKey = @"com.whoisryannystrom.rnavatarlogin.kRNAvatarErrorKey";
NSString * const kRNAvatarErrorNotificationKey = @"com.whoisryannystrom.rnavatarlogin.kRNAvatarErrorNotificationKey";
NSString * const kRNAvatarSuccessNotificationKey = @"com.whoisryannystrom.rnavatarlogin.kRNAvatarSuccessNotificationKey";
NSString * const kRNGravatarBaseURL = @"http://www.gravatar.com/avatar";

#pragma mark - MD5

@implementation NSString (MyExtensions)
- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end

@implementation NSData (MyExtensions)
- (NSString*)md5
{
    unsigned char result[16];
    CC_MD5( self.bytes, self.length, result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end

#pragma mark - RNAvatarImageView

@implementation RNAvatarImageView

- (void)setDefaults {
    _avatarHasFadeAnimation = YES;
    _avatarFadeDuration = 0.3f;
}

#pragma mark RNGravatarConnectionDelegate

- (void)connectionDidCompleteWithImage:(UIImage *)image {
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    
    self.layer.cornerRadius = self.avatarCornerRadius;
    
    self.layer.borderColor = self.avatarBorderColor.CGColor;
    self.layer.borderWidth = self.avatarBorderWidth;
    
    self.layer.shadowColor = self.avatarShadowColor.CGColor;
    self.layer.shadowOffset = self.avatarShadowOffset;
    self.layer.shadowOpacity = self.avatarShadowOpacity;
    self.layer.shadowPath = self.avatarShadowPath;
    self.layer.shadowRadius = self.avatarShadowRadius;
    
    if (self.avatarHasFadeAnimation) {
        [UIView transitionWithView:self
                          duration:self.avatarFadeDuration
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.image = image;
                        }
                        completion:NULL];
    }
    else {
        self.image = image;
    }
}


#pragma mark Init

- (id)init {
    if (self = [super init]) {
        [self setDefaults];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setDefaults];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setDefaults];
    }
    return self;
}


- (id)initWithImage:(UIImage *)image {
    if (self = [super initWithImage:image]) {
        [self setDefaults];
    }
    return self;
}


- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    if (self = [super initWithImage:image highlightedImage:highlightedImage]) {
        [self setDefaults];
    }
    return self;
}


@end

#pragma mark - RNEmailField

@interface RNEmailField ()

@property (strong, readwrite) RNGravatarConnection *conn;

@end

@implementation RNEmailField

- (void)setDefaults {
    _conn = [[RNGravatarConnection alloc] initWithDelegate:self.avatarImageView];
    _conn.scale = [UIScreen mainScreen].scale;
    _minCharactersForRequest = 10;
    [self addTarget:self action:@selector(textValueDidChange:) forControlEvents:UIControlEventEditingChanged];
}


#pragma mark Helpers

- (void)textValueDidChange:(id)sender {
#ifdef RNAVATARLOGIN_DEBUGGING_MODE
    NSLog(@"%@",self.text);
#endif
    
    if ([self.text length] > self.minCharactersForRequest) {
        [self.conn cancel];
        [self.conn getAvatarForEmail:self.text];
    }
}


#pragma mark Setters

- (void)setAvatarImageView:(RNAvatarImageView<RNGravatarConnectionDelegate> *)avatarImageView {
    _avatarImageView = avatarImageView;
    self.conn.delegate = avatarImageView;
}


#pragma mark Init

- (id)init {
    if (self = [super init]) {
        [self setDefaults];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setDefaults];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setDefaults];
    }
    return self;
}


@end

#pragma mark - RNGravatarConnection

@interface RNGravatarConnection ()

@property (assign, readwrite) BOOL isLoading;

@end

@implementation RNGravatarConnection {
    NSMutableData *_data;
    NSURLConnection *_conn;
}

#pragma mark NSObject

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


#pragma mark Public

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


#pragma mark Helpers

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


#pragma mark NSURLConnection

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
