# NixOS module for River 0.4.0+ (AKA `river-next`)

While the new iteration of `river` now exists in Nixpkgs, given how the compositor works, a dozen or so of window managers would still need to be packaged to actually run something in it. This repository does exactly that: it builds the new River package, along with all supported window managers (see below) and a NixOS module. 

I plan to update packages roughly once a week, ideally on Mondays. Package versions (aside from River) will reflect this if they receive changes. Later I plan to adjust this to update based on their actual commit histories.  
**Last package update: 21-06-2026.**

This is the **main** branch, thus all the packages here are pulling changes against their respective main branches. Combined with their varying development statuses, there is **always non-zero chance of a breaking change**!  
If you are looking for something less unstable, I suggest looking at the [stable](https://github.com/dmkhitaryan/river-next-nix-module/tree/stable) branch.

## Contents
This repo has/will contain the following:
- [x] River 0.5.0 (from main branch)
- [x] Builds for window managers as listed [upstream](https://codeberg.org/river/wiki/src/branch/main/pages/wm-list.md): 
  - [x] anvl - Minimal river based tiling window manager inspired and influenced by dwm and tinyrwm
  - [x] argen - Task-oriented tiling window manager designed for keyboard + IPC workflows
  - [x] ashrwm - Minimal dynamic tiling window manager with tiling, and grid layouts, hot reloading and more
  - [x]  beansprout - DWM-style tiling window manager with built-in wallpaper and a clock/bar, with configuration in Kdl
  - [x] bridge - Horizontal-tiling window manager with built-in icon bar
  - [x] Canoe - Stacking window manager with classic look and feel, written in Rust
  - [x] CoW - Stacking window manager with a fvwm/mwm look and feel
  - [x] croffle - Static tiling window manager
  - [x] JrWM - Simple dynamic tiling window manager that's easy to build, read, and modify
  - [x]  kuskokwim - Tiling window manager with composable keybindings and first-class support for process management, written in Python
  - [x]  kwm - DWM-like dynamic tilling window manager with scrollable-tiling support, includes a simple status bar, written in Zig
  - [x]  machi - Minimalist window manager with cascading windows, horizontal panels and vertical workspaces
  - [x]  mousetrap - Minimal stumpwm/ratpoison-like window manager, using modern c++
  - [x]  notion-river - Static tiling window manager inspired by Notionwm (formerly Ion3)
  - [x]  orilla - Dynamic tiling window manager inspired by XMonad, written in Rust
  - [x]  pwm - Tiling window manager with SSD titlebars and Python API
  - [x]  reka - Emacs-based WM for river (similar to EXWM)
  - [x]  rhine - Tiling window manager with a bsp layout, some Hyprland IPC for bars and ambitions of modularity
  - [x]  rijan - Small dynamic tiling window manager in 600 lines of Janet
  - [x]  rill - Minimalist scrolling window manager with simple animation, written in Zig
  - [x] ropotamo - StumpWM-like tiling window manager for River
  - [x]  rrwm - Tiling window manager with a cosmic/bspwm layout, written in Rust
  - [x]  tarazed - Non-tiling window manager focusing on a powerful and distraction-free desktop experience
  - [x] Triad - Multi-paradigm window manager with embedded Janet scripting
  - [x] Weir - Tiling window manager inspired by XMonad and Rivercarro, dynamic CLI configuration
  - [x]  zrwm - Dynamic tiling window manager configured using a CLI tool
 - [x] River module: `programs.river-next`
    - See available options [here](https://github.com/dmkhitaryan/river-next-nix-module/wiki/List-of-Module-Options)
      
## Importing
To install the module, you can do the following (assumes npins installation, but others can work just fine too):
+ Run `npins add --name "river-next" github dmkhitaryan river-next-nix-module -b main`
+ Add `river-next = sources.river-next;` in a `let` statement in your configuration (or don't!).
+ Import the module either by adding `"${river-next}/river-module.nix"` or `(import river-next).nixosModule` in your `imports`. 

## Notes
It is highly recommended for users with multi-monitor setups to to configure outputs via tools like `kanshi` (see the module config). This is because not all window managers support output management on their own, which will lead to incorrectly positioned windows or even crashes altogether.

`reka`'s desktop session **will not launch via GDM**. TTY or something similar like `ly` will launch it correctly, though.  
Might just be a "GDM moment", but I do not plan to investigate further. That said, below are some tips:
  1. If you are going to launch it through TTY, run `exec /nix/store/...river-reka-launcher` and enjoy.
  2. If running through `ly` or similar, look for the *River (Reka)* entry in the session list. Select it, log in, and enjoy.

(06-06-2026): certain commands in `Triad` will not function on NixOS. Particularly, trying to execute `triad doctor-live` or `triad live-reload` will hit OSErrors due to the immutability of /nix/store.

(06-06-2026): `Weir` does not make use of typical configuration file setup. Instead, like classic River, it puts its config in an init script. Given the structure of this repo, a config option has been added to account for this nuance, `weirConfig`.

(14-06-2026): `JrWM` configuration is [based on files](https://github.com/jpco/jrwm#configuration) that are adjusted pre-build. To facilitate customization, users can pass custom configuration files via `jrwmConfig`.
