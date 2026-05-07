{
  nixosModule = import ./river-module.nix;

  packages = {
    river-next = ./river-next.nix;
    anvl = ./window-managers/anvl/package.nix;
    ashrwm = ./window-managers/ashrwm/package.nix;
    beansprout = ./window-managers/beansprout/package.nix;
    bridge = ./window-managers/bridge/package.nix;
    canoe = ./window-managers/canoe/package.nix;
    cow = ./window-managers/cow/package.nix;
    croffle = ./window-managers/croffle/package.nix;
    kuskokwim = ./window-managers/kuskokwim/package.nix;
    kwm = ./window-managers/kwm/package.nix;
    machi = ./window-managers/machi/package.nix;
    mousetrap = ./window-managers/mousetrap/package.nix;
    notion-river = ./window-managers/notion-river/package.nix;
    orilla = ./window-managers/orilla/package.nix;
    pwm = ./window-managers/pwm/package.nix;
    reka = ./window-managers/reka/package.nix;
    rhine = ./window-managers/rhine/package.nix;
    rijan = ./window-managers/rijan/package.nix;
    rill = ./window-managers/rill/package.nix;
    ropotamo = ./window-managers/ropotamo/package-test.nix;
    rrwm = ./window-managers/rrwm/package.nix;
    tarazed = ./window-managers/tarazed/package.nix;
    zrwm = ./window-managers/zrwm/package.nix;

    channel = ./channel/package.nix;
  };
}
