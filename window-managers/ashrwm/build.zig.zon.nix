{
  linkFarm,
  fetchgit,
  fetchzip,
}:
linkFarm "zig-packages" [
  {
    name = "N-V-__8AAEZXGQD2FnVezv2mY8V4aYW9j-JDCLw6vDmFFqze";
    path = fetchgit {
      url = "https://gitlab.freedesktop.org/wayland/wayland.git";
      rev = "99638501a1314e68c79176fa2cafa3bbe6cf55ea";
      hash = "sha256-2Tz/Owuc8gBHg7CSd4wq+mvowsjm0nbLnasyabVslGg=";
    };
  }
  {
    name = "N-V-__8AAIEhIgBR5OJUsRfe9z01OzwIngIwNeZy1NBuBEoc";
    path = fetchgit {
      url = "https://github.com/janet-lang/janet";
      rev = "1449ad8b31947999b2b6887fe633883106e5e65c";
      hash = "sha256-BV5hVg85QgN8DXiMF2kA3IQNuvWjcsyciiuQP5+c+7c=";
    };
  }
  {
    name = "N-V-__8AAFRAZAD02nId1w02lyWXmN-hvo873BSh9wZDxjSN";
    path = fetchgit {
      url = "https://github.com/xkbcommon/libxkbcommon.git";
      rev = "0f9cefb1fedb23433666fa5d9045e48ff030c006";
      hash = "sha256-IV1dgGM8z44OQCQYQ5PiUUw/zAvG5IIxiBywYVw2ius=";
    };
  }
  {
    name = "janet-1.40.1-3XUN8cVGAAA7Os-UamOhi0sYVRqN-slGltgD5Jwwwfdk";
    path = fetchgit {
      url = "https://codeberg.org/ifreund/zig-janet";
      rev = "977e2777b9f0f6fd3531bec3c96c7073b690cbe3";
      hash = "sha256-mKkQziZ6Cpyy9TKcCIB/9PPqRwHP8EVNWdpQwfLWCis=";
    };
  }
  {
    name = "N-V-__8AAFKzAADGCCHsA4J38ww-aT3CFoj2MbSxtkWX0D50";
    path = fetchgit {
      url = "https://codeberg.org/ifreund/janet-wayland";
      rev = "0aea1ae8c2b462d609fc739acceeb9ead315c07f";
      hash = "sha256-maPZ0hAvsBhRuVZt/6hlUYHkxGSbV+zwVDldqjDRRNU=";
    };
  }
  {
    name = "wayland-1.24.0-3-dxEBa1pmAABlHkqXCGmZ4r9c_N8fhAXculLHBbO2pRRT";
    path = fetchgit {
      url = "https://github.com/ifreund/wayland-build.zig";
      rev = "8c7f2c42ab0e4c16853d03914ce1f3259cda40db";
      hash = "sha256-3rQYOzTE7zX4PEOA3/6FbhTQUhP4PWPUUVN7Y7GDVAc=";
    };
  }
  {
    name = "libxkbcommon-1.11.0-1-93LaF6pwAgDFoaLfOkR8ioG4RVcDHbBhsDmC_rYwyOEG";
    path = fetchgit {
      url = "https://github.com/allyourcodebase/libxkbcommon";
      rev = "809157d5118909298f3e086fa8d8103198e938fd";
      hash = "sha256-MY01xZm148gg0WosOgVQz5vEAyzUq6UHgTf6uv1u+yw=";
    };
  }
  {
    name = "N-V-__8AAGELAABqy7_LKHe7k7pcmtqO8MJth7xoJZSYvriG";
    path = fetchgit {
      url = "https://codeberg.org/ifreund/janet-xkbcommon";
      rev = "bdd15cd20329078e47abb30bddddfb7b28f52f66";
      hash = "sha256-G3Ds9cffh+dNlHTLfJEBfb5JcMJI42thMVcV/HooBHs=";
    };
  }
  {
    name = "N-V-__8AAA3IEACRX8ha9Z5HVJLPzBt9S6Kt7oNfQsWh5vUN";
    path = fetchgit {
      url = "https://github.com/janet-lang/spork";
      rev = "4224d5678ec8bb8777a9075030cf38da52f2d70a";
      hash = "sha256-nZUcK1woCQ+t/Qal/zg0Ok7B5q5RWfe6bflEzfsZIsA=";
    };
  }
  {
    name = "N-V-__8AAPMqAQCbXJ9KGZ7pEepOFcJFiLb-PW0LlAOhlgtd";
    path = fetchgit {
      url = "https://github.com/pyrmont/lemongrass";
      rev = "906974b82ba06ed421e0c8cd9a56c6ddc4ca6820";
      hash = "sha256-OUqK57EYh6McnxnbvqoPm92eBMYM5iNaPuN6R0yZHA4=";
    };
  }
  {
    name = "river-0.4.2-_G6Njq3eCwBPOoLbZB7ULNNEcIFDNJpz-vDYzr6JanWZ";
    path = fetchgit {
      url = "https://codeberg.org/river/river";
      rev = "addd4a0c5386fe3efc6d37cdde458d0f3153bebe";
      hash = "sha256-Nufonz39XphxPW1lERq2acVgE5mGmW+x1yimyS6O4tc=";
    };
  }
  {
    name = "N-V-__8AAMCWEADA0AS-1LfBEtixZLJAb_XQKQpgSmR2uxAO";
    path = fetchgit {
      url = "https://gitlab.freedesktop.org/wayland/wayland-protocols";
      rev = "02e63e74a807afed95bc25a386173110afef24e3";
      hash = "sha256-nleROoMciq1WassaZ+1ol6VxLWY5UwYlZC5+zNexFn8=";
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
    name = "wayland-0.5.0-lQa1knz8AQCh08NA8BeQrwJB9U3CfqcVAdHZYGRKIGuu";
    path = fetchzip {
      url = "https://codeberg.org/ifreund/zig-wayland/archive/v0.5.0.tar.gz";
      hash = "sha256-mhqOtC26iACIvQUq74AbLSXSPsnWMi3AvDV7G2uElpo=";
    };
  }
  {
    name = "wlroots-0.20.0-jmOlcmtCBADS6eoJ6mkeiSNZkibrhD-c5Qwn-LiM86r1";
    path = fetchzip {
      url = "https://codeberg.org/ifreund/zig-wlroots/archive/v0.20.0.tar.gz";
      hash = "sha256-QblQBVsDV2kSj31jqmVVi4hQUXuv8bsRgRMaCqlNxNM=";
    };
  }
  {
    name = "xkbcommon-0.4.0-VDqIe0i2AgDRsok2GpMFYJ8SVhQS10_PI2M_CnHXsJJZ";
    path = fetchzip {
      url = "https://codeberg.org/ifreund/zig-xkbcommon/archive/v0.4.0.tar.gz";
      hash = "sha256-zQkmP/cuhAtjOLqYS5D15khKzpqyhbyZ0TD6/8jOkqE=";
    };
  }
]
