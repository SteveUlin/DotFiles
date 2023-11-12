{ lib, pkgs, ... }:

final: prev: {
  juliamono-nerdfont = pkgs.stdenv.mkDerivation {
    name = "juliamono-nerdfont";
    version = (builtins.parseDrvName pkgs.stdenv.drvPath).version;

    nativeBuildInputs = [ pkgs.nerd-font-patcher pkgs.julia-mono ];

    phases = [ "installPhase" ];

    preInstall = ''
      mkdir -p $out/share/fonts/truetype && cd "$_"
    '';

    installPhase = ''
    runHook preInstall
    find ${pkgs.julia-mono}/share/fonts/truetype \
      -name \*.ttf \
      -exec ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher --complete --quiet --no-progressbars {} \; \
      -exec ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher --complete --use-single-width-glyphs --quiet --adjust-line-height --no-progressbars {} \;
    '';

    meta = with lib; {
      description = "A monospace font for scientific and technical computing";
      homepage = "https://juliamono.netlify.app/";
      license = licenses.ofl;
      maintainers = with maintainers; [ ];
      platforms = platforms.linux;
    };
  };
}
