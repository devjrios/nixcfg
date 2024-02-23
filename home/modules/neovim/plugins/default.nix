{
  imports = [
    ./barbar.nix
    ./comment.nix
    ./efm.nix
    ./lsp.nix
    ./lualine.nix
    ./markdown-preview.nix
    ./startify.nix
    ./telescope.nix
    ./treesitter.nix
    ./vimtex.nix
  ];

  programs.nixvim = {
    colorschemes.gruvbox.enable = true;

    plugins = {
      gitsigns = {
        enable = true;
        signs = {
          add.text = "+";
          change.text = "~";
        };
      };

      nvim-autopairs.enable = true;

      nvim-colorizer = {
        enable = true;
        userDefaultOptions.names = false;
      };

      oil.enable = true;
    };
  };
}
