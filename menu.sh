#!/bin/bash
#
# ©2020 Copyright 2020 Robert D. Chin
#
# Usage: bash menu.sh
#        (not sh menu.sh)
#
# +----------------------------------------+
# |        Default Variable Values         |
# +----------------------------------------+
#
VERSION="2020-09-19 18:41"
THIS_FILE="menu.sh"
TEMP_FILE="$THIS_FILE_temp.txt"
GENERATED_FILE="$THIS_FILE_menu_generated.lib"
#
# +----------------------------------------+
# |            Brief Description           |
# +----------------------------------------+
#
#& Brief Description
#&
#& This script will generate either a CLI text menu, or "Dialog" or "Whiptail"
#& UI menu from an array using data in clear text in scripts:
#& menu_module_main.lib, menu_module_sub1.lib
#& or any other menu_modules... you wish to add.
#&
#& Required scripts: menu.sh, menu_module_main.lib,
#&                   menu_module_sub0.lib, menu_module_sub1.lib
#&                   common_bash_function.lib
#&
#& Usage: bash menu.sh
#&        (not sh menu.sh)
#
# +----------------------------------------+
# |             Help and Usage             |
# +----------------------------------------+
#
#?    Usage: bash menu.sh [OPTION(S)]
#? Examples:
#?
#?bash menu.sh text      # Use Cmd-line user-interface (80x24 min.)
#?             dialog    # Use Dialog   user-interface.
#?             whiptail  # Use Whiptail user-interface.
#?
#?bash menu.sh --help    # Displays this help message.
#?             -?
#?
#?bash menu.sh --about   # Displays script version.
#?             --version
#?             --ver
#?             -v
#?
#?bash menu.sh --history # Displays script code history.
#?             --hist
#?
#? Examples using 2 arguments:
#?
#?bash menu.sh --hist text
#?             --ver dialog
#
# +----------------------------------------+
# |           Code Change History          |
# +----------------------------------------+
#
## Code Change History
##
## (After each edit made, please update Code History and VERSION.)
##
## 2020-09-19 *f_menu_main, f_check_version updated to latest standards.
##            *f_sub_menu_1 added comments.
##
## 2020-09-17 *f_check_version added to compare and update version of this
##             script if necessary.
##             *Main Menu added new entry "Version Update". Title change.
##
## 2020-09-09 *Updated to latest standards.
##
## 2020-08-07 *f_about, f_help_message, f_code_history deleted since
##             these functions are maintained in common_bash_function.lib.
##            *f_display_common updated to add option to display
##             without an "OK" button in Dialog.
##             However, Whiptail only displays with an "OK" button.
##
## 2020-08-07 *Updated to latest standards.
##
## 2020-06-23 *Deleted all code functions which are included in the
##             BASH function library, "common_bash_function.lib".
##
## 2020-06-22 *Release 1.0 "Amy"
##             This version is the last version without a BASH library
##             dependency.
##
## 2020-06-22 *Updated to latest standards.
##
## 2020-05-14 *f_yn_question fixed bug where temp file was undefined.
##            *msg_ui_str_nok, f_msg_txt_str_nok changed wait time
##             from 5 to 3 seconds.
##            *f_exit_script to latest standard; clean-up temp files on exit.
##            *f_message, f_msg_ui_file_box_size, f_msg_ui_str_box_size,
##             f_ui_file_ok/nok, f_ui_str_ok/nok f_yn_question/defaults
##             specified parameter passing.
##            *f_menu_arrays, f_update_menu_txt/gui bug fixed to not unset
##             TEMP_FILE variable since it is used globally.
##
## 2020-05-06 *f_msg_ui_file_box_size, f_msg_ui_file_ok bug fixed in display.
##
## 2020-05-04 *f_update_menu_gui adjusted menu display parameters for Whiptail.
##
## 2020-04-22 *f_message split into several functions for clarity and
##             simplicity f_msg_(txt/ui)_(file/string)_(ok/nok).
##            *f_yn_question split off f_yn_defaults.
##
## 2020-04-19 *Found bug in VERSION setting in f_about, f_code_history,
##             f_help_message. Need to set $VERSION using correct $THIS_FILE.
##
## 2020-04-18 *Updated scripts for bug fixes and enhancements.
##
## 2020-03-25 *f_arguments added to support double-dash [OPTIONS] after
##             invoking the script. i.e. $ bash menu.sh --help
##                                       $ bash menu.sh text
##            *f_code_history, f_help_message, f_about bug fixes.
##            *menu_module_main.lib added "Help" menu option.
##
## 2020-03-22 *Main explicitly invoked menu_module_main.lib with full
##             pathname (in case there are multiple copies in different
##             file folders).
##            *f_update_menu_txt, f_update_menu_gui automatically updated
##              copyright notice in generated file, menu_generated.lib.
##            *f_create_show_menu and various functions in menu_module
##             libraries, use clear command to blank screen so Dialog and
##             Whiptail look better when transitioning from text UI.
##
## 2019-01-23 *f_update_menu_gui adjusted menu so menu height was maximized.
##            *f_about_txt added display of Brief Description.
##
## 2019-01-19 *Bug fix in return to previous menu.
##            *Clean up code and comments.
##
## 2018-01-18 *Cosmetic improvements to automatically fit the Dialog or 
##             Whiptail frame size to the amount of text.
##            *Optimized the generation of menus.
##
## 2018-01-17 *Initial release.
#
# +------------------------------------+
# |     Function f_display_common      |
# +------------------------------------+
#
#     Rev: 2020-08-07
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          $2=Delimiter of text to be displayed.
#          $3="NOK", "OK", or null [OPTIONAL] to control display of "OK" button.
#          $4=Pause $4 seconds [OPTIONAL]. If "NOK" then pause to allow text to be read.
#          THIS_DIR, THIS_FILE, VERSION.
#    Uses: X.
# Outputs: None.
#
# PLEASE NOTE: RENAME THIS FUNCTION WITHOUT SUFFIX "_TEMPLATE" AND COPY
#              THIS FUNCTION INTO ANY SCRIPT WHICH DEPENDS ON THE
#              LIBRARY FILE "common_bash_function.lib".#
f_display_common () {
      #
      # Specify $THIS_FILE name of the file containing the text to be displayed.
      # $THIS_FILE may be re-defined inadvertently when a library file defines it
      # so when the command, source [ LIBRARY_FILE.lib ] is used, $THIS_FILE is
      # redefined to the name of the library file, LIBRARY_FILE.lib.
      # For that reason, all library files now have the line
      # THIS_FILE="[LIBRARY_FILE.lib]" deleted.
      #
      #================================================================================
      # EDIT THE LINE BELOW TO DEFINE $THIS_FILE AS THE ACTUAL FILE NAME WHERE THE 
      # ABOUT, CODE HISTORY, AND HELP MESSAGE TEXT IS LOCATED.
      #================================================================================
                                           #
      THIS_FILE="menu.sh"  # <<<--- INSERT ACTUAL FILE NAME HERE.
                                           #
      TEMP_FILE=$THIS_DIR/$THIS_FILE"_temp.txt"
      #
      # Set $VERSION according as it is set in the beginning of $THIS_FILE.
      X=$(grep --max-count=1 "VERSION" $THIS_FILE)
      # X="VERSION=YYYY-MM-DD HH:MM"
      # Use command "eval" to set $VERSION.
      eval $X
      #
      echo "Script: $THIS_FILE. Version: $VERSION" > $TEMP_FILE
      echo >>$TEMP_FILE
      #
      # Display text (all lines beginning ("^") with $2 but do not print $2).
      # sed substitutes null for $2 at the beginning of each line
      # so it is not printed.
      sed -n "s/$2//"p $THIS_DIR/$THIS_FILE >> $TEMP_FILE
      #
      case $3 in
           "NOK" | "nok")
              f_message $1 "NOK" "Message" $TEMP_FILE $4
           ;;
           *)
              f_message $1 "OK" "(use arrow keys to scroll up/down/side-ways)" $TEMP_FILE
           ;;
      esac
      #
} # End of function f_display_common.
#
# +----------------------------------------+
# |          Function f_menu_main          |
# +----------------------------------------+
#
#     Rev: 2020-09-18
#  Inputs: None.
#    Uses: ARRAY_FILE, GENERATED_FILE, MENU_TITLE.
# Outputs: None.
#
# PLEASE NOTE: RENAME THIS FUNCTION WITHOUT SUFFIX "_TEMPLATE" AND COPY
#              THIS FUNCTION INTO THE MAIN SCRIPT WHICH WILL CALL IT.
#
f_menu_main () { # Create and display the Main Menu.
      #
      #THIS_FILE="example.sh"
      GENERATED_FILE=$THIS_DIR/$THIS_FILE"_menu_main_generated.lib"
      #
      # Does this file have menu items in the comment lines starting with "#@@"?
      grep --silent ^\#@@ $THIS_DIR/$THIS_FILE
      ERROR=$?
      # exit code 0 - menu items in this file.
      #           1 - no menu items in this file.
      #               file name of file containing menu items must be specified.
      if [ $ERROR -eq 0 ] ; then
         # Extract menu items from this file and insert them into the Generated file.
         # This is required because f_menu_arrays cannot read this file directly without
         # going into an infinite loop.
         grep ^\#@@ $THIS_DIR/$THIS_FILE >$GENERATED_FILE
         #
         # Specify file name with menu item data.
         ARRAY_FILE="$GENERATED_FILE"
      else
         #
         #================================================================================
         # EDIT THE LINE BELOW TO DEFINE $ARRAY_FILE AS THE ACTUAL FILE NAME (LIBRARY)
         # WHERE THE MENU ITEM DATA IS LOCATED. THE LINES OF DATA ARE PREFIXED BY "#@@".
         #================================================================================
         #
         # Specify library file name with menu item data.
         ARRAY_FILE="menu_mod_main.lib"
      fi
      #
      # Create arrays from data.
      f_menu_arrays $ARRAY_FILE
      #
      # Calculate longest line length to find maximum menu width
      # for Dialog or Whiptail using lengths calculated by f_menu_arrays.
      let MAX_LENGTH=$MAX_CHOICE_LENGTH+$MAX_SUMMARY_LENGTH
      #
      # Create generated menu script from array data.
      #
      # Note: ***If Menu title contains spaces,
      #       ***the size of the menu window will be too narrow.
      #
      # Menu title MUST use underscores instead of spaces.
      MENU_TITLE="Sample_Main_Menu"  # Menu title must substitute underscores for spaces
      TEMP_FILE=$THIS_DIR/$THIS_FILE"_menu_main_temp.txt"
      #
      f_create_show_menu $GUI $GENERATED_FILE $MENU_TITLE $MAX_LENGTH $MAX_LINES $MAX_CHOICE_LENGTH $TEMP_FILE
      #
      if [ -r $GENERATED_FILE ] ; then
         rm $GENERATED_FILE
      fi
      #
      if [ -r $TEMP_FILE ] ; then
         rm $TEMP_FILE
      fi
      #
} # End of function f_menu_main.
#
# +----------------------------------------+
# |          Function f_download           |
# +----------------------------------------+
#
#     Rev: 2020-06-04
#  Inputs: $1=GitHub Repository
#          $2=file name to download.
#    Uses: ARRAY_FILE, GENERATED_FILE, MENU_TITLE.
# Outputs: None.
#
f_download () { # Create and display the Main Menu.
      #
      wget --show-progress $1$2
      ERROR=$?
      if [ $ERROR -ne 0 ] ; then
         echo
         echo "!!! wget download failed !!!"
         echo "from GitHub.com for file: $2"
         echo
         echo "Cannot continue, exiting program script."
         sleep 3
         exit 1  # Exit with error.
      fi
      #
      # Make downloaded file executable.
      chmod 755 $2
      #
      echo
      echo ">>> Please run program again after download. <<<"
      echo 
      # Delay to read messages on screen.
      echo -n "Press \"Enter\" key to continue" ; read X
      exit 0
      #
} # End of function f_download.
#
# **************************************
# ***     Start of Main Program      ***
# **************************************
#
#     Rev: 2020-07-01
#
if [ -e $TEMP_FILE ] ; then
   rm $TEMP_FILE
