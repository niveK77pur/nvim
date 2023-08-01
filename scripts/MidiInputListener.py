#!/usr/bin/env python3

from time import sleep
import sys
import signal
from typing import List

import mido

import argparse

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
    help="Specify mode to be used. Either 'linear' or 'chord'.",
    choices=["linear", "chord", "mixed"],
    default="linear",
)
parser.add_argument(
    "-l",
    "--list-devices",
    help="List available MIDI devices",
    action="store_true",
)

args = parser.parse_args()

INPUT_DEVICE = "USB-MIDI:USB-MIDI MIDI 1 24:0"

NOTES = {
    "sharps": ["c", "cis", "d", "dis", "e", "f", "fis", "g", "gis", "a", "ais", "b"],
    "flats": ["c", "des", "d", "ees", "e", "f", "ges", "g", "aes", "a", "bes", "b"],
}


def sigterm_handler(signalnum, stackframe):
    sys.exit(0)


signal.signal(signal.SIGTERM, sigterm_handler)


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


def getLinearMode(port, accidentals):
    """Get pressed notes one after another"""
    for msg in port:
        if msg.type == "note_on":
            print(note2Lilypond(msg.note, accidentals))


def getChordMode(port, accidentals):
    """Get pressed notes as a chord once everything is released"""
    # track notes to be put into chord
    notes = set()
    # track notes being pressed to know when everything was released
    pressed = set()
    for msg in port:
        # if msg.type in ["note_on", "note_off"]:
        if msg.type == "note_on":
            pressed.add(msg.note)
            notes.add(msg.note)
        if msg.type == "note_off":
            pressed.remove(msg.note)
            if len(pressed) == 0:
                if len(notes) > 1:
                    note_list = list(notes)
                    note_list.sort()
                    print(
                        "<{}>".format(
                            " ".join(
                                map(
                                    note2Lilypond,
                                    note_list,
                                    [accidentals] * len(notes),
                                )
                            )
                        )
                    )
                if len(notes) == 1:
                    print(
                        "{}".format("".join(map(note2Lilypond, notes, [accidentals])))
                    )
                notes = set()


def getMixedMode(port, accidentals):
    """Get single notes and, when pedal is pressed, get chords."""
    # track notes to be put into chord
    notes = set()
    # track notes being pressed to know when everything was released
    pressed = set()
    # track pedals being pressed to know when everything was released
    pedals = set()
    # specify whether to use chords or not
    use_chords = False
    for msg in port:
        if msg.is_cc() and msg.control in [64, 66, 67]:
            # 64: sustain pedal
            # 66: sustenuto pedal
            # 67: damper pedal
            if msg.value > 0:
                pedals.add(msg.control)
            if msg.value == 0:
                pedals.remove(msg.control)
            # ensure all pedals are released before exiting chord mode
            use_chords = len(pedals) > 0
        elif msg.type == "note_on":
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


def getMidiData(port, mode="linear", accidentals="sharps"):
    """Get midi data from `port` and interpret using `mode`

    Argument: mode [String]
        - 'linear'
            Notes are yielded as you press the keys on you midi keyboard.
            This results in one note at a time.
        - 'chord'
            Notes are yielded as chords. When you hold down multiple keys,
            the chord it returned as soon as you release all keys.
    """
    if mode == "linear":
        getLinearMode(port, accidentals)
    elif mode == "chord":
        getChordMode(port, accidentals)
    elif mode == "mixed":
        getMixedMode(port, accidentals)
    else:
        print("Invalid mode. Check '--mode' in '--help.", file=sys.stderr)
        exit(2)


def main(device: str, mode: str):
    with mido.open_input(name=device) as port:
        clearPort(port)
        getMidiData(port, mode)


if __name__ == "__main__":
    if args.list_devices:
        list_devices()
        exit(0)
    if args.device is None:
        print(
            "Device must be specified. Check '--device' in '--help'.", file=sys.stderr
        )
        exit(1)
    main(INPUT_DEVICE, args.mode)
