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
VERSION="2021-02-21 20:55"
THIS_FILE="menu.sh"
TEMP_FILE="$THIS_FILE_temp.txt"
GENERATED_FILE="$THIS_FILE_menu_generated.lib"
#
#================================================================
# EDIT THE LINES BELOW TO SET REPOSITORY SERVERS AND DIRECTORIES
# AND TO INCLUDE ALL DEPENDENT SCRIPTS AND LIBRARIES TO DOWNLOAD.
#================================================================
#
# Set variables to check for network connectivity.
#
# Ping Local File Server Repository
PING_LAN_TARGET="[FILE SERVER NAME]"
PING_LAN_TARGET="scotty"
#
# Ping Web File Server Repository
PING_WAN_TARGET="[WEB FILE REPOSITORY]"
PING_WAN_TARGET="raw.githubusercontent.com"
#
# Set variables to mount the Local Repository to a mount-point.
#
# Local File Server Directory.
# LAN File Server shared directory.
SERVER_DIR="[ FILE SERVER DIRECTORY NAME GOES HERE ]"
SERVER_DIR="//scotty/files"
#
# Local Client PC Mount-Point Directory.
MP_DIR="[ LOCAL MOUNT-POINT DIRECTORY NAME GOES HERE ]"
MP_DIR="/mnt/scotty/files"
#
# Local PC target directory, sub-directory below mount-point directory.
TARGET_DIR="[ LOCAL MOUNT-POINT DIRECTORY/REPOSITORY SUB-DIRECTORY PATH GOES HERE ]"
TARGET_DIR="/mnt/scotty/files/LIBRARY/PC-stuff/PC-software/BASH_Scripting_Projects/Repository"
#
# Local PC file name to compare.
# FILE_TO_COMPARE="[ LOCAL FILE NAME ]"
FILE_TO_COMPARE=$THIS_FILE
#
# Each file script contains the string "VERSION=[ YYYY-MM-DD HH:MM ]"
# i.e. VERSION="2020-12-31 23:59"
#
# Version of TARGET_FILE.
# Format: YYYY-MM-DD_HH:MM string.
VERSION_TO_COMPARE=$(echo $VERSION | tr ' ' '_')
#
FILE_LIST=$THIS_FILE"_file_temp.txt"
#
# Format: [File Name]^[Local/Web]^[Local repository directory]^[web repository directory]
echo "$THIS_FILE^Local^/mnt/scotty/files/LIBRARY/PC-stuff/PC-software/BASH_Scripting_Projects/Repository^https://raw.githubusercontent.com/rdchin/bash-automatic-menu-creator/master/"          > $FILE_LIST
echo "menu_module_main.lib^Web^/mnt/scotty/files/LIBRARY/PC-stuff/PC-software/BASH_Scripting_Projects/Repository^https://raw.githubusercontent.com/rdchin/bash-automatic-menu-creator/master/" >> $FILE_LIST
echo "menu_module_sub0.lib^Web^/mnt/scotty/files/LIBRARY/PC-stuff/PC-software/BASH_Scripting_Projects/Repository^https://raw.githubusercontent.com/rdchin/bash-automatic-menu-creator/master/" >> $FILE_LIST
echo "menu_module_sub1.lib^Web^/mnt/scotty/files/LIBRARY/PC-stuff/PC-software/BASH_Scripting_Projects/Repository^https://raw.githubusercontent.com/rdchin/bash-automatic-menu-creator/master/" >> $FILE_LIST
echo "common_bash_function.lib^Web^/mnt/scotty/files/LIBRARY/PC-stuff/PC-software/BASH_Scripting_Projects/Repository^https://raw.githubusercontent.com/rdchin/BASH_function_library/master/"   >> $FILE_LIST
#
ERROR=0
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
#? bash menu.sh text      # Use Cmd-line user-interface (80x24 min.)
#?              dialog    # Use Dialog   user-interface.
#?              whiptail  # Use Whiptail user-interface.
#?
#? bash menu.sh --help    # Displays this help message.
#?              -?
#?
#? bash menu.sh --about   # Displays script version.
#?              --version
#?              --ver
#?              -v
#?
#? bash men.sh --update   # Update script.
#?             -u
#?
#? bash menu.sh --history # Displays script code history.
#?              --hist
#?
#? Examples using 2 arguments:
#?
#? bash menu.sh --hist text
#?              --ver dialog
#
# +----------------------------------------+
# |           Code Change History          |
# +----------------------------------------+
#
## Code Notes
##
## To disable the [ OPTION ] --update -u to update the script:
##    1) Comment out the call to function fdl_download_missing_scripts in
##       Section "Start of Main Program".
##
## To completely delete the [ OPTION ] --update -u to update the script:
##    1) Delete the call to function fdl_download_missing_scripts in
##       Section "Start of Main Program".
##    2) Delete all functions beginning with "f_dl"
##    3) Delete instructions to update script in Section "Help and Usage".
##
## To disable the Main Menu:
##    1) Comment out the call to function f_menu_main under "Run Main Code"
##       in Section "Start of Main Program".
##    2) Add calls to desired functions under "Run Main Code"
##       in Section "Start of Main Program".
##
## To completely remove the Main Menu and its code:
##    1) Delete the call to function f_menu_main under "Run Main Code" in
##       Section "Start of Main Program".
##    2) Add calls to desired functions under "Run Main Code"
##       in Section "Start of Main Program".
##    3) Delete the function f_menu_main.
##    4) Delete "Menu Choice Options" in example_library.lib located under
##       Section "Customize Menu choice options below".
##       The "Menu Choice Options" lines begin with "#@@".
##
## Code Change History
##
## (After each edit made, please update Code History and VERSION.)
##
## 2021-02-21 *fdl_download_missing_scripts added to modulize existing code
##             under Section "Main Program" to allow easier deletion of code
##             the "Update Version" feature is not desired.
##            *Functions related to "Update Version" renamed with an "fdl"
##             prefix to identify dependent functions to delete if that
##             function is not desired.
##            *Section "Code Change History" added instructions on how to
##             disable/delete "Update Version" feature or "Main Menu".
##
## 2021-02-13 *Changed menu item wording from "Quit to command-line" prompt.
##                                         to "Exit this menu."
##            *f_check_version updated to latest version.
##
## 2020-10-27 *Updated to latest standards.
##
## 2020-10-25 *f_arguments, "Help and Usage" added option --update -u.
##            *f_check_version updated to latest standards.
##
## 2020-10-24 *Main added functionality to download any dependent file or
##             library from this script.
##            *f_choose_dl_source, f_source added to optimize the enhanced
##             download functionality and to allow user a choice between
##             downloading file and library dependencies from a local
##             or a web repository.
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
#          THIS_DIR, THIS_FILE, VERSION_TO_COMPARE.
#    Uses: X.
# Outputs: None.
#
# PLEASE NOTE: RENAME THIS FUNCTION WITHOUT SUFFIX "_TEMPLATE" AND COPY
#              THIS FUNCTION INTO ANY SCRIPT WHICH DEPENDS ON THE
#              LIBRARY FILE "common_bash_function.lib".
#
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
      TEMP_FILE=$THIS_FILE"_temp.txt"
      #
      # Set $VERSION according as it is set in the beginning of $THIS_FILE.
      # X="VERSION=YYYY-MM-DD HH:MM"
      # Use command "eval" to set $VERSION.
      #
      echo -n "Script: $THIS_FILE. Version: " > $TEMP_FILE
      echo $VERSION_TO_COMPARE | tr '_' ' ' >> $TEMP_FILE
      echo >>$TEMP_FILE
      #
      # Display text (all lines beginning ("^") with $2 but do not print $2).
      # sed substitutes null for $2 at the beginning of each line
      # so it is not printed.
      sed --silent "s/$2//p" $THIS_FILE >> $TEMP_FILE
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
#  Inputs: $1=GUI.
#    Uses: ARRAY_FILE, GENERATED_FILE, MENU_TITLE.
# Outputs: None.
#
# PLEASE NOTE: RENAME THIS FUNCTION WITHOUT SUFFIX "_TEMPLATE" AND COPY
#              THIS FUNCTION INTO THE MAIN SCRIPT WHICH WILL CALL IT.
#
f_menu_main () { # Create and display the Main Menu.
      #
      #THIS_FILE="menu.sh"
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
         ARRAY_FILE="menu_module_main.lib"
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
      f_create_show_menu $1 $GENERATED_FILE $MENU_TITLE $MAX_LENGTH $MAX_LINES $MAX_CHOICE_LENGTH $TEMP_FILE
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
# |      Function fdl_choose_dl_source     |
# +----------------------------------------+
#
#     Rev: 2020-10-22
#  Inputs: $1="Web" or "Local".
#          $2=file to download.
# Outputs: ANS.
#
fdl_choose_dl_source () {
      #
      DL_FILE=$(echo $DL_LINE | awk -F "^" '{ print $1 }')
      DL_SOURCE=$(echo $DL_LINE | awk -F "^" '{ print $2 }')
      # Format [File name]^[Local/Web]
      DL_LINE=$(echo $DL_LINE | awk -F "^" '{ print $1"^"$2}')
      #
      fdl_choose_download_source $DL_SOURCE $DL_FILE
      # Insert ANS into FILE_DL_LIST.
      # Substitute DL_LINE_NEW for DL_LINE.
      # ANS [Local/Web] is the project's download choice for all project files.
      # ANS will over-write any existing value [Local/Web] for each project file.
      # Substitute ANS for existing value whether "Local" or "Web".
      DL_LINE_NEW=${DL_LINE/$DL_FILE^Local/$DL_FILE^$ANS}
      DL_LINE_NEW=${DL_LINE/$DL_FILE^Web/$DL_FILE^$ANS}
      #
      # Change or substitute new ANS or download choice into download file list.
      sed -i "s/$DL_LINE/$DL_LINE_NEW/" $FILE_DL_LIST
      #
} # End of function fdl_choose_dl_source.
#
# +----------------------------------------+
# |   Function fdl_choose_download_source  |
# +----------------------------------------+
#
#     Rev: 2020-10-22
#  Inputs: $1="Web" or "Local".
#          $2=file to download.
# Outputs: ANS.
#
fdl_choose_download_source () {
      # Is $1 specified or "local"?
      ANS=""
      if [ $1 != "Local" ] ; then
         while [ "$ANS" = "" ]
               do
                  echo
                  echo "Do you want to download the file: $2"
                  echo -n "from the web repository? (W)eb or the local repository (L)ocal ($1):" ; read ANS
                  case $ANS in
                       [Ww])
                          ANS="Web"
                       ;;
                       [Ll] | "")
                          ANS="Local"
                       ;;
                       *)
                          ANS="$1"
                       ;;
                  esac
               done
      else
         # If "Local" download source, do not give a choice, use Local Repository for download.
         ANS="Local"
      fi
      #
} # End of function fdl_choose_download_source.
#
# +----------------------------------------+
# |     fdl_dwnld_library_from_web_site    |
# +----------------------------------------+
#
#     Rev: 2020-10-06
#  Inputs: $1=GitHub Repository
#          $2=file name to download.
#          $3=ERROR.
#    Uses: None.
# Outputs: None.
#
# PLEASE NOTE: RENAME THIS FUNCTION WITHOUT SUFFIX "_TEMPLATE" AND COPY
#              THIS FUNCTION INTO ANY SCRIPT WHICH DEPENDS ON THE
#              LIBRARY FILE "common_bash_function.lib".
#
fdl_dwnld_library_from_web_site () {
      #
      ERROR=$3
      #
      if [ $ERROR -eq 0 ] ; then
         # $1 ends with a slash "/" so can append $2 immediately after $1.
         wget --show-progress $1$2
         ERROR=$?
         if [ $ERROR -ne 0 ] ; then
            echo
            echo "!!! wget download failed !!!"
            echo "from GitHub.com for file: $2"
            echo
         fi
         #
         # Make downloaded file executable.
         chmod 755 $2
         #
      fi
      #
} # End of function fdl_dwnld_library_from_web_site.
#
# +------------------------------------------+
# |  fdl_dwnld_library_from_local_repository |
# +------------------------------------------+
#
#     Rev: 2020-10-06
#  Inputs: $1=Local Repository Directory.
#          $2=File to download.
#          $3=ERROR.
#    Uses: TEMP_FILE, SMBUSER, PASSWORD, ERROR.
# Outputs: TEMP_FILE.
#
# This is used to download any file with a text-only UI. 
# This can be used to download the Common Function Library.
# Used to download any file before the Common Library is even downloaded. 
#
fdl_dwnld_library_from_local_repository () {
      #
      if [ $ERROR -eq 0 ] ; then
         eval cp -p $1/$2 .
         ERROR=$?
         #
         if [ $ERROR -ne 0 ] ; then
            echo
            echo -e "Error occurred\nError copying $2."
            sleep 2
            ERROR=1
         else
            # Make file executable (useable).
            chmod +x $2
            #
            if [ -x $2 ] ; then
               # File is good.
               ERROR=0
            else
               echo
               echo "File Error"
               echo -e "$2 is missing or file is not executable.\n\nCannot continue, exiting program script."
               sleep 3
               ERROR=1
            fi
         fi
      fi
      #
      if [ $ERROR -ne 0 ] ; then
         echo
         echo -e "Error occurred\nError copying $2."
      else
         echo
         echo -e "Successful Update of $2.\n\nLatest version was successfully copied for use.\nScript must be re-started to use the latest version."
         echo "____________________________________________________"
      fi
      #
} # End of function fdl_dwnld_library_from_local_repository.
#
# +------------------------------------------+
# |              fdl_mount_local             |
# +------------------------------------------+
#
#     Rev: 2020-10-10
#  Inputs: $1=Server Directory.
#          $2=Local Mount Point Directory
#          TEMP_FILE
#    Uses: TARGET_DIR, UPDATE_FILE, ERROR.
# Outputs: ERROR.
#
fdl_mount_local () {
      # Mount local repository on mount-point.
      mountpoint $2 >/dev/null 2>$TEMP_FILE # Write any error messages to file $TEMP_FILE. Get status of mountpoint, mounted?.
      ERROR=$?
      if [ $ERROR -ne 0 ] ; then
         # Mount directory.
         echo
         read -p "Enter user name: " SMBUSER
         echo
         read -s -p "Enter Password: " PASSWORD
         echo
         sudo mount -t cifs -o username="$SMBUSER" -o password="$PASSWORD" $1 $2
         mountpoint $2 >/dev/null 2>$TEMP_FILE # Write any error messages to file $TEMP_FILE. Get status of mountpoint, mounted?.
         ERROR=$?
         unset SMBUSER PASSWORD
      fi
      #
} # End of function fdl_mount_local.
#
# +----------------------------------------+
# |             Function f_source          |
# +----------------------------------------+
#
#     Rev: 2020-10-22
#  Inputs: $1=File name to source.
# Outputs: ANS.
#
f_source () {
      if [ -x "$1" ] ; then
         # If $1 is a library, then source it.
         case $1 in
              common_bash_function.lib)
                 source $1
              ;;
              *.lib)
                 source $1
              ;;
         esac
      fi
      #
} # End of function f_source.
#
# +----------------------------------------+
# |  Function fdl_download_missing_scripts |
# +----------------------------------------+
#
#     Rev: 2020-10-22
#  Inputs: $1=File name to source.
# Outputs: ANS.
#
fdl_download_missing_scripts () {
      #
      # ****************************************************
      # Create new list of files that need to be downloaded.
      # ****************************************************
      #
      #----------------------------------------------------------------
      # Variables FILE_LIST and FILE_DL_LIST are defined in the section
      # "Default Variable Values" at the beginning of this script.
      #----------------------------------------------------------------
      #
      # Delete any existing temp file.
      if [ -r  $FILE_DL_LIST ] ; then
         rm  $FILE_DL_LIST
      fi
      #
      while read LINE
            do
               FILE=$(echo $LINE | awk -F "^" '{ print $1 }')
               if [ ! -x $FILE ] ; then
                  # File needs to be downloaded or is not executable
                  chmod +x $FILE 2>$TEMP_FILE # Write any error messages to file $TEMP_FILE.
                  ERROR=$?
                  if [ $ERROR -ne 0 ] ; then
                     # File needs to be downloaded. Add file name to a file list in a text file.
                     # Build list of files to download.
                     echo $LINE >> $FILE_DL_LIST
                  fi
               fi
            done < $FILE_LIST
      #
      # If there are files to download (listed in FILE_DL_LIST), then mount local repository.
      if [ -s "$FILE_DL_LIST" ] ; then
         echo
         echo "There are missing file dependencies which must be downloaded from"
         echo "the local repository or web repository."
         echo
         echo "Missing files:"
         while read LINE
               do
                  echo $LINE | awk -F "^" '{ print $1 }'
               done < $FILE_DL_LIST
         echo
         echo "You will need to present credentials."
         echo
         echo -n "Press '"Enter"' key to continue." ; read X ; unset X
         #
         # **************************************************
         # Select Download Source of Common Function Library.
         # **************************************************
         #
         #----------------------------------------
         # Get the download source of the Library.
         #----------------------------------------
         #
         DL_LINE=$(grep common_bash_function.lib $FILE_DL_LIST)
         #
         # If Library is in the download file list, then choose download source.
         if [ -n "$DL_LINE" ] ; then
            fdl_choose_dl_source $DL_LINE
         fi
         #
         # **************************************************
         # Select Download Source of Dependent Project Files.
         # **************************************************
         # Set download source for all dependent files/libraries using the same source
         # used by this file ($THIS_FILE).
         #
         #------------------------------------------
         # Get the download source for this project.
         #------------------------------------------
         # Grep $FILE_LIST not $FILE_DL_LIST to get the download source for this project.
         #
         DL_LINE=$(grep $THIS_FILE $FILE_LIST)
         #
         # If this file ($THIS_FILE) is in the download file list, then choose download source.
         if [ -n "$DL_LINE" ] ; then
            fdl_choose_dl_source $DL_LINE
         fi
         #
         #-----------------------------------------------------------------------
         # Set the download source for all the dependent files to the same source
         # used by this file ($THIS_FILE).
         #-----------------------------------------------------------------------
         # Change or substitute the new download choice for each project file
         # in the download file list.
         #
         # Get download choice for this project and save as DL_SOURCE.
         DL_LINE=$(grep $THIS_FILE $FILE_LIST)
         #
         while read LINE
               do
                  DL_FILE=$(echo $LINE | awk -F "^" '{ print $1 }')
                  DL_SOURCE=$(echo $DL_LINE | awk -F "^" '{ print $2 }')
                  # Format [File name]^[Local/Web]
                  DL_LINE=$(echo $LINE | awk -F "^" '{ print $1"^"$2}')
                  # All other files, substitute DL_LINE_NEW for LINE.
                  # DL_SOURCE [Local/Web] is the project's download choice for all project files.
                  # DL_SOURCE will over-write any existing value [Local/Web] for each project file.
                  # Substitute DL_SOURCE for existing value whether "Local" or "Web".
                  DL_LINE_NEW=${DL_LINE/$DL_FILE^Local/$DL_FILE^$DL_SOURCE}
                  DL_LINE_NEW=${DL_LINE/$DL_FILE^Web/$DL_FILE^$DL_SOURCE}
                  sed -i "s/$DL_LINE/$DL_LINE_NEW/" $FILE_DL_LIST
               done < $FILE_DL_LIST
         #
         #--------------------------------------------------------------------------------------
         # Check if there is a LAN (Local network) connection before mounting local mount-point.
         #--------------------------------------------------------------------------------------
         #
         # Initialize Error Flag.
         ERROR_LAN=0
         #
         grep --silent "Local" $FILE_DL_LIST
         ERROR=$?
         # exit code 0 - menu items in this file.
         #           1 - no menu items in this file.
         #               file name of file containing menu items must be specified.
         #
         if [ $ERROR -eq 0 ] ; then
            #
            # Check if there is an LAN connection before doing a download.
            #
            #-----------------------------------------------------------
            # Variable PING_LAN_TARGET is defined in the section
            # "Default Variable Values" at the beginning of this script.
            #-----------------------------------------------------------
            #
            # Ping local file server.
            ping -c 1 -q $PING_LAN_TARGET >/dev/null # Ping server address.
            ERROR=$?
            #
            if [ $ERROR -ne 0 ] ; then
               echo -e "\n\nPing Test Network Connection\n\nNo network connection to local file server."
               ERROR_LAN=1
            else
               echo -e "\n\nPing Test Network Connection\n\nNetwork connnection to local file server is good."
               ERROR_LAN=0
               #
               #-------------------------------------------------
               # LAN connection is OK so mount local mount-point.
               #-------------------------------------------------
               #
               #-----------------------------------------------------------
               # Variables SERVER_DIR and MP_DIR are defined in the section
               # "Default Variable Values" at the beginning of this script.
               #-----------------------------------------------------------
               #
               # Mount the Local Repository to the mount-point.
               fdl_mount_local $SERVER_DIR $MP_DIR
               #
            fi
         fi
         #
         #------------------------------------------------------------------
         # Check if there is a WAN (Web) connection before doing a download.
         #------------------------------------------------------------------
         #
         # Initialize Error Flag.
         ERROR_WAN=0
         #
         grep --silent "Web" $FILE_DL_LIST
         ERROR=$?
         # exit code 0 - menu items in this file.
         #           1 - no menu items in this file.
         #               file name of file containing menu items must be specified.
         if [ $ERROR -eq 0 ] ; then
            #
            # Check if there is an LAN connection before doing a download.
            #
            #-----------------------------------------------------------
            # Variable PING_WAN_TARGET is defined in the section
            # "Default Variable Values" at the beginning of this script.
            #-----------------------------------------------------------
            #
            ping -c 1 -q $PING_WAN_TARGET >/dev/null # Ping server address.
            ERROR=$?
            #
            if [ $ERROR -ne 0 ] ; then
               echo -e "\n\nPing Test Network Connection\n\nNo network connection to Web server."
               ERROR_WAN=1
            else
               echo -e "\n\nPing Test Network Connection\n\nNetwork connnection to Web server is good."
               ERROR_WAN=0
            fi
         fi
         #
         #----------------------------------------------------------------------------------------
         # Select alternative download source if no network connection to primary download source.
         #----------------------------------------------------------------------------------------
         #
         # If Local connection failed, switch to Web file server download.
         if [ $ERROR_LAN -eq 1 ] ; then
            # Format [File name]^[Local/Web]
            sed -i "s/^Local^/^Web^/" $FILE_DL_LIST
         fi
         #
         # If Web connection failed, switch to Local file server download.
         if [ $ERROR_WAN -eq 1 ] ; then
            # Format [File name]^[Local/Web]
            sed -i "s/^Web^/^Local^/" $FILE_DL_LIST
         fi
         #
         #----------------------------------------------------------------------------------------------
         # From list of files to download created above $FILE_DL_LIST, download the files one at a time.
         #----------------------------------------------------------------------------------------------
         #
         while read LINE
               do
                  # Get Download Source for each file.
                  DL_FILE=$(echo $LINE | awk -F "^" '{ print $1 }')
                  DL_SOURCE=$(echo $LINE | awk -F "^" '{ print $2 }')
                  TARGET_DIR=$(echo $LINE | awk -F "^" '{ print $3 }')
                  DL_REPOSITORY=$(echo $LINE | awk -F "^" '{ print $4 }')
                  #
                  # Initialize Error Flag.
                  ERROR=0
                  #
                  # If a file only found in the Local Repository has source changed
                  # to "Web" because LAN connectivity has failed, then do not download.
                  if [ -z DL_REPOSITORY ] && [ $DL_SOURCE = "Web" ] ; then
                     ERROR=1
                  fi
                  #
                  case $DL_SOURCE in
                       Local)
                          fdl_dwnld_library_from_local_repository $TARGET_DIR $DL_FILE $ERROR
                       ;;
                       Web)
                          fdl_dwnld_library_from_web_site $DL_REPOSITORY $DL_FILE $ERROR
                       ;;
                  esac
                  #
               done < $FILE_DL_LIST
         #
         # Delete temporary files.
         if [ -e $TEMP_FILE ] ; then
            rm $TEMP_FILE
         fi
         #
         if [ -r  $FILE_LIST ] ; then
            rm  $FILE_LIST
         fi
         #
         if [ -r  $FILE_DL_LIST ] ; then
            rm  $FILE_DL_LIST
         fi
         #
         echo
         echo ">>> Please run program again after download. <<<"
         echo
         echo "Cannot continue, exiting program script."
         sleep 3
         exit 1  # Exit script after downloading dependent files and libraries.
         #
      fi
      #
      # Source each library.
      #
      while read LINE
            do
               FILE=$(echo $LINE | awk -F "^" '{ print $1 }')
               # Invoke any library files.
               f_source $FILE
            done < $FILE_LIST
      #
} # End of function fdl_download_missing_scripts.
#
#
# **************************************
# **************************************
# ***     Start of Main Program      ***
# **************************************
# **************************************
#     Rev: 2020-02-21
#
#
if [ -e $TEMP_FILE ] ; then
   rm $TEMP_FILE
