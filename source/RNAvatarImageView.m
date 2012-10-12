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

#import "RNAvatarImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RNAvatarImageView

- (void)setDefaults {
    _avatarHasFadeAnimation = YES;
    _avatarFadeDuration = 0.3f;
}

#pragma mark - RNGravatarConnectionDelegate

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


#pragma mark - Init

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
