#!/usr/bin/env python3

from time import sleep
import sys
from typing import Any, Callable, Dict, List, Optional

import mido

import argparse
import signal

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                      Setup
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


def sigterm_handler(signalnum, stackframe):
    sys.exit(0)


signal.signal(signal.SIGTERM, sigterm_handler)

NOTES = {
    "sharps": ["c", "cis", "d", "dis", "e", "f", "fis", "g", "gis", "a", "ais", "b"],
    "flats": ["c", "des", "d", "ees", "e", "f", "ges", "g", "aes", "a", "bes", "b"],
}

# modify the corresponding elements in `NOTES` to account for specific keys.
# The list indicates the index in the `NOTES` list, as well as what note to
# replace it with.
KEY_NOTES = {"cM": []}

#  Major Keys ------------------------------------------------------------------
KEY_NOTES["fM"] = KEY_NOTES["cM"] + [(10, "bes")]  # 1 flat
KEY_NOTES["besM"] = KEY_NOTES["fM"] + [(3, "ees")]  # 2 flat
KEY_NOTES["eesM"] = KEY_NOTES["besM"] + [(8, "aes")]  # 3 flat
KEY_NOTES["aesM"] = KEY_NOTES["eesM"] + [(1, "des")]  # 4 flat
KEY_NOTES["desM"] = KEY_NOTES["aesM"] + [(6, "ges")]  # 5 flat
KEY_NOTES["gesM"] = KEY_NOTES["desM"] + [(11, "ces")]  # 6 flat
KEY_NOTES["cesM"] = KEY_NOTES["gesM"] + [(4, "fes")]  # 7 flat
KEY_NOTES["gM"] = KEY_NOTES["cM"] + [(6, "fis")]  # 1 sharp
KEY_NOTES["dM"] = KEY_NOTES["gM"] + [(1, "cis")]  # 2 sharp
KEY_NOTES["aM"] = KEY_NOTES["dM"] + [(8, "gis")]  # 3 sharp
KEY_NOTES["eM"] = KEY_NOTES["aM"] + [(3, "dis")]  # 4 sharp
KEY_NOTES["bM"] = KEY_NOTES["eM"] + [(10, "ais")]  # 5 sharp
KEY_NOTES["fisM"] = KEY_NOTES["bM"] + [(5, "eis")]  # 6 sharp
KEY_NOTES["cisM"] = KEY_NOTES["fisM"] + [(0, "bis")]  # 7 sharp

#  Harnomic Minor Keys ---------------------------------------------------------
KEY_NOTES["dm"] = KEY_NOTES["fM"] + [(1, "cis")]  # 1 flat
KEY_NOTES["gm"] = KEY_NOTES["besM"] + [(6, "fis")]  # 2 flat
KEY_NOTES["cm"] = KEY_NOTES["eesM"] + [(11, "b")]  # 3 flat
KEY_NOTES["fm"] = KEY_NOTES["aesM"] + [(4, "e")]  # 4 flat
KEY_NOTES["besm"] = KEY_NOTES["desM"] + [(9, "a")]  # 5 flat
KEY_NOTES["eesm"] = KEY_NOTES["gesM"] + [(2, "d")]  # 6 flat
KEY_NOTES["aesm"] = KEY_NOTES["cesM"] + [(7, "g")]  # 7 flat
KEY_NOTES["am"] = KEY_NOTES["cM"] + [(8, "gis")]
KEY_NOTES["em"] = KEY_NOTES["gM"] + [(3, "dis")]  # 1 sharp
KEY_NOTES["bm"] = KEY_NOTES["dM"] + [(10, "ais")]  # 2 sharp
KEY_NOTES["fism"] = KEY_NOTES["aM"] + [(5, "eis")]  # 3 sharp
KEY_NOTES["cism"] = KEY_NOTES["eM"] + [(0, "bis")]  # 4 sharp
KEY_NOTES["gism"] = KEY_NOTES["bM"] + [(7, "fisis")]  # 5 sharp
KEY_NOTES["dism"] = KEY_NOTES["fisM"] + [(2, "cisis")]  # 6 sharp
KEY_NOTES["aism"] = KEY_NOTES["cisM"] + [(9, "gisis")]  # 7 sharp

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                             Command Line Arguments
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

