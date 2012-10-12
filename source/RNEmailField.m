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

#import "RNEmailField.h"
#import "RNAvatarImageView.h"
#import "RNAvatarLoginDefines.h"

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


#pragma mark - Helpers

- (void)textValueDidChange:(id)sender {
#ifdef RNAVATARLOGIN_DEBUGGING_MODE
    NSLog(@"%@",self.text);
#endif
    
    if ([self.text length] > self.minCharactersForRequest) {
        [self.conn cancel];
        [self.conn getAvatarForEmail:self.text];
    }
}


#pragma mark - Setters

- (void)setAvatarImageView:(RNAvatarImageView<RNGravatarConnectionDelegate> *)avatarImageView {
    _avatarImageView = avatarImageView;
    self.conn.delegate = avatarImageView;
}


#pragma mark - Init

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
