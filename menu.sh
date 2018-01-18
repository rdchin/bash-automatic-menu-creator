#!/bin/bash
#
# ©2018 Copyright 2018 Robert D. Chin
#
# Usage: bash menu.sh
#        (not sh menu.sh)
#
VERSION="2018-01-18 01:32"
THIS_FILE="menu.sh"
#
#@ Brief Description
#@
#@ This script will generate either a text menu, or "Dialog" or "Whiptail"
#@ GUI menu from an array using data in clear text in scripts:
#@ menu_module_main.lib, menu_module_sub1.lib
#@ or any other menu_modules... you wish to add. 
#@
#@ After each edit made, please update Code History and VERSION.
#
## Code Change History
##
## 2018-01-18 *Cosmetic improvements to automatically fit the Dialog or 
##             Whiptail frame size to the amount of text.
##
## 2018-01-17 *Initial release.
#
# +----------------------------------------+
# |      Function f_test_environment       |
# +----------------------------------------+
#
#  Inputs: $BASH_VERSION (System variable).
#    Uses: None.
# Outputs: None.
#
f_test_environment () {
      # Set default colors in case configuration file is not readable
      # or does not exist.
      #
      # Test the environment. Are you in the BASH environment?
      # $BASH_VERSION is null if you are not in the BASH environment.
      # Typing "sh" at the CLI may invoke a different shell other than BASH.
      # if [ -z "$BASH_VERSION" ]; then
      # if [ "$BASH_VERSION" = '' ]; then
      f_test_dash_txt
} # End of function f_test_environment.
#
# +----------------------------------------+
# |        Function f_test_dash_txt        |
# +----------------------------------------+
#
#  Inputs: None.
#    Uses: None.
# Outputs: None.
#
f_test_dash_txt () {
      # Set default colors in case configuration file is not readable
      # or does not exist.
      #
      echo -n $(tput sgr0) # Set font to normal color.
      if [ -z "$BASH_VERSION" ]; then
         clear  # Clear screen.
         echo -n $(tput bold)
         echo -n $(tput setaf 1) # Set font to color red.
         echo "WARNING:"
         echo "You are using the DASH environment."
         echo "This script needs a BASH environment to run properly."
         echo $(tput sgr0) # Set font to normal color.
         echo "Ubuntu and Linux Mint default to DASH but also have BASH available."
         echo
         echo "Restart this script by typing:"
         echo -n $(tput bold)
         echo "       \"bash $THIS_FILE\""
         echo -n $(tput sgr0) # Set font to normal color.
         echo "at the command line prompt (without the quotation marks)."
         echo
         echo -n $(tput sgr0) # Set font to normal color.
         f_press_enter_key_to_continue
         f_abort_txt
      fi
} # End of function f_test_dash_txt.
#
# +----------------------------------------+
# |          Function f_detect_ui          |
# +----------------------------------------+
#
#  Inputs: None.
#    Uses: ERROR.
# Outputs: GUI (dialog, whiptail, text).
#
f_detect_ui () {
      command -v dialog >/dev/null
      # "&>/dev/null" does not work in Debian distro.
      # 1=standard messages, 2=error messages, &=both.
      ERROR=$?
      # Is Dialog GUI installed?
      if [ $ERROR -eq 0 ] ; then
         # Yes, Dialog installed.
         GUI="dialog"
      else
         # Is Whiptail GUI installed?
         command -v whiptail >/dev/null
         # "&>/dev/null" does not work in Debian distro.
         # 1=standard messages, 2=error messages, &=both.
         ERROR=$?
         if [ $ERROR -eq 0 ] ; then
            # Yes, Whiptail installed.
            GUI="whiptail"
         else
            # No CLI GUIs installed
            GUI="text"
         fi
      fi
} # End of function f_detect_ui.
#
# +----------------------------------------+
# |         Function f_script_path         |
# +----------------------------------------+
#
#  Inputs: $BASH_SOURCE (System variable).
#    Uses: None.
# Outputs: SCRIPT_PATH, THIS_DIR.
#
f_script_path () {
      # BASH_SOURCE[0] gives the filename of the script.
      # dirname "{$BASH_SOURCE[0]}" gives the directory of the script
      # Execute commands: cd <script directory> and then pwd
      # to get the directory of the script.
      # NOTE: This code does not work with symlinks in directory path.
      #
      # !!!Non-BASH environments will give error message about line below!!!
      SCRIPT_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
      THIS_DIR=$SCRIPT_PATH  # Set $THIS_DIR to location of this script.

} # End of function f_script_path.
#
# +----------------------------------------+
# | Function f_press_enter_key_to_continue |
# +----------------------------------------+
#
#  Inputs: None.
#    Uses: X.
# Outputs: None.
#
f_press_enter_key_to_continue () { # Display message and wait for user input.
      echo
      echo -n "Press '"Enter"' key to continue."
      read X
      unset X  # Throw out this variable.
} # End of function f_press_enter_key_to_continue.
#
# +----------------------------------------+
# |          Function f_main_menu          |
# +----------------------------------------+
#
#  Inputs: None.
#    Uses: ARRAY_FILE, GENERATED_FILE, MENU_TITLE.
# Outputs: None.
#
f_main_menu () { # Create and display the Main Menu.
      # Create arrays from data.
      ARRAY_FILE="menu_module_main.lib"
      f_menu_arrays $ARRAY_FILE
      #
      # Create generated menu script from array data.
      GENERATED_FILE="menu_generated.lib"
      MENU_TITLE="Main_Menu"  # Menu title must substitute underscores for spaces
      f_create_show_menu $GUI $GENERATED_FILE $MENU_TITLE : $MAX_LENGTH $MAX_LINES
} # End of function f_main_menu.
#
# **************************************
# ***     Start of Main Program      ***
# **************************************
#
# If an error occurs, the f_abort_txt() function will be called.
# trap 'f_abort_txt' 0
# set -e
#
# SUDO_ASKPASS="sudoask" ; export SUDO_ASKPASS
#
# Test for GUI (Whiptail or Dialog) or pure text environment.
f_detect_ui
#GUI="whiptail"  #Test diagnostic line.
#GUI="dialog"    #Test diagnostic line.
#GUI="text"       #Test diagnostic line.
#
#if [ -r menu.lib ] ; then  # Does library file exist and is readable in the same directory as this script.
#   . menu.lib  # Invoke library.
#else
   #$GUI --infobox "Missing a required file: \"mountup_lib_gui.lib\" from this directory.\n\n                    *** Aborting program ***" 5 71
   #exit 0  # This cleanly closes the process generated by #!bin/bash. 
           # Otherwise every time this script is run, another instance of
           # process /bin/bash is created using up resources.
#fi
#
# Test for BASH environment.
f_test_environment
#
# Set SCRIPT_PATH to directory path of script.
f_script_path
MAINMENU_DIR=$SCRIPT_PATH
THIS_DIR=$MAINMENU_DIR  # Set $THIS_DIR to location of Main Menu.
#
if [ -r menu.lib ] ; then  # Does library file exist and is readable in the same directory as this script.
   . menu.lib  # Invoke library.
else
   case $GUI in
        "dialog" | "whiptail") 
        $GUI --infobox "Missing a required file: \"menu.lib\" from this directory.\n\n                    *** Aborting program ***" 5 71
        ;;
        "text")
        echo "Missing a required file: \"menu.lib\" from this directory.\n\n                    *** Aborting program ***"
        ;;
   esac
   exit 0  # This cleanly closes the process generated by #!bin/bash. 
           # Otherwise every time this script is run, another instance of
           # process /bin/bash is created using up resources.
fi
#
f_main_menu
#
exit 0  # This cleanly closes the process generated by #!bin/bash. 
        # Otherwise every time this script is run, another instance of
        # process /bin/bash is created using up resources.
# all dun dun noodles.

