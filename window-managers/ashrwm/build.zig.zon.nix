# build.zig.zon-sha256: adbd8970d5a47374e891f004704fe70439d7e9d82fec3420d66e974b812fbaf5
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
    name = "janet-1.40.1-3XUN8XBHAACHFw6WZRjSbJ0BjX27rXCUvQKat43iHXgA";
    path = fetchgit {
      url = "https://codeberg.org/shadowash8/zig-janet";
      rev = "638d8d204d0bf52291016389fa6102f9c65a1165";
      hash = "sha256-EJb7X8LTJifOAj3TyhtKwheunsXSpdTXuzJYhayEUVI=";
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
    name = "N-V-__8AAHn0JAAOBkhzH_lP16r6zcK9R4FIAKGhA7Fdc7gD";
    path = fetchgit {
      url = "https://gitlab.freedesktop.org/wayland/wayland.git";
      rev = "3e673a438b0a9749e3bdf5cac4befac86333024c";
      hash = "sha256-aQTciXUsYIV5rWr2wNN+daH0KZfcrVSVZHoUdTutizM=";
    };
  }
  {
    name = "wayland-1.25.0-dxEBa-F8AABPX6jLWqVIso2VnrD-M_qAmdSPQxLaVZvL";
    path = fetchgit {
      url = "https://github.com/shadowash8/wayland-build.zig";
      rev = "4f52f0c5ef51de908b1797683f029d5260b03aaf";
      hash = "sha256-H/9Lzdr7Ml5NCAyXNbhzfyxKtxyWoYyoT7jIO/CgJQI=";
    };
  }
  {
    name = "libxkbcommon-1.13.1-93LaF2x7AgDgSrr8xjRYrYGhtGhJKcZMuID3M95APvl1";
    path = fetchgit {
      url = "https://github.com/allyourcodebase/libxkbcommon";
      rev = "8c31126430bec39d2cb5f06aa3c2667e006b32ea";
      hash = "sha256-o6Rj5wcrqCF8zUpZ6FFCXlTSoMepxoJkGhwu+LMvGK4=";
    };
  }
  {
    name = "N-V-__8AALGdawC4U4VZt8pBwXK8gBVv2OTdm2naBwU9xHcb";
    path = fetchgit {
      url = "https://github.com/xkbcommon/libxkbcommon.git";
      rev = "6f76d19db72b5d450e927b41e1e96cbe3252aba8";
      hash = "sha256-wUsxsM0xXTg7nbvFMXrrnHherOepj0YI77eferjRgJA=";
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
    name = "aro-0.0.0-JSD1Qi7QNgDnfcrdEJf82v3o6MhZySjYVrtdfEf3E4Se";
    path = fetchgit {
      url = "https://github.com/Vexu/arocc";
      rev = "5f5a050569a95ecc40a426f0c3666ae7ef987ede";
      hash = "sha256-f8Z0SXWx5Uia2TCMB5SUpcO8+xUnaWk32Oknva7xcxw=";
    };
  }
  {
    name = "translate_c-0.0.0-Q_BUWlX1BgCD1wo6uo97prlp9VJ4gxAjwN_vZ7nsSjGN";
    path = fetchgit {
      url = "https://codeberg.org/ziglang/translate-c/";
      rev = "57c559cf581b1fcad90494eda219f98abeb155ce";
      hash = "sha256-7OlW2f5tRc1UZySDcEQERsLGChSxIcJAiVWdvuFUvvY=";
    };
  }
  {
    name = "river-0.4.5-_G6Njt6_CwB4aHyFxnYjZq2_hQLBK4iJd4MkvgWF6RZm";
    path = fetchgit {
      url = "https://codeberg.org/river/river";
      rev = "f6d961773711dc29d3eb5b60bd14744a6a33894f";
      hash = "sha256-q4JAlr9/ex+BEgktBmFwOvZzQEAGvxXPD1QyKqyha4g=";
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
    name = "wayland-0.6.0-lQa1kqz8AQADQmdNJsNhLoNHcnEGEUjrOaPV-dtEnEmX";
    path = fetchzip {
      url = "https://codeberg.org/ifreund/zig-wayland/archive/v0.6.0.tar.gz";
      hash = "sha256-3m/ITNhZUJ/5uD/Tqm+0uZSktGoYgWF5oldOqOCUkIE=";
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
    name = "wlroots-0.20.1-jmOlcqNVBAB3uB5oqBTzpRlwu-FmMyyZMVAWCe5kmcSt";
    path = fetchzip {
      url = "https://codeberg.org/ifreund/zig-wlroots/archive/v0.20.1.tar.gz";
      hash = "sha256-cfzHJ2ziiCkMyNlIo6I9o/NjaZGrsv22hq41WYwCnpk=";
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
    name = "libexpat-2.7.1-3-y_akI_s7AABtuMADtwTTJGOxx8iY5ZC9T8EON6cjvbNw";
    path = fetchgit {
      url = "https://github.com/allyourcodebase/libexpat.git";
      rev = "662b7d1cb5f347598d4619d125be317cc2c52b62";
      hash = "sha256-vMLEFTg/usFKqiHw4/rdMSIHtwQSCXdlrydTD/bZ9tQ=";
    };
  }
  {
    name = "libffi-3.5.2_tEtAQ6FwD6zfnc_i2bMJ3JgNr8YkgrBa1A8TWL39GC";
    path = fetchgit {
      url = "https://codeberg.org/vezel/libffi";
      tag = "v3.5.2";
      hash = "sha256-iAcbAeG3xwrd3KjSm2J+/zYzFFTpyXezHShqNmVY50M=";
    };
  }
  {
    name = "libxml2-2.15.1-2-qHdjhmNMAAAiZOWqVridicq2oMf5NHv0n9W41bz9FtMM";
    path = fetchgit {
      url = "https://github.com/allyourcodebase/libxml2.git";
      rev = "2528fad1bf17a0a70999930cfd9280554f547787";
      hash = "sha256-/slP572iNUkZhZanvDbUasDrO6NxL6sy9xN06xPbIWk=";
    };
  }
  {
    name = "N-V-__8AAMX2GwiF4I3vxSUHX70z0UP4G2EwLiT2Q9eNGkwN";
    path = fetchgit {
      url = "https://github.com/libexpat/libexpat";
      rev = "f9a3eeb3e09fbea04b1c451ffc422ab2f1e45744";
      hash = "sha256-fAJgHW3KIe5qtQ0ymRiyB8WBt05bMz8b3+JBibCpzQw=";
    };
  }
  {
    name = "N-V-__8AAPCbSwEcttmGC8VZFtoJxaP06X_upd7O13NMUkIf";
    path = fetchzip {
      url = "https://download.gnome.org/sources/libxml2/2.15/libxml2-2.15.1.tar.xz";
      hash = "sha256-N5eIW5K2UC3nf1cIUIIrbAXmCR86fMEh8ZMpC7Ndbzk=";
    };
  }
  {
    name = "zlib-1.3.1-1-ZZQ7ldENAAA7qJjUXP6E6xnRuV-jDL9dyoJFc_eb3zQ6";
    path = fetchgit {
      url = "https://github.com/allyourcodebase/zlib.git";
      rev = "c5115f4b69ef660f72a835c6638f80508ef284c7";
      hash = "sha256-s6i7skB5UM5Ix3gsFElUYiyYRs1KCFgcSuGv1rftjYU=";
    };
  }
  {
    name = "libiconv-1.18.0-p9sJwWnqAAAAD_T5JHJ8v9OrgUtLGT6ov322zOnkUkv5";
    path = fetchgit {
      url = "https://github.com/allyourcodebase/libiconv.git";
      rev = "d86666233f4e0045b586060260e8a6093f5cdd8d";
      hash = "sha256-sJYOLlNfE6QMSawnoP+TmDOAozbwPWVxAu1+ZVKh4Ig=";
    };
  }
  {
    name = "win_iconv-0.0.10--19NP7MRAAAnmImNeW9llGV-UPmCHV-4MN_FVzNhb-P0";
    path = fetchgit {
      url = "https://github.com/allyourcodebase/win-iconv.git";
      rev = "341e958b33f1cd1142f00a561510d83e6556f1fd";
      hash = "sha256-dkmEW5TOjX5PwqzOw4Rz4p5NKvBfyia6GObaMI1/A0M=";
    };
  }
  {
    name = "N-V-__8AAANWAQBoiCxdwbAmaA0PDpYKI0zfFJ1Woy67Tjh2";
    path = fetchgit {
      url = "https://github.com/win-iconv/win-iconv";
      rev = "82f00fbc1b1156530a0bbd003b93b3942743ed27";
      hash = "sha256-51kfw03/cSZzKLupRBjCElfuYi8Bayn2rnQwGH7zyNc=";
    };
  }
  {
    name = "N-V-__8AAFwJUgGJcIFZ3fj0Q9U_KtvhHdZXlLz1FcAuIcmX";
    path = fetchzip {
      url = "https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.18.tar.gz";
      hash = "sha256-BS84zQYbV0J+E5XEulbj0Th6YoO9079ype/x2IEF21g=";
    };
  }
  {
    name = "N-V-__8AAB0eQwD-0MdOEBmz7intriBReIsIDNlukNVoNu6o";
    path = fetchzip {
      url = "https://github.com/madler/zlib/archive/refs/tags/v1.3.1.tar.gz";
      hash = "sha256-TkPLWSN5QcPlL9D0kc/yhH0/puE9bFND24aj5NVDKYs=";
    };
  }
  {
    name = "N-V-__8AAJHtBwDe4gR5ofaikfFsHj0vPE-uTQSAkqY2uRv_";
    path = fetchgit {
      url = "https://github.com/jiixyj/epoll-shim.git";
      rev = "18159584bb3d17e601b9315a7398ace018251bdc";
      hash = "sha256-9rlhRGFT8LD98fhHbcEhj3mAIyqeQGcxQdyP7u55lck=";
    };
  }
]
