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

extern NSString * const kRNAvatarErrorKey;
extern NSString * const kRNAvatarErrorNotificationKey;
extern NSString * const kRNAvatarSuccessNotificationKey;


@interface NSString (MD5)
- (NSString *) md5;
@end


@interface NSData (MD5)
- (NSString*)md5;
@end


@protocol RNGravatarConnectionDelegate <NSObject>

@required
- (void)connectionDidCompleteWithImage:(UIImage*)image;

@end


@interface RNGravatarConnection : NSObject
<NSURLConnectionDataDelegate>

@property (assign, readonly) BOOL isLoading;
@property (weak) NSObject <RNGravatarConnectionDelegate> *delegate;
@property (assign) CGFloat imageSize;
@property (assign) CGFloat scale;

- (id)initWithDelegate:(NSObject<RNGravatarConnectionDelegate>*)delegate;
- (void)getAvatarForEmail:(NSString*)email;
- (void)cancel;

@end


@interface RNAvatarImageView : UIImageView
<RNGravatarConnectionDelegate>

@property (strong, readonly) UIImageView *avatarView;

@property (assign) BOOL avatarHasFadeAnimation;
@property (assign) CGFloat avatarFadeDuration;

@property (assign) CGFloat avatarCornerRadius;
@property (assign) CGFloat avatarBorderWidth;
@property (strong) UIColor *avatarBorderColor;
@property (assign) CGSize avatarShadowOffset;
@property (assign) CGPathRef avatarShadowPath;
@property (strong) UIColor *avatarShadowColor;
@property (assign) CGFloat avatarShadowOpacity;
@property (assign) CGFloat avatarShadowRadius;

@end


@interface RNEmailField : UITextField

@property (weak, nonatomic) RNAvatarImageView <RNGravatarConnectionDelegate> *avatarImageView;
@property (assign) NSInteger minCharactersForRequest;
@property (strong, readonly) RNGravatarConnection *conn;

@end
