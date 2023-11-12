{ config, lib, pkgs, ... }:
with lib;
let cfg = config.programs.ulins.emacs;
in {
  options.programs.ulins.emacs = { enable = mkEnableOption "Enable Emacs"; };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # 28.2 + native-comp
      ((emacsPackagesFor emacs-unstable).emacsWithPackages
        (epkgs: [ epkgs.vterm epkgs.pdf-tools ]))
      ## Doom dependencies
      git
      (ripgrep.override { withPCRE2 = true; })
      gnutls # for TLS connectivity

      ## Optional dependencies
      fd # faster projectile indexing
      imagemagick # for image-dired
      zstd # for undo-fu-session/undo-tree compression
      shellcheck
      nixfmt
      graphviz
      cmake
      gnumake
      nodejs_20 # copilot
      ## Module dependencies
      # :checkers spell
      (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
      # :tools editorconfig
      editorconfig-core-c # per-project style config
      # :tools lookup & :lang org +roam
      sqlite
      # :lang latex & :lang org (latex previews)
      texlive.combined.scheme-medium
      jupyter
    ];
  };
}