parser = argparse.ArgumentParser()

parser.add_argument(
    "-d",
    "--device",
    help="Specify MIDI device to be used. Check --list-devices.",
    type=str,
)
parser.add_argument(
    "-m",
    "--mode",
    help="Specify mode to be used. Either 'single', 'chord' or 'pedal'.",
    choices=["single", "chord", "pedal"],
    default="single",
)
parser.add_argument(
    "-k",
    "--key-signature",
    help="Specify key signature to be used.",
    choices=KEY_NOTES.keys(),
    default='cM',
)
parser.add_argument(
    "-a",
    "--accidentals",
    help="Specify accidentals to be used for out-of-key notes black keys.",
    choices=NOTES.keys(),
    default="sharps",
)
parser.add_argument(
    "--alterations",
    help="Specify custom alterations for interpreting notes; this will overwrite key signature alterations. Expects list of tuples, where the first element is a number corresponding to the key (C is 0, C# is 1, D is 2, ..., A# is 10, B is 11), and the second element is the lilypond note to be placed instead. For example to make a D be interpreted as a E-flat-flat you can pass `(2,'eeses')`. To additionally have a A be interpreted as a G-sharp-sharp you can pass `(2,'eeses'),(9,'gisis')`",
)
parser.add_argument(
    "-l",
    "--list-devices",
    help="List available MIDI devices",
    action="store_true",
)

args = parser.parse_args()

# change NOTES depending on given key signature
for index, note in KEY_NOTES[args.key_signature]:
    for variant in NOTES:
        NOTES[variant][index] = note
# change NOTES with the custom alterations
if args.alterations:
    import ast
    alterations = ast.literal_eval(args.alterations)
    for index, note in alterations:
        for variant in NOTES:
            NOTES[variant][index] = note


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                     Helpers
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


def list_devices():
    inputs: List[str] = mido.get_input_names()
    print(f"Found {len(inputs)} devices:")
    for input in inputs:
        print(f"\t{input}")


def note2Letter(note, accidentals):
    """Retrieve Lilypond equivalent note from `note` (without pitch)"""
    return NOTES[accidentals][note % 12]