fi
#
#clear  # Blank the screen.
#
echo "Running script $THIS_FILE"
echo "***   Rev. $VERSION   ***"
echo
sleep 5  # pause for 1 second automatically.
#
clear # Blank the screen.
#
#-------------------------------------------------------
# Detect and download any missing scripts and libraries.
#-------------------------------------------------------
fdl_download_missing_scripts
#
#***************************************************************
# Process Any Optional Arguments and Set Variables THIS_DIR, GUI
#***************************************************************
#
# Set THIS_DIR, SCRIPT_PATH to directory path of script.
f_script_path
#
# Set Temporary file using $THIS_DIR from f_script_path.
TEMP_FILE=$THIS_FILE"_temp.txt"
#
# Test for Optional Arguments.
f_arguments $1 $2 # Also sets variable GUI.
#
# If command already specifies GUI, then do not detect GUI i.e. "bash men.sh dialog" or "bash men.sh text".
if [ -z $GUI ] ; then
   # Test for GUI (Whiptail or Dialog) or pure text environment.
   f_detect_ui
fi
#
# If an error occurs, the f_abort() function will be called.
# trap 'f_abort' 0
# set -e
#
#********************************
# Show Brief Description message.
#********************************
f_about $GUI "NOK" 1
#
#GUI="whiptail"  # Diagnostic line.
#GUI="dialog"    # Diagnostic line.
#GUI="text"      # Diagnostic line.
#
# Test for BASH environment.
f_test_environment
#
#***************
# Run Main Code.
#***************
#
f_menu_main $GUI
#
# Delete temporary files.
#
if [ -e $TEMP_FILE ] ; then
   rm $TEMP_FILE
fi
#
if [ -r  $FILE_LIST ] ; then
   rm  $FILE_LIST
fi
#
if [ -r  $FILE_DL_LIST ] ; then
   rm  $FILE_DL_LIST
fi
#
exit 0  # This cleanly closes the process generated by #!bin/bash. 
        # Otherwise every time this script is run, another instance of
        # process /bin/bash is created using up resources.
# All dun dun noodles.
