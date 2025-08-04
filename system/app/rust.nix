{ pkgs, ... }:
let
  rust-toolchain = pkgs.rust-bin.stable.latest.rust.override {
    extensions = [ "rust-src" "rust-analyzer" ];
  };
in {
  environment.systemPackages = with pkgs; [
    rust-toolchain
    cargo
    rustfmt
    clippy
    pkg-config
    openssl
    glibc

    # Development libraries for Rust and other languages
    libsoup_3
    gtk4
    glib
    cairo
    pango
    gdk-pixbuf
    atk
  ];

  # Set up development environment
  environment.variables = {
    RUST_SRC_PATH = "${rust-toolchain}/lib/rustlib/src/rust/library";
    PKG_CONFIG_PATH =
      "${pkgs.libsoup_3.dev}/lib/pkgconfig:${pkgs.gtk4.dev}/lib/pkgconfig:${pkgs.glib.dev}/lib/pkgconfig";
  };
}