def note2AbsPitchLiliypond(note):
    """Retrieve absolute pitch from `note`"""
    pitch = (note // 12) - 4
    if pitch > 0:
        return "'" * pitch
    elif pitch < 0:
        return "," * -pitch
    else:
        return ""


def note2Lilypond(note, accidentals):
    """Retrieve Lilypond equivalent note from `note`"""
    return note2Letter(note, accidentals) + note2AbsPitchLiliypond(note)


def clearPort(port):
    """This function clears all pending messages from the port.

    If the port is not emtpy upon starting this application, then there may be
    issues. This function is supposed to empty the port. If it turns out that
    the port is not emtpy at the end of this function call, please consult the
    following in an attempt to fix it.

    In case something is not working:
    - Sleeping ...

        Note that we are using the `sleep()` function after reading new
        information from the port. This is necessary, as otherwise the pending
        messages will not appear one after another -- which seems to make it
        very difficult and inefficient to figure out if there are still pending
        messages left.

        To avoid spending a lot of time waiting for this function to finish, we
        set the sleep timer to as low as possible. It might be that the timer is
        set too low in which case `sleep` has no effect and the messages will
        not appear one after the other. Try putting a little larger value in the
        timer until it works.

        If you reach a point where the timer has a big value like 0.01 then the
        issue is probably not caused by the `sleep` (see next section)

    - Skipping ...

        You will see in the code that we are skipping the first `None` value
        that is obtained. Through experimentation we found out that the first
        value yielded in this manner is always `None`. Only after the first
        `None` are we getting the pending messages.

        If this function does not clear all pending messages, try inspecting the
        output of the port by running the following code as the while loop:

                        while True:
                            a = port.receive(block=False)
                            print(a)
                            sleep(.001)

        This way you can see when your pending messages are appearing, in which
        case you can modify the if conditions to correctly skip the `None`
        values that don't indicated an emptied port.

        Small note:
            By calling `port.receive(block=False)` the program will not wait for
            the next midi input but will instead return `None` if nothing is
            pressed.  This way we know that no pending messages remain if the
            program keeps returning `None`.
    """
    count = 0
    while True:
        a = port.receive(block=False)
        sleep(0.001)
        if a is None:
            if count == 0:
                #  the first msg always seems to be None
                #  we need to ignore it in case notes follow
                count += 1
                continue
            else:
                #  port is clear if message is None
                break
    print("If there is an issue at startup,")
    print("consult help page for `clearPort()`")
    print("--------------------------------------------")


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                Process MIDI Data
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


def getMixedMode(
    port,
    accidentals,
    triggerChordMode: Callable[[mido.Message, Dict[str, Any]], bool],
):
    """Get single notes and, when `triggerChordMode` indicates, get chords.

    In chord mode: Get pressed notes as a chord once everything is released.

    In single mode: Get pressed notes one after another.

    The `triggerChordMode` function should return a boolean indicating whether
    chord mode should be used or not. The additional dictionary can be used to
    pass information about the environment into the function, in case the
    decision is not a simple 'always on' or 'always off'. Check
    `triggerChordModePedal()` as an example.
    """
    # track notes to be put into chord
    notes = set()
    # track notes being pressed to know when everything was released
    pressed = set()
    # track pedals being pressed to know when everything was released
    pedals = set()
    # specify whether to use chords or not
    use_chords = False
    for msg in port:
        use_chords = triggerChordMode(msg, {"pedals": pedals})
        if msg.type == "note_on":
            pressed.add(msg.note)
            notes.add(msg.note)
        elif msg.type == "note_off":
            pressed.remove(msg.note)
            if not use_chords:
                notes.remove(msg.note)
        if use_chords:
            if len(pressed) == 0:
                if len(notes) > 1:
                    note_list = list(notes)
                    note_list.sort()
                    print(
                        "<{}>".format(
                            " ".join(
                                [note2Lilypond(note, accidentals) for note in note_list]
                            )
                        )
                    )
                if len(notes) == 1:
                    print(note2Lilypond(msg.note, accidentals))
                notes = set()
        else:
            if msg.type == "note_on":
                print(note2Lilypond(msg.note, accidentals))


def triggerChordModePedal(msg, data) -> bool:
    """Trigger chord mode if any pedal is currently held down."""
    assert data is not None
    pedals = data["pedals"]  # set is passed by reference
    if msg.is_cc() and msg.control in [64, 66, 67]:
        # 64: sustain pedal
        # 66: sustenuto pedal
        # 67: damper pedal
        if msg.value > 0:
            pedals.add(msg.control)
        if msg.value == 0:
            pedals.remove(msg.control)
    # ensure all pedals are released before exiting chord mode
    return len(pedals) > 0


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                        Tidy wrappers to call everything
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


def getMidiData(port, mode="single", accidentals="sharps"):
    """Get midi data from `port` and interpret using `mode`

    Argument: mode [String]
        - 'single'
            Notes are yielded as you press the keys on you midi keyboard.
            This results in one note at a time.
        - 'chord'
            Notes are yielded as chords. When you hold down multiple keys,
            the chord it returned as soon as you release all keys.
    """
    if mode == "single":
        getMixedMode(port, accidentals, lambda m, d: False)
    elif mode == "chord":
        getMixedMode(port, accidentals, lambda m, d: True)
    elif mode == "pedal":
        getMixedMode(port, accidentals, triggerChordModePedal)
    else:
        print("Invalid mode. Check '--mode' in '--help.", file=sys.stderr)
        exit(2)


def main(device: str, mode: str):
    with mido.open_input(name=device) as port:
        clearPort(port)
        getMidiData(port, mode, args.accidentals)


if __name__ == "__main__":
    if args.list_devices:
        list_devices()
        exit(0)
    if args.device is None:
        print(
            "Device must be specified. Check '--device' in '--help'.", file=sys.stderr
        )
        exit(1)
    if args.key_signature is None:
        print("Key signature must be specified. Check '--help'.", file=sys.stderr)
        exit(1)
    main(args.device, args.mode)
