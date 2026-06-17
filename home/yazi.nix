{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;

    # "y" opens a shell wrapper that cds into yazi's cwd when you quit.
    # Very handy — type `y` instead of `yazi` and your shell follows you.
    shellWrapperName = "y";

    # Extra CLI tools yazi can shell out to
    extraPackages = with pkgs; [
      ffmpegthumbnailer   # video thumbnails
      unar                # archive preview/extraction
      poppler_utils       # PDF preview
      imagemagick         # image conversion / preview fallback
      ripgrep             # file content search (bound to 's' below)
      fd                  # fast find (used internally)
      zoxide              # directory jumping (bound to 'z' below)
      fzf                 # fuzzy finder (bound to 'f' below)
    ];

    # ── yazi.toml ──────────────────────────────────────────────────────────
    settings = {
      manager = {
        ratio         = [ 1 3 4 ];   # left panel : middle : preview
        sort_by       = "natural";
        sort_dir_first = true;
        show_hidden   = false;        # toggle with '.' in the manager
        show_symlink  = true;
      };

      preview = {
        image_filter  = "lanczos3";   # high-quality image downscaling
        image_quality = 85;
        max_width     = 800;
        max_height    = 1200;
      };

      opener = {
        edit = [
          { run = ''nvim "$@"''; block = true; desc = "nvim"; }
        ];
        open = [
          { run = ''xdg-open "$@"''; desc = "open"; }
        ];
        play = [
          { run = ''mpv "$@"''; orphan = true; desc = "mpv"; }
        ];
        extract = [
          { run = ''unar "$1"''; desc = "extract here"; }
        ];
      };

      open = {
        prepend_rules = [
          # Plain text / code → nvim
          { mime = "text/*";             use = [ "edit" "open" ]; }
          { mime = "application/json";   use = [ "edit" "open" ]; }
          # Video / audio → mpv
          { mime = "video/*";            use = [ "play" "open" ]; }
          { mime = "audio/*";            use = [ "play" "open" ]; }
          # Archives → extract
          { mime = "application/zip";    use = [ "extract" "open" ]; }
          { mime = "application/x-tar";  use = [ "extract" "open" ]; }
          { mime = "application/x-bzip2"; use = [ "extract" "open" ]; }
          { mime = "application/x-xz";   use = [ "extract" "open" ]; }
          { mime = "application/x-zstd"; use = [ "extract" "open" ]; }
          # Everything else → xdg-open
          { mime = "*";                  use = [ "open" ]; }
        ];
      };
    };

    # ── keymap.toml ────────────────────────────────────────────────────────
    # prepend_keymap inserts BEFORE defaults so these take priority.
    # All the usual vim motions (hjkl, gg, G, <C-d>, <C-u>, etc.) already
    # work out of the box — we're just adding / tweaking on top.
    keymap = {
      mgr.prepend_keymap = [
        # ── toggle hidden files ──────────────────────────────────────────
        { on = [ "." ]; run = "hidden toggle"; desc = "Toggle hidden files"; }

        # ── open a shell in the current directory ────────────────────────
        { on = [ "!" ]; run = ''shell "$SHELL" --block''; desc = "Open shell here"; }

        # ── search / jump ────────────────────────────────────────────────
        { on = [ "s" ]; run = "plugin fzf";    desc = "Jump via fzf"; }
        { on = [ "z" ]; run = "plugin zoxide"; desc = "Jump via zoxide"; }

        # ── go to common dirs (like vim's gf family) ─────────────────────
        { on = [ "g" "h" ]; run = ''cd --path="~"'';          desc = "Go home"; }
        { on = [ "g" "c" ]; run = ''cd --path="~/.config"'';  desc = "Go ~/.config"; }
        { on = [ "g" "d" ]; run = ''cd --path="~/Downloads"''; desc = "Go Downloads"; }
        { on = [ "g" "D" ]; run = ''cd --path="~/Documents"''; desc = "Go Documents"; }
        { on = [ "g" "p" ]; run = ''cd --path="~/Projects"''; desc = "Go Projects"; }
        { on = [ "g" "t" ]; run = ''cd --path="/tmp"'';       desc = "Go /tmp"; }

        # ── rename without leaving the keyboard ──────────────────────────
        { on = [ "r" ]; run = "rename --cursor=before_ext"; desc = "Rename (cursor before ext)"; }

        # ── copy operations (vim-style yank) ─────────────────────────────
        { on = [ "y" ]; run = "yank";              desc = "Yank (copy)"; }
        { on = [ "Y" ]; run = "unyank";            desc = "Cancel yank"; }
        { on = [ "x" ]; run = "yank --cut";        desc = "Cut"; }

        # ── delete ───────────────────────────────────────────────────────
        # 'd' → trash (recoverable), 'D' → permanent
        { on = [ "d" ]; run = "remove";            desc = "Trash"; }
        { on = [ "D" ]; run = "remove --permanently"; desc = "Delete permanently"; }

        # ── tabs (like vim buffers) ───────────────────────────────────────
        { on = [ "<C-t>" ]; run = "tab_create --current"; desc = "New tab (cwd)"; }
        { on = [ "["     ]; run = "tab_switch --relative=-1"; desc = "Prev tab"; }
        { on = [ "]"     ]; run = "tab_switch --relative=1";  desc = "Next tab"; }

        # ── help ─────────────────────────────────────────────────────────
        { on = [ "?" ]; run = "help"; desc = "Help"; }
      ];
    };
  };
}
