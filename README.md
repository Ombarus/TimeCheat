# Time Cheat Sample

## Introduction

**Time Cheat Android App** is a small Godot app to illustrate how you could keep track of time in a mobile game.

Made in Godot 3.5


## How to use
* This is not really meant to be run as-is. You'll probably need to set up Android Studio, update the project and compile it yourself
* You will need to install Godot's export template for android and change the export settings to fit your build

## Warning
This is not meant to be used as-is! It keeps data in a plain text json file, doesn't try to hide or encrypt any information and relies on parsing the Google's header to get the "server" time which is probably not very realiable. If you want to implement any of those anti-cheating methods in your game you will need a lot of work to encrypt the information, use a private server over an encrypted connection and many more things.

## Support

You can ask for help on:

* [The Contact Form on my website](https://www.ombarus.com/)
* [Ombarus Discord Server](https://discord.gg/8vUQuqh)
* Social networks:
  [Twitter](https://twitter.com/ombarus1/),
  [YouTube](https://www.youtube.com/channel/UCscoqrVcMbZwv5jIpKVYpDg),
  [Instagram](https://www.instagram.com/ombarus1/).

## Credits

[Ombarus Dev](https://www.ombarus.com/):
  
## License

The MIT License (MIT)

Copyright (c) 2020 Ombarus Dev

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.