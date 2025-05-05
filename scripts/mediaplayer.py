## NOT MADE BY ME // https://github.com/HyDE-Project/HyDE/blob/master/Configs/.local/lib/hyde/mediaplayer.py

#!/usr/bin/env python3
import os
import gi

gi.require_version("Playerctl", "2.0")
from gi.repository import Playerctl, GLib  # noqa: E402
import argparse  # noqa: E402
import logging  # noqa: E402
import sys  # noqa: E402
import signal  # noqa: E402
import json  # noqa: E402

#
# Global dictionary to store the track, artist, and total duration
# for each player.  Key = player_name
#
players_data = {}

MAX_TITLE_LENGTH = 64


def load_env_file(filepath: str) -> None:
    """
    Load environment variables from filepath.
    Each line should be in the format KEY=VALUE.
    Lines starting with '#' are ignored.
    """
    try:
        with open(filepath, encoding="utf-8") as f:
            for line in f:
                if line.strip() and not line.startswith("#"):
                    if line.startswith("export "):
                        line = line[len("export ") :]
                    key, value = line.strip().split("=", 1)
                    os.environ[key] = value.strip('"')
    except (FileNotFoundError, OSError) as e:
        print(f"Error loading environment file {filepath}: {e}")


def format_time(seconds) -> str:
    """
    Convert seconds into mm:ss format.
    """
    m = int(seconds // 60)
    s = int(seconds % 60)
    return f"{m:02d}:{s:02d}"


def create_tooltip_text(
    artist, track, current_position_seconds, duration_seconds
) -> str:
    """
    Build the tooltip text showing artist, track, and current position vs duration.
    Use Pango markup to style the artist as italic and the track as bold.
    """
    tooltip = ""

    if artist or track:
        tooltip += f'<span foreground="{track_color}"><b>{track}</b></span>\n<span foreground="{artist_color}"><i>{artist}</i></span>\n'
        if duration_seconds > 0:
            progress = int((current_position_seconds / duration_seconds) * 20)
            bar = f'<span foreground="{progress_color}">{"━" * progress}</span><span foreground="{empty_color}">{"─" * (20 - progress)}</span>'
            tooltip += f'<span foreground="{time_color}">{format_time(current_position_seconds)}</span> {bar} <span foreground="{time_color}">{format_time(duration_seconds)}</span>'

    return tooltip


def write_output(track, artist, playing, player, tooltip_text):
    print("Writing output")

    # Use the appropriate prefix based on playback status
    prefix = prefix_playing if playing else prefix_paused
    max_length = max_length_module

    # Escape ampersands in artist and track for Pango markup
    escaped_artist = artist.replace("&", "&amp;")
    escaped_track = track.replace("&", "&amp;")

    # Calculate the total length and truncate track if necessary
    total_length = len(escaped_track) + len(escaped_artist)
    if total_length > max_length:
        available_length = max(0, max_length - len(escaped_artist))
        escaped_track = (
            f"{escaped_track[:available_length - 1]}…"
            if len(escaped_track) > available_length and available_length > 0
            else escaped_track[:available_length]
        )
    elif len(escaped_track) > MAX_TITLE_LENGTH:
        escaped_track = f"{escaped_track[:MAX_TITLE_LENGTH-1]}…"

    # Generate the "text" based on the presence of track and artist
    if escaped_track and not escaped_artist:
        output_text = f"{prefix} <b>{escaped_track}</b>"
    elif escaped_track and escaped_artist:
        output_text = f"{prefix} {escaped_artist}  <b>{escaped_track}</b>"
    else:
        output_text = "<b>Nothing playing</b>"

    output_data = {
        "text": output_text,
        "class": "custom-" + player.props.player_name,
        "alt": player.props.player_name,
        "tooltip": tooltip_text,
    }

    sys.stdout.write(json.dumps(output_data) + "\n")
    sys.stdout.flush()


def on_play(player, status, manager):
    print("Received new playback status")
    on_metadata(player, player.props.metadata, manager)


def on_metadata(player, metadata, manager):
    """
    Called whenever the metadata changes (new track, etc.).
    We extract track, artist, total duration, store them in players_data,
    and immediately write the output once so it refreshes promptly.
    """
    print("Received new metadata")

    # Grab track and artist
    full_track = player.get_title() or ""
    full_artist = player.get_artist() or ""
    track, artist = full_track, full_artist

    # Playback state
    playing = player.props.status == "Playing"

    # Duration and position
    length_microseconds = metadata["mpris:length"]
    duration_seconds = length_microseconds / 1e6
    current_position_seconds = player.get_position() / 1e6

    # Store relevant info so our timer callback can update the position every second
    players_data[player.props.player_name] = {
        "track": track,
        "artist": artist,
        "duration": duration_seconds,
    }

    # Build the tooltip
    tooltip_text = create_tooltip_text(
        artist, track, current_position_seconds, duration_seconds
    )
    write_output(track, artist, playing, player, tooltip_text)


def on_player_appeared(manager, player, selected_player=None):
    if player is not None and (
        selected_player is None or player.name == selected_player
    ):
        init_player(manager, player)
    else:
        print("New player appeared, but it's not the selected player, skipping")


def on_player_vanished(manager, player, loop):
    print("Player has vanished")

    # Remove from our stored dictionary
    p_name = player.props.player_name
    if p_name in players_data:
        del players_data[p_name]

    # Output "standby" text
    output = {
        "text": standby_text,
        "class": "custom-nothing-playing",
        "alt": "player-closed",
        "tooltip": "",
    }

    sys.stdout.write(json.dumps(output) + "\n")
    sys.stdout.flush()


def init_player(manager, name):
    print("Initialize player: {player}".format(player=name.name))
    player = Playerctl.Player.new_from_name(name)
    player.connect("playback-status", on_play, manager)
    player.connect("metadata", on_metadata, manager)
    manager.manage_player(player)
    on_metadata(player, player.props.metadata, manager)


def update_positions(manager):
    """
    This is the callback run once every second.
    It loops over each known player, reads its current position,
    updates the tooltip, and rewrites the output to stdout.
    """
    # manager.props.players gives us the current active Player objects
    for player in manager.props.players:
        p_name = player.props.player_name
        # If we haven't stored metadata for this player yet, skip
        if p_name not in players_data:
            continue

        playing = player.props.status == "Playing"
        track = players_data[p_name]["track"]
        artist = players_data[p_name]["artist"]
        duration_seconds = players_data[p_name]["duration"]

        current_position_seconds = player.get_position() / 1e6
        tooltip_text = create_tooltip_text(
            artist, track, current_position_seconds, duration_seconds
        )

        write_output(track, artist, playing, player, tooltip_text)

    # Return True so the timer continues calling this function
    return True


def signal_handler(sig, frame):
    print("Received signal to stop, exiting")
    sys.stdout.write("\n")
    sys.stdout.flush()
    sys.exit(0)


def parse_arguments():
    """
    The options for prefix/paused/max_length/standby_text are loaded from env variables.
    """
    parser = argparse.ArgumentParser(
        description="A media player status tool with customizable display options."
    )

    # Define for which player we're listening
    parser.add_argument("--player", help="Specify the player to listen to.")

    return parser.parse_args()


def main():
    global prefix_playing, prefix_paused, max_length_module, standby_text
    global artist_color, track_color, progress_color, empty_color, time_color

    # Load environment variables from your config file:
    # config_file = os.path.join(xdg_state_home(), "hyde", "config")
    # colors_file = os.path.join(xdg_cache_home(), "hyde/wall.dcol")
    # if os.path.exists(config_file):
    #     load_env_file(config_file)
    # if os.path.exists(colors_file):
    #     load_env_file(colors_file)

    # Pull values from environment variables
    # You can configure these in ~/.config/hyde/config.toml
    prefix_playing = os.getenv("MEDIAPLAYER_PREFIX_PLAYING", "")
    prefix_paused = os.getenv("MEDIAPLAYER_PREFIX_PAUSED", "")
    max_length_module = int(os.getenv("MEDIAPLAYER_MAX_LENGTH", "70"))
    standby_text = os.getenv("MEDIAPLAYER_STANDBY_TEXT", " Music")

    # Initialize tooltip colors
    artist_color = os.getenv(
        "MEDIAPLAYER_TOOLTIP_ARTIST_COLOR", "#" + os.getenv("dcol_3xa8", "052F4A")
    )
    track_color = os.getenv(
        "MEDIAPLAYER_TOOLTIP_TRACK_COLOR", "#" + os.getenv("dcol_txt1", "00598A")
    )
    progress_color = os.getenv(
        "MEDIAPLAYER_TOOLTIP_PROGRESS_COLOR", "#" + os.getenv("dcol_pry4", "00BC7D")
    )
    empty_color = os.getenv(
        "MEDIAPLAYER_TOOLTIP_EMPTY_COLOR", "#" + os.getenv("dcol_1xa3", "0B4F4A")
    )
    time_color = os.getenv(
        "MEDIAPLAYER_TOOLTIP_TIME_COLOR", "#" + os.getenv("dcol_txt1", "00BC7D")
    )

    arguments = parse_arguments()
    player_found = False

    # Initialize logging
    logging.basicConfig(
        stream=sys.stdout,
        level=logging.DEBUG,
        format="%(name)s %(levelname)s %(message)s",
    )

    print("Arguments received {}".format(vars(arguments)))

    manager = Playerctl.PlayerManager()
    loop = GLib.MainLoop()

    manager.connect(
        "name-appeared", lambda *args: on_player_appeared(*args, arguments.player)
    )
    manager.connect("player-vanished", lambda *args: on_player_vanished(*args, loop))

    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)
    signal.signal(signal.SIGPIPE, signal.SIG_DFL)

    for player in manager.props.player_names:
        if arguments.player is not None and arguments.player != player.name:
            print(
                "{player} is not the filtered player, skipping it".format(
                    player=player.name
                )
            )
            continue

        init_player(manager, player)
        player_found = True

    # If no player is found, generate the standby output
    if not player_found:
        output = {
            "text": standby_text,
            "class": "custom-nothing-playing",
            "alt": "player-closed",
            "tooltip": "",
        }

        sys.stdout.write(json.dumps(output) + "\n")
        sys.stdout.flush()

    # Set up a single 1-second timer to update song position
    GLib.timeout_add_seconds(1, update_positions, manager)

    loop.run()


if __name__ == "__main__":
    main()
