# NixOS module for River 0.4.0+ (AKA `river-next`)

While the new iteration of `river` now exists in Nixpkgs, given how the compositor works, a dozen or so of window managers would still need to be packaged to actually run something in it. This repository does exactly that: it builds the new River package, along with all supported window managers (see below) and a NixOS module. 

I plan to update packages roughly once a week, ideally on Mondays.  
**Last package update: 31-04-2026.**

## Contents
This repo has/will contain the following:
- [x] River 0.4.2 (from stable branch)
- [x] Builds for window managers as listed [upstream](https://codeberg.org/river/wiki/src/branch/main/pages/wm-list.md): 
  - [x]  beansprout - a DWM-style tiling window manager with built-in wallpaper and a clock/bar, with configuration in Kdl
  - [x]  canoe - Stacking window manager with classic look and feel, written in Rust
  - [ ]  kuskokwim - A tiling window manager with composable keybindings and first-class support for process management, written in Python
  - [x]  kwm - DWM-like dynamic tilling window manager with scrollable-tiling support, includes a simple status bar, written in Zig
  - [x]  machi - Minimalist window manager with cascading windows, horizontal panels and vertical workspaces
  - [ ]  mousetrap - Minimal stumpwm/ratpoison-like window manager, using modern c++
  - [x]  notion-river - Static tiling window manager inspired by Notionwm (formerly Ion3). 
  - [x]  orilla - Dynamic tiling window manager inspired by XMonad, written in Rust
  - [ ]  pwm - Tiling window manager with SSD titlebars and Python API
  - [ ]  reka - An Emacs-based WM for river (similar to EXWM)
  - [ ]  rhine - Tiling window manager with a bsp layout, some Hyprland IPC for bars and ambitions of modularity
  - [ ]  rijan - Small dynamic tiling window manager in 600 lines of Janet
  - [x]  rill - A minimalist scrolling window manager with simple animation, written in Zig
  - [x]  rrwm - Tiling window manager with a cosmic/bspwm layout, written in Rust
  - [ ]  tarazed - Non-tiling window manager focusing on a powerful and distraction-free desktop experience
  - [ ]  zrwm - Dynamic tiling window manager configured using a CLI tool
 - [x] River module: `programs.river-next`
    - See available options [here](https://github.com/dmkhitaryan/river-next-nix-module/wiki/List-of-Module-Options)
      
## Importing
To install the module, you can do the following (assumes npins installation, but others can work just fine too):
+ Run `npins add --name "river-next" github dmkhitaryan river-next-nix-module -b main`
+ Add `river-next = sources.river-next;` in a `let` statement in your configuration (or don't!).
+ Import the module either by adding `"${river-next}/river-module.nix"` or `(import river-next).nixosModule` in your `imports`. 

## Notes
It is highly recommended for users with multi-monitor setups to to configure outputs via tools like `kanshi` (see the module config). This is because not all window managers support output management on their own, which will lead to incorrectly positioned windows or even crashes altogether.

"Unchecked" window managers have no stable release as of now, and thus are excluded from the *stable* branch. If any of those interest you, I suggest looking at the *main* branch.
