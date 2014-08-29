YLLongTapShare
==============

Long Tap Sharing control for iOS. Inspired by [this design](https://dribbble.com/shots/1438386-iOS7-longtouch-sharing-concept?list=following&offset=71).

<img src="./joy.gif" align="middle" width="320" />

###Get Start
Using [CocoaPods](http://cocoapods.org/) to get start, you can add following line to your Podfile:
    
    pod 'YLLongTapShare'

###How to use it
For using this control, it's very easy, after adding source file to your project, using following code to enable the long tap share function.

    
    [self.view addShareItem:[YLShareItem itemWithIcon:[UIImage imageNamed:@"facebook"] andTitle:@"Facebook"]];
    [self.view addShareItem:[YLShareItem itemWithIcon:[UIImage imageNamed:@"pinterest"] andTitle:@"Pinterest"]];
    [self.view addShareItem:[YLShareItem itemWithIcon:[UIImage imageNamed:@"instagram"] andTitle:@"Instagram"]];

It support YLLongTapShareView and UIButton. The default color of this control is white, for customizing the color apperance, you can implmenet following delegate function:

    - (UIColor*)colorOfShareView {
        return [UIColor redColor];
    }

###Welcome pull request
With your help, we can continually improve this control.

Thanks.