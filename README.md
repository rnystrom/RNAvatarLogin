RNAvatarLogin
======

This project was entirely inspired by the beautiful [GoSquared Login](https://www.gosquared.com/blog/archives/3359). It is a really unique and peculiar way to "entertain" the user while a task completes. Using a Gravatar fulfills purposes in a login: it lets the user validate that they have entered **their** email, and it also provides a more personal experience by welcoming the user to see **their** account.

[View a video demo here](http://www.youtube.com/watch?v=bTLEJ67DIds&feature=youtu.be)

## Installation

Super simple. Just drag & drop both RNAvatarLogin .h and .m files into your project. 

In your Build Phases > Link Binary With Libraries add the Quartzcore.framework to your project.

## Usage

The simplest way to get started is to create a <code>UIImageView</code> and <code>UITextField</code> in a NIB or Storyboard and then set their classes to <code>RNAvatarImageView</code> and <code>RNEmailField</code>, respectively. Then add the following to your view controller:

``` objective-c
self.emailField.avatarImageView = self.avatarImageView;
```

That will run with the default settings and swap images as soon as a Gravatar is found.

## Config

I've tried my best to provide some simple configuration settings to aid in animation and appearance of the Gravatar. Here are all of the available configuration settings.

``` objective-c
@interface RNAvatarImageView

// animation
@property (assign) BOOL avatarHasFadeAnimation;     // default YES
@property (assign) CGFloat avatarFadeDuration;      // default 0.3 seconds

// appearance
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

// how many characters until requests start firing
@property (assign) NSInteger minCharactersForRequest;   // default 10 chars

@end
```

## Contact

* [@nystrorm](https://twitter.com/_ryannystrom) on Twitter
* [@rnystrom](https://github.com/rnystrom) on Github
* <a href="mailTo:rnystrom@whoisryannystrom.com">rnystrom [at] whoisryannystrom [dot] com</a>

## License

Copyright (c) 2012 Ryan Nystrom (http://whoisryannystrom.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.