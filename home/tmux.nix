{ pkgs, accent, ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    clock24 = true;
    historyLimit = 100004;

    extraConfig = ''
      set -g status-interval   5
      set -g status-keys       vi
      
      set -g focus-events      off
      setw -g aggressive-resize off
      
      set -as terminal-features ",xterm-256color:RGB"
      set -g renumber-windows on
      
      # create new.. everything in current pwd
      bind c new-window -c "#{pane_current_path}"
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      
      # window navigation
      bind -n S-Left previous-window
      bind -n S-Right next-window
      
      # binds for reordering windows
      bind -n C-S-Left swap-window -t -1\; select-window -t -1
      bind -n C-S-Right swap-window -t +1\; select-window -t +1
      
      # COLOR CONFIGS
      %hidden ACCENT="${accent}"
      %hidden GREY="#b6b8bb"
      %hidden DARK="#0c0c0c"
      
      set -g mode-style "fg=$DARK,bg=$GREY"
      set -g message-style "fg=$DARK,bg=$GREY"
      set -g message-command-style "fg=$DARK,bg=$GREY"
      set -g pane-border-style "fg=$GREY"
      
      # Uses global accent
      set -g pane-active-border-style "fg=$ACCENT"
      
      set -g status "on"
      set -g status-justify "left"
      set -g status-style "fg=$GREY,bg=default"
      set -g status-left-length "100"
      set -g status-right-length "100"
      set -g status-left-style NONE
      set -g status-right-style NONE
      
      #popup
      # Outside popup → open it
      bind g if-shell '[ "$(tmux display-message -p "#S")" = "popup" ]' \
        'detach-client' \
        'display-popup -E -w 70% -h 60% "tmux new-session -A -s popup"'
      
      # Status Left: Session name in Accent Color
      set -g status-left "#[fg=$DARK,bg=$ACCENT,bold] #S #[fg=$ACCENT,bg=default,nobold,nounderscore,noitalics]"
      
      # Status Right: Hostname in Accent Color
      set -g status-right "#[fg=$ACCENT,bg=default]#[fg=$ACCENT,bg=$ACCENT]#{prefix_highlight}#[fg=$DARK,bg=$ACCENT,bold] #h "
      
      setw -g window-status-activity-style "underscore,fg=#7b7c7e,bg=default"
      setw -g window-status-separator ""
      setw -g window-status-style "NONE,fg=#7b7c7e,bg=default"
      
      # Inactive windows
      setw -g window-status-format "#[fg=#7b7c7e,bg=default]  #I  #W #F  "
      
      setw -g window-status-current-format "#[fg=$GREY,bg=default]#[fg=$DARK,bg=$GREY,bold] #I  #W #F #[fg=$GREY,bg=default,nobold,nounderscore,noitalics]"
    '';
  };
}
