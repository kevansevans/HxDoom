
# HxDoom readme

# What is HxDoom?
Haxe Doom is a Haxe library adaption of id Software's Doom, or more specifically, "id Tech 1". This is an attempt to create a standardized Doom library that can be used by anyone to create any sort of Doom program that they may need.

https://kevansevans.github.io/HxDoom/api/

Read the wiki on how to use HxDoom: https://github.com/kevansevans/HxDoom/wiki

## Principles of HxDoom
**Do it the Haxe way:** All Haxe targets must be supported and avoid any platform specific code. Yes, that includes Flash and PHP.

**Dependency injection where possible:** Developers shouldn't have to fork a library to make small changes or to add support for custom formats.

**Modding at the source level:** Developers should have the ability to create custom content at the source code level.

**K.I.S.S.:** Keep it simple, stupid.

## Licensing
HxDoom is MIT. You may use it for commercial purposes without the need to open source it, but I humbly request that you do if you plan on distributing your programs for free.

HxDoom uses a blackbox approach for development. For anything that can not be easily found online through a wiki, through programs like Slade, hex editors, map editors, through general word of mouth, or however, HxDoom will borrow code from the 3D0 release of Doom found here: https://github.com/Olde-Skuul/doom3do

Doom as an IP belongs to id Software, Zenimax, and Microsoft. The use of the name here is in name only and may not be used for commercial purposes without explicit permission or are otherwise known or assumed to be free to distribute. HxDoom shall not be used to distribute commercial products that the developer does not own the right to.

## Contributing
Here's some things you can do to help this project out:
 * Join DIYIDTECH and help us develop a blackbox Doom engine! https://discord.gg/a8n4Y2z
 * Test deployment on currently unverified Haxe targets. (Simply transpiling won't do, show us that the code works as intended!)
 * Further refine and test active working targets!
 * 
```
////////////////////////////////////////////////////////////////////////////////////////////////////
//Confirmed targets HxDoom has been compiled to and ran on (Please help with this list!)
////////////////////////////////////////////////////////////////////////////////////////////////////
```
* With Lime https://lime.software/
  * C++ (Widows, Manjaro)
  * Hashlink https://hashlink.haxe.org/
  * HTML5 w/WebGL
* With Heaps https://heaps.io/
  * Targeting Hashlink
  * Targeting Hashlink C
  * JavaScript Deployment: https://kevansevans.github.io/HxDoom/demo/
* Other
  * LOVR (Lua) https://lovr.org/

```
////////////////////////////////////////////////////////////////////////////////////////////////////
//Haxe code by kevansevans
////////////////////////////////////////////////////////////////////////////////////////////////////
//
//                         ...,,,,,,,,..                     
//                  ./&&%(/**,,,,,,,,,**/%&*               
//              .//,,,,,,,,,,,,,,,,,,,,,,,,/&&/            
//           ./&/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*&&,         
//         .#%*,*#/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#&,       
//        ,@#,,(*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/&(      
//      .%@*,/#,,,,,,,,,,,,,,,,*((/,,,,,,,,,,,,,,,,,,,##     
//     .&&/,*/,,,,,,,,,,,,,/#/,,,,,,,,,,,,,,,,,,,,,,,,,#&.   
//     %##,*%,,,,,,,,,,,,#(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%#   
//    ,%(/,#*,,,,,,,,,*#(,,,,,,,,,,,,,,,,,,,*/#%#%,,,,,,*&.  
//    (/#*,#,,,,,,,,,*%,,,,,,,,,,,,,,*/#%#*.    (*,,,,,,,((  
//    &*%**(,,,,,,,,/#,,,,,,,,,,*(&%(%.       /#,,,,,,,,,*%. 
//    &/%**(,,,,,,,/#,,,,,,,*/&%/%(  ,*     ,#/(#,,,,,,,,,&. 
//    ((##*%*******%*******#&&/*(@&**#,    *. (#,,,,,,,,,,&, 
//    .%/&/%/******%*****(&*.%**(@&*/&      *&/,,,,,,,,,,,&. 
//     /%/&/%******%****(#.  ,#****#(     /%**(*,,,,,,,,,*%. 
//      .%(&/%/****%/**/&(/    /%%/      .,#%*%*,,,,,,,,,#*  
//        ,%####***/%**#/   ....      /%/*****%*,,,,,,,,/&.  
//          .(%%/*/%*#*         .(#*.%/*****%,,,,,,,,*&*   
//              #%&@@%#%%#/*/%...#*    *%****(/,,,,,,,*&,    
//             /#*****/(%***#*...#,    (%***/%,,,,,,,(&.     
//          .%%*,,,,*#%&%%%,......*.,&/**/(,,,,,,/%,       
//       (&(((((##(/%%,,,,*%,....../##&/*(#*,,,,*&(.         
//         /%(/***/&/,,,,,,/(......*(#/,,,*(&(,            
//             .,(&,,,,,,,,*%    .*/(*,.                 
//              (#,,,,,**,,,/*    ..,#(#&&&/                 
//             *(,,,,*&/*,,,,%.  #*,,,,***&/                 
//           .#(,,,*%#(%******%(.%*******(&.                 
//           %/,,,/@(//##*******##*******&%#   
////////////////////////////////////////////////////////////////////////////////////////////////////
```