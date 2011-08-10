About
=====

Since iOS 3.2, you can use [custom fonts](http://developer.apple.com/library/ios/documentation/general/Reference/InfoPlistKeyReference/Articles/iPhoneOSKeys.html#//apple_ref/doc/uid/TP40009252-SW18) in your apps but unfortunately, you can't use these custom fonts in Interface Builder. **FontReplacer** is a solution to this problem.

If your project contains nibs with a lot of labels, it becomes tedious to setup an outlet for every label and change the font in the code for each outlet. Instead choose a font that you won't be using anywhere in your app, e.g. *Arial* and use it in Interface Builder. Then create a mapping from Arial to your custom font, e.g. *Caviar Dreams* and let **FontReplacer** handle the replacement.

Here is what you see in Interface Builder vs what you see at runtime:  
![Font in Interface Builder](https://github.com/0xced/FontReplacer/raw/master/Screenshots/Font-InterfaceBuilder.png "Font in Interface Builder")
![Font at Runtime](https://github.com/0xced/FontReplacer/raw/master/Screenshots/Font-Runtime.png "Font at Runtime")

Usage
=====

1. Copy UIFont+Replacement.h and UIFont+Replacement.m into your Xcode project
2. Create a replacement dictionary in your `Info.plist` with the `ReplacementFonts` key, for example

		ReplacementFonts = {
			"ArialMT" = "CaviarDreams";
			"Arial-ItalicMT" = "CaviarDreams-Italic";
			"Arial-BoldMT" = "CaviarDreams-Bold";
			"Arial-BoldItalicMT" = "CaviarDreams-BoldItalic";
		};

3. Use *Arial* in your nibs everywhere you want *Caviar Dreams*

If you want more control, you can use the `+[UIFont setReplacementDictionary:]` method instead of defining the `ReplacementFonts` Info.plist key. Make sure to call this early enough, before any font is deserialized from a nib.
