# HxDoom

Haxe port of Doom

HTML5 Build here: https://kevansevans.github.io/HxDoom/

```
////////////////////////////////////////////////////////////////////////////////////////////////////
//Goals
////////////////////////////////////////////////////////////////////////////////////////////////////
```

* Vanilla Like Behavior
* Deployable to several targets, properly taking advantage of what Haxe does

```
////////////////////////////////////////////////////////////////////////////////////////////////////
//Current disclaimer
////////////////////////////////////////////////////////////////////////////////////////////////////
```

HxDoom is not yet functional in the sense that compiling will yield something you can play. HxDoom will
get a proper release when, as far as I'll be able to tell, it's in a 'playable' state. Feel free to clone
and compile though, Haxe is Great!

```
////////////////////////////////////////////////////////////////////////////////////////////////////
//How to build
////////////////////////////////////////////////////////////////////////////////////////////////////
```

HxDoom will by default use the latest libraries and tools when possible.

As of 13DEC2019, HxDoom utilizes the following:
* HaxeDevelop
* Haxe 4.0.3
* Lime 7.6.3

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
