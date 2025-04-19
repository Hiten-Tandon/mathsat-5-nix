{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {nixpkgs, flake-utils, ...}: flake-utils.lib.eachSystem ["x86_64-linux" "aarch64-linux" "aarch64-darwin"]  (system: 
    with import nixpkgs {inherit system;};
    let
        pname = "MathSAT";
        version = "5.6.11";
        url = if stdenv.isLinux && stdenv.isx86_64 then "https://mathsat.fbk.eu/release/mathsat-5.6.11-linux-x86_64-reentrant.tar.gz" 
              else if stdenv.isLinux && stdenv.isAarch64 then "https://mathsat.fbk.eu/release/mathsat-5.6.11-linux-aarch64-reentrant.tar.gz" 
              else "https://mathsat.fbk.eu/release/mathsat-5.6.11-osx.tar.gz";
        sha256 = if stdenv.isLinux && stdenv.isx86_64 then "1f44klj240qa71cd00lxwv67ryrrx8saydm0zsz6zdnn6fnz0j1r" 
                 else if stdenv.isLinux && stdenv.isAarch64 then "1b7c1wg05870kz4f9r8sfmqsrhxv1qwmajb7gjvsy8bdzlh5h567"
                 else "1a8c8mkjjp0as470yj8yl9nzz040ja7grx40ykxip1hh2f8yn6n3";
    in
    {
      packages.default = stdenv.mkDerivation (finalAttrs: {
        inherit pname version;
      
        src = fetchTarball {
          inherit url sha256;
        };

        installPhase = ''
          cp -r $src $out
          chmod +w $out
          chmod +w $out/examples -R
          rm -rf $out/examples
          chmod -w $out
        '';

     
        meta = {
          description = "An SMT Solver for Formal Verification & More";
          homepage = "https://mathsat.fbk.eu";
          license = {
            shortName = "MathSAT5-noncommercial";
            fullName = "MathSAT5 Research and Evaluation License";
            free = false;
            url = "https://mathsat.fbk.eu/download.html";
          };
        };
      });

      formatter = nixfmt-classic;
  });
}
