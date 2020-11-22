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
HxDoom falls under the GPL3 license as it borrows from several GPL2 (and later) sources. Licensing is a bit fuzzy elsewhere and I am currently investigating licensing repurposing.

## Contributing
Here's some things you can do to help this project out:
 * Help port over the original Doom engine from C to Haxe up to HxDoom's standards
 * Leading development for a currently untested target
 * Test and existing target to verify feature and behavior parity
 * Give as much feedback as possible! This is a huge project!


```
////////////////////////////////////////////////////////////////////////////////////////////////////
//Confirmed targets HxDoom has been compiled to and ran on (Please help with this list!)
////////////////////////////////////////////////////////////////////////////////////////////////////
```
* With Lime https://lime.software/
  * C++ (Widows, Manjaro)
  * Hashlink https://hashlink.haxe.org/
  * HTML5 w/WebGL
* With Heaps
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
