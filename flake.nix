{
  description = "Neovim derivation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";
    gen-luarc.inputs.nixpkgs.follows = "nixpkgs";
    
    oil-nvim = {
      url = "github:stevearc/oil.nvim";
      flake = false;
    };

    kanagawa = {
      url = "github:rebelot/kanagawa.nvim";
      flake = false;
    };

    comment = {
      url = "github:numToStr/Comment.nvim";
      flake = false;
    };

    navigator = {
      url = "github:numToStr/Navigator.nvim";
      flake = false;
    };

    spider = {
      url = "github:chrisgrieser/nvim-spider";
      flake = false;
    };

    nvim-various-textobjs = {
      url = "github:chrisgrieser/nvim-various-textobjs";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    gen-luarc,
    ...
  }: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    # This is where the Neovim derivation is built.
    neovim-overlay = import ./nix/neovim-overlay.nix {inherit inputs;};
  in
    flake-utils.lib.eachSystem supportedSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          # Import the overlay, so that the final Neovim derivation(s) can be accessed via pkgs.<nvim-pkg>
          neovim-overlay
          # This adds a function can be used to generate a .luarc.json
          # containing the Neovim API all plugins in the workspace directory.
          # The generated file can be symlinked in the devShell's shellHook.
          gen-luarc.overlays.default
        ];
      };
      shell = pkgs.mkShell {
        name = "nvim-devShell";
        buildInputs = with pkgs; [
          # Tools for Lua and Nix development, useful for editing files in this repo
          lua-language-server
          nil
          stylua
          luajitPackages.luacheck
        ];
        shellHook = ''
          # symlink the .luarc.json generated in the overlay
          ln -fs ${pkgs.nvim-luarc-json} .luarc.json
        '';
      };
    in {
      packages = rec {
        default = nvim;
        nvim = pkgs.nvim-pkg;
      };
      devShells = {
        default = shell;
      };
    })
    // {
      # You can add this overlay to your NixOS configuration
      overlays.default = neovim-overlay;
    };
}
