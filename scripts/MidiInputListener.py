#!/usr/bin/env python3

from time import sleep
import sys
import signal


def cleanup():
    print("done")


def sigterm_handler(signalnum, stackframe):
    cleanup()
    sys.exit(0)


signal.signal(signal.SIGTERM, sigterm_handler)


def main():
    s = 1

    x = 0
    while True:
        print(f"{x}")
        x += 1
        sleep(s)


if __name__ == "__main__":
    main()
