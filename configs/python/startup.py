# -*- coding: UTF-8 -*-

###
### IPython environment
###

try:
    from IPython.frontend.terminal.ipapp import launch_new_instance

    launch_new_instance()
    raise SystemExit

except ImportError:
    pass


###
### Normal python environment
###

try:
    # try to enable TAB completion on normal python interpreter

    import atexit
    import os
    import readline
    import rlcompleter

    history_path = os.path.expanduser('~/.pyhistory')

    if os.path.exists(history_path):
        readline.read_history_file(history_path)

    atexit.register(lambda: readline.write_history_file(history_path))
    readline.parse_and_bind('tab: complete')

except ImportError:
    pass


try:
    # try to inject debug print function '_d'

    import __builtin__
    import pprint
    import sys

    __builtin__._d = lambda target: pprint.pprint(target, stream=sys.stderr, indent=4)

except ImportError:
    pass
