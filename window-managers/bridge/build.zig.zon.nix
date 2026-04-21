{ linkFarm, fetchzip }:
linkFarm "zig-packages" [
  {
    name = "wayland-0.5.0-lQa1knz8AQCh08NA8BeQrwJB9U3CfqcVAdHZYGRKIGuu";
    path = fetchzip {
      url = "https://codeberg.org/ifreund/zig-wayland/archive/v0.5.0.tar.gz";
      hash = "sha256-mhqOtC26iACIvQUq74AbLSXSPsnWMi3AvDV7G2uElpo=";
    };
  }
  {
    name = "river-0.4.1-_G6Njv-nCwBebH8tw6eZ3ERv05GLjVkzpFzRGsnpfzgG";
    path = fetchzip {
      url = "https://codeberg.org/river/river/archive/v0.4.1.tar.gz";
      hash = "sha256-EGWLJY9VPdoc4LrXkWi8cNLkahorvDeAIfSOc5yDfbU=";
    };
  }
  {
    name = "xkbcommon-0.4.0-VDqIe0i2AgDRsok2GpMFYJ8SVhQS10_PI2M_CnHXsJJZ";
    path = fetchzip {
      url = "https://codeberg.org/ifreund/zig-xkbcommon/archive/v0.4.0.tar.gz";
      hash = "sha256-zQkmP/cuhAtjOLqYS5D15khKzpqyhbyZ0TD6/8jOkqE=";
    };
  }
  {
    name = "N-V-__8AAFdWDwA0ktbNUi9pFBHCRN4weXIgIfCrVjfGxqgA";
    path = fetchzip {
      url = "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/archive/1.47/wayland-protocols-1.47.tar.gz";
      hash = "sha256-vD7Nj9iLeS52Et3gcX1m9Zmp05A+VV3J3hkPcM11YEQ=";
    };
  }
  {
    name = "pixman-0.3.0-LClMnz2VAAAs7QSCGwLimV5VUYx0JFnX5xWU6HwtMuDX";
    path = fetchzip {
      url = "https://codeberg.org/ifreund/zig-pixman/archive/v0.3.0.tar.gz";
      hash = "sha256-8tA4auo5FEI4IPnomV6bkpQHUe302tQtorFQZ1l14NU=";
    };
  }
  {
    name = "wlroots-0.19.4-jmOlcqQMBABhKYH6NMSnoK1sohTbhc97_JP-hGg2UZaK";
    path = fetchzip {
      url = "https://codeberg.org/ifreund/zig-wlroots/archive/v0.19.4.tar.gz";
      hash = "sha256-g1LOSMMnjGJIS+U7zrx6FAoUyavqwaQ2UrDv6GxCQsY=";
    };
  }
  {
    name = "fcft-3.0.0-zcx6CxQfAAAOlHFehXv7HwRPcuo7StCjZAtapZbSB6fq";
    path = fetchzip {
      url = "https://git.sr.ht/~novakane/zig-fcft/archive/v3.0.0.tar.gz";
      hash = "sha256-/sd+lUK/M48Vfqth1z9BJp/dJ/SMahoCfPqhMJD3lgQ=";
    };
  }
]
