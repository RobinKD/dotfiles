{ config, lib, pkgs, ... }:

let cfg = config.hm-modules.dunst;
in with lib; {
  options.hm-modules.dunst = { enable = mkEnableOption "dunst"; };

  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          follow = "mouse";

          ### Geometry ###

          # dynamic width from 0 to 300
          # width = (0, 300)
          # constant width of 300
          width = "(0, 300)";

          # The maximum height of a single notification, excluding the frame.
          height = 300;

          # Position the notification in the top right corner
          origin = "top-right";

          # Offset from the origin
          offset = "25x50";

          # Scale factor. It is auto-detected if value is 0.
          scale = 0;

          # Maximum number of notification (0 means no limit)
          notification_limit = 10;

          ### Progress bar ###

          # Turn on the progess bar. It appears when a progress hint is passed with
          # for example dunstify -h int:value:12
          progress_bar = true;

          # Set the progress bar height. This includes the frame, so make sure
          # it's at least twice as big as the frame width.
          progress_bar_height = 10;

          # Set the frame width of the progress bar
          progress_bar_frame_width = 1;

          # Set the minimum width for the progress bar
          progress_bar_min_width = 150;

          # Set the maximum width for the progress bar
          progress_bar_max_width = 300;

          # Corner radius for the progress bar. 0 disables rounded corners.
          progress_bar_corner_radius = 0;

          # Corner radius for the icon image.
          icon_corner_radius = 0;

          # Show how many messages are currently hidden (because of
          # notification_limit).
          indicate_hidden = "yes";

          # The transparency of the window.  Range: [0; 100].
          # This option will only work if a compositing window manager is
          # present (e.g. xcompmgr, compiz, etc.). (X11 only)
          transparency = 0;

          # Draw a line of "separator_height" pixel height between two
          # notifications.
          # Set to 0 to disable.
          # If gap_size is greater than 0, this setting will be ignored.
          separator_height = 2;

          # Padding between text and separator.
          padding = 8;

          # Horizontal padding.
          horizontal_padding = 8;

          # Padding between text and icon.
          text_icon_padding = 2;

          # Defines width in pixels of frame around the notification window.
          # Set to 0 to disable.
          frame_width = 3;

          # Defines color of the frame around the notification window.
          frame_color = "#8CAAEE";

          # Define a color for the separator.
          # possible values are:
          #  * auto: dunst tries to find a color fitting to the background;
          #  * foreground: use the same color as the foreground;
          #  * frame: use the same color as the frame;
          #  * anything else will be interpreted as a X color.
          separator_color = "frame";

          # Sort messages by urgency.
          sort = "yes";

          # Don't remove messages, if the user is idle (no mouse or keyboard input)
          # for longer than idle_threshold seconds.
          # Set to 0 to disable.
          # A client can set the 'transient' hint to bypass this. See the rules
          # section for how to disable this if necessary
          idle_threshold = 120;

          ### Text ###

          font = "Droid Sans 9";

          # Possible values are:
          # full: Allow a small subset of html markup in notifications:
          #        <b>bold</b>
          #        <i>italic</i>
          #        <s>strikethrough</s>
          #        <u>underline</u>
          #
          #        For a complete reference see
          #        <https://docs.gtk.org/Pango/pango_markup.html>.
          #
          # strip: This setting is provided for compatibility with some broken
          #        clients that send markup even though it's not enabled on the
          #        server. Dunst will try to strip the markup but the parsing is
          #        simplistic so using this option outside of matching rules for
          #        specific applications *IS GREATLY DISCOURAGED*.
          #
          # no:    Disable markup parsing, incoming notifications will be treated as
          #        plain text. Dunst will not advertise that it has the body-markup
          #        capability if this is set as a global setting.
          #
          # It's important to note that markup inside the format option will be parsed
          # regardless of what this is set to.
          markup = "full";

          # The format of the message.  Possible variables are:
          #   %a  appname
          #   %s  summary
          #   %b  body
          #   %i  iconname (including its path)
          #   %I  iconname (without its path)
          #   %p  progress value if set ([  0%] to [100%]) or nothing
          #   %n  progress value if set without any extra characters
          #   %%  Literal %
          # Markup is allowed
          format = ''
            <b>%a</b>
            %s'';

          # Alignment of message text.
          # Possible values are "left", "center" and "right".
          alignment = "left";

          # Vertical alignment of message text and icon.
          # Possible values are "top", "center" and "bottom".
          vertical_alignment = "center";

          # Show age of message if message is older than show_age_threshold
          # seconds.
          # Set to -1 to disable.
          show_age_threshold = 60;

          # Specify where to make an ellipsis in long lines.
          # Possible values are "start", "middle" and "end".
          ellipsize = "end";

          # Ignore newlines '\n' in notifications.
          ignore_newline = "no";

          # Stack together notifications with the same content
          stack_duplicates = true;

          # Hide the count of stacked notifications with the same content
          hide_duplicate_count = false;

          # Display indicators for URLs (U) and actions (A).
          show_indicators = "yes";

          # TODO Icons

          ### History ###

          # Should a notification popped up from history be sticky or timeout
          # as if it would normally do.
          sticky_history = "yes";

          # Maximum amount of notifications kept in history
          history_length = 20;

          ### mouse

          # Defines list of actions for each mouse event
          # Possible values are:
          # * none: Don't do anything.
          # * do_action: Invoke the action determined by the action_name rule. If there is no
          #              such action, open the context menu.
          # * open_url: If the notification has exactly one url, open it. If there are multiple
          #             ones, open the context menu.
          # * close_current: Close current notification.
          # * close_all: Close all notifications.
          # * context: Open context menu for the notification.
          # * context_all: Open context menu for all notifications.
          # These values can be strung together for each mouse event, and
          # will be executed in sequence.
        };
      };
    };
  };
}