fi
#
clear  # Blank the screen.
#
echo "Running script $THIS_FILE"
echo "***   Rev. $VERSION   ***"
echo
sleep 1  # pause for 1 second automatically.
#
clear # Blank the screen.
#
# Invoke common BASH function library.
FILE_DEPENDENCY="common_bash_function.lib"
if [ -x "$FILE_DEPENDENCY" ] ; then
   source $FILE_DEPENDENCY
else
   echo "File Error"
   echo
   echo "Error with required file:"
   echo "\"$FILE_DEPENDENCY\""
   echo
   echo "File is missing or file is not executable."
   echo
   echo "Do you want to download the file: $FILE_DEPENDENCY"
   echo -n "from GitHub.com? (Y/n): " ; read ANS
   case $ANS in
        "" | [Yy] | [Yy][Ee] | [Yy][Ee][Ss] )
           f_download_library "https://raw.githubusercontent.com/rdchin/BASH_function_library/master/" "common_bash_function.lib"
           ;;
        *)
           echo
           echo "Cannot continue, exiting program script."
           echo "Error with required file:"
           echo "\"$FILE_DEPENDENCY\""
           sleep 3
           exit 1  # Exit with error.
           ;;
   esac
   #
fi
#
# Invoke libraries required for this script.
# for FILE_DEPENDENCY in LIBRARY1.lib LIBRARY2.lib LIBRARY3.lib
#     do
#        if [ ! -x "$FILE_DEPENDENCY" ] ; then
#           f_message "text" "OK" "File Error"  "Error with required file:\n\"$FILE_DEPENDENCY\"\n\n\Z1\ZbFile is missing or file is not executable.\n\n\ZnCannot continue, exiting program script." 3
#           echo
#           f_abort text
#        else
#           source "$FILE_DEPENDENCY"
#        fi
#    done
# # Test for files required for this script.
# for FILE_DEPENDENCY in FILE1 FILE2 FILE3
#     do
#        if [ ! -x "$FILE_DEPENDENCY" ] ; then
#           f_message "text" "OK" "File Error"  "Error with required file:\n\"$FILE_DEPENDENCY\"\n\n\Z1\ZbFile is missing or file is not executable.\n\n\ZnCannot continue, exiting program script." 3
#           echo
#           f_abort text
#        fi
#     done
#
# If an error occurs, the f_abort() function will be called.
# trap 'f_abort' 0
# set -e
#
# Set THIS_DIR, SCRIPT_PATH to directory path of script.
f_script_path
#
# Set Temporary file using $THIS_DIR from f_script_path.
TEMP_FILE=$THIS_DIR/$THIS_FILE"_temp.txt"
#
# Set default TARGET DIRECTORY.
TARGET_DIR=$THIS_DIR
#
# Test for Optional Arguments.
f_arguments $1 $2 # Also sets variable GUI.
#
# If command already specifies GUI, then do not detect GUI i.e. "bash dropfsd.sh dialog" or "bash dropfsd.sh text".
if [ -z $GUI ] ; then
   # Test for GUI (Whiptail or Dialog) or pure text environment.
   f_detect_ui
fi
#
# Show Brief Description message.
f_about $GUI "NOK" 1
#
#GUI="whiptail"  # Diagnostic line.
#GUI="dialog"    # Diagnostic line.
#GUI="text"      # Diagnostic line.
#
# Test for BASH environment.
f_test_environment
#
#
f_menu_main
#
clear # Blank the screen. Nicer ending especially if you chose custom colors for this script.
#
exit 0  # This cleanly closes the process generated by #!bin/bash. 
        # Otherwise every time this script is run, another instance of
        # process /bin/bash is created using up resources.
        #
# All dun dun noodles.
