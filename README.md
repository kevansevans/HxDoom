# HxDoom

Playable HTML5 Build here: https://kevansevans.github.io/HxDoom/

```
////////////////////////////////////////////////////////////////////////////////////////////////////
//About
////////////////////////////////////////////////////////////////////////////////////////////////////
```

HxDoom is an attempt to port id Software's Doom to Haxe, while at the same time maintaining cross deployment on all Haxe supported targets.

In order to maintain wide support, HxDoom's end goal is to be a shareable haxelib for anyone to download and build their own renderer on top of.
The current renderer being built on Lime is called the "Citrus" renderer, pun very obviously intended. The HxDoom haxelib will serve as the engine backend,
cradiling any obvious (non-rendering) actions one would expect in an id Tech 1 engine.

Help is currently not being accepted. Since what I have now is not ready for release, filing any issues or submitting any code would be extremely redundant.
HxDoom will get a proper release when I feel I have what feels close to a relatively near identical behaving source compared to classic doom.


```
////////////////////////////////////////////////////////////////////////////////////////////////////
//How to build
////////////////////////////////////////////////////////////////////////////////////////////////////
```

HxDoom will by default use the latest libraries and tools when possible.

As of 13DEC2019, HxDoom utilizes the following:
* HaxeDevelop
* Haxe 4.0.3
* Lime 7.7.0

Other libraries will be dependant on the target you are focusing on, such as HXCPP, HXJAVA, HXCS. 
The Haxe compiler will inform you if these libraries are needed.

Instructions:
* Download Haxe from https://haxe.org/
	
* use the commands ``haxelib install lime``
* run the command ``haxelib run lime setup`` and agree to installing the lime command
* if compiling from the terminal, switch directories to the folder containing ``project.xml`` and run the command ``lime build windows`` or ``lime build html5``
* if using HaxeDevlop, navigate to the folder containing ``HxDoom.hxproj`` and open that file, press F5 or click the play button on top.

```
////////////////////////////////////////////////////////////////////////////////////////////////////
//How to contribute
////////////////////////////////////////////////////////////////////////////////////////////////////
```

Contributions to HxDoom are not currently accepted, but will be in the future when I feel the engine is up to snuff. If and when this
happens, it is encouraged, but not mandatory, that you have knowledge of the following:

* Understanding of Doom modding
* Understanding of Haxe and it's tools
* Understanding of WebGL


```
////////////////////////////////////////////////////////////////////////////////////////////////////
//Haxe port by kevansevans
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
