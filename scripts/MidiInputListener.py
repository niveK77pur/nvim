#!/usr/bin/env python3

from time import sleep
import sys
import signal
from typing import List

import mido

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
    if mode == "chord":
        getChordMode(port, accidentals)


def main(device: str):

    with mido.open_input(name=device) as port:
        clearPort(port)
        getMidiData(port, "chord")


if __name__ == "__main__":
    list_devices()
    main(INPUT_DEVICE)
