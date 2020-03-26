#!/bin/bash
#
# ©2020 Copyright 2020 Robert D. Chin
#
# Usage: bash menu.sh
#        (not sh menu.sh)
#
VERSION="2020-03-26 00:15"
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
#@
#
#? Usage: bash menu.sh [OPTION]
#?
#?        bash menu.sh text       # Optimized for a 80x24 character display
#?        bash menu.sh dialog     # Use Dialog   user-interface
#?        bash menu.sh whiptail   # Use Whiptail user-interface
#?
#?        bash menu.sh --help     # Displays this help message.
#?        bash menu.sh -h
#?        bash menu.sh -?
#?
#?        bash menu.sh --about    # Displays script version.
#?        bash menu.sh --version
#?        bash menu.sh --ver
#?        bash menu.sh -v
#?
#?        bash menu.sh --history  # Displays script code history.
#?        bash menu.sh --his      # Displays script code history.
#
## Code Change History
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
##
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
# |         Function f_arguments           |
# +----------------------------------------+
#
#  Inputs: $1=Argument
#             [--help] [ -h ] [ -? ]
#             [--about]
#             [--version] [ -ver ] [ -v ] [--about ]
#             [--history] [--his ]
#             [] [ text ] [ dialog ] [ whiptail ]
#    Uses: None.
# Outputs: GUI, ERROR.
#
f_arguments () {
      # If there is more than one argument, display help USAGE message, because only one argument is allowed.
      if [ $# -ge 2 ] ; then
         f_help_message text
         exit 0  # This cleanly closes the process generated by #!bin/bash. 
                 # Otherwise every time this script is run, another instance of
                 # process /bin/bash is created using up resources.
      fi
      #
      case $1 in
           "-?" | -h | --help)
           # If the one argument is "--help" display help USAGE message.
           f_help_message text
           exit 0  # This cleanly closes the process generated by #!bin/bash. 
                   # Otherwise every time this script is run, another instance of
                   # process /bin/bash is created using up resources.
           ;;
           -v | --ver | --version | --about)
           f_about text
           exit 0  # This cleanly closes the process generated by #!bin/bash. 
                   # Otherwise every time this script is run, another instance of
                   # process /bin/bash is created using up resources.
           ;;
           --his | --history)
           f_code_history text
           exit 0  # This cleanly closes the process generated by #!bin/bash. 
                   # Otherwise every time this script is run, another instance of
                   # process /bin/bash is created using up resources.
           ;;
           -*)
           # If the one argument is "-<unrecognized>" display help USAGE message.
           f_help_message text
           exit 0  # This cleanly closes the process generated by #!bin/bash. 
                   # Otherwise every time this script is run, another instance of
                   # process /bin/bash is created using up resources.
           ;;
           "" | "text" | "dialog" | "whiptail")
           GUI=$1
           ;;
           *)
           # Display help USAGE message.
           f_help_message text
           exit 0  # This cleanly closes the process generated by #!bin/bash. 
                   # Otherwise every time this script is run, another instance of
                   # process /bin/bash is created using up resources.
           ;;
      esac
} # End of function f_arguments.
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
# +------------------------------------+
# |          Function f_about          |
# +------------------------------------+
#
#  Inputs: $1=GUI (May or may not exist).
#          THIS_FILE, VERSION.
#    Uses: None.
# Outputs: None.
#
f_about () {
      case $GUI in
           "dialog" | "whiptail") 
           f_about_gui $GUI
           ;;
           *)
           f_about_txt
           ;;
      esac
} # End of f_about.
#
# +------------------------------------+
# |        Function f_about_txt        |
# +------------------------------------+
#
#  Inputs: None.
#          THIS_FILE, VERSION.
#    Uses: None.
# Outputs: None.
#
f_about_txt () {
      #
      # The variable $THIS_FILE is set to a library file when
      # menu is generated so it needs to be reset to "menu.sh".
      THIS_FILE="menu.sh"
      TEMP_FILE=$THIS_FILE"_temp.txt"
      #
      clear # Blank the screen.
      echo
      echo "Script: $THIS_FILE. Version: $VERSION" >$TEMP_FILE
      echo >>$TEMP_FILE
      #
      # Display text (all lines beginning with "#@" but do not print "#@").
      # sed reads each line of this file and substitutes null for "#@"
      # at the beginning of each line so it is not printed.
      sed -n 's/^#@//'p $THIS_DIR/$THIS_FILE >> $TEMP_FILE
      #
      # less -P customizes prompt for
      # %f <FILENAME> page <num> of <pages> (Spacebar, PgUp/PgDn . . .)
      less -P '(Spacebar, PgUp/PgDn, Up/Dn arrows, press q to quit)' $TEMP_FILE
      #
      if [ -r $TEMP_FILE ] ; then
         rm $TEMP_FILE
      fi
} # End of f_about_txt.
#
# +------------------------------------+
# |        Function f_about_gui        |
# +------------------------------------+
#
#  Inputs: $1=GUI - "dialog" or "whiptail" The CLI GUI application in use.
#          THIS_FILE, VERSION.
#    Uses: None.
# Outputs: None.
#
f_about_gui () {
      #
      # The variable $THIS_FILE is set to a library file when
      # menu is generated so it needs to be reset to "menu.sh".
      THIS_FILE="menu.sh"
      TEMP_FILE=$THIS_FILE"_temp.txt"
      #
      echo "Script: $THIS_FILE. Version: $VERSION" >$TEMP_FILE
      echo >>$TEMP_FILE
      #
      # Display text (all lines beginning with "#@" but do not print "#@").
      # sed reads each line of this file and substitutes null for "#@"
      # at the beginning of each line so it is not printed.
      sed -n 's/^#@//'p $THIS_DIR/$THIS_FILE >> $TEMP_FILE
      #
      # Calculate longest line length in TEMP_FILE to find maximum menu width for Dialog or Whiptail.
      # The "Word Count" wc command output will not include the TEMP_FILE name
      # if you redirect "<$TEMP_FILE" into wc.
      X=$(wc --max-line-length <$TEMP_FILE)
      let X=X+6
      #
      # Calculate number of lines or Menu Choices to find maximum menu lines for Dialog or Whiptail.
      Y=$(wc --lines <$TEMP_FILE)
      let Y=Y+6
      #
      $1 --title "About $THIS_FILE (use arrow keys to scroll up/down/side-ways)" --textbox $TEMP_FILE $Y $X
      #
      if [ -r $TEMP_FILE ] ; then
         rm $TEMP_FILE
      fi
} # End of f_about_gui.
#
# +------------------------------------+
# |      Function f_code_history       |
# +------------------------------------+
#
#  Inputs: $1=GUI (May or may not exist).
#          THIS_FILE, VERSION.
#    Uses: None.
# Outputs: None.
#
f_code_history () {
      case $GUI in
           "dialog" | "whiptail") 
           f_code_history_gui $GUI
           ;;
           *)
           f_code_history_txt
           ;;
       esac
} # End of f_code_history.
#
# +----------------------------------------+
# |       Function f_code_history_txt      |
# +----------------------------------------+
#
#  Inputs: THIS_DIR, THIS_FILE.
#    Uses: None.
# Outputs: None.
#
f_code_history_txt () {
      #
      # The variable $THIS_FILE is set to a library file when
      # menu is generated so it needs to be reset to "menu.sh".
      THIS_FILE="menu.sh"
      TEMP_FILE=$THIS_FILE"_temp.txt"
      #
      clear # Blank the screen.
      echo
      #
      echo "Script: $THIS_FILE. Version: $VERSION" >$TEMP_FILE
      echo >>$TEMP_FILE
      #
      # Display text (all lines beginning with "##" but do not print "##").
      # sed reads each line of this file and substitutes null for "##"
      # at the beginning of each line so it is not printed.
      sed -n 's/^##//'p $THIS_DIR/$THIS_FILE >> $TEMP_FILE
      #
      # less -P customizes prompt for
      # %f <FILENAME> page <num> of <pages> (Spacebar, PgUp/PgDn . . .)
      less -P '(Spacebar, PgUp/PgDn, Up/Dn arrows, press q to quit)' $TEMP_FILE
      #
      if [ -r $TEMP_FILE ] ; then
         rm $TEMP_FILE
      fi
} # End of function f_code_history_txt.
#
# +----------------------------------------+
# |       Function f_code_history_gui      |
# +----------------------------------------+
#
#  Inputs: $1=GUI - "dialog" or "whiptail" The CLI GUI application in use.
#          THIS_DIR, THIS_FILE.
#    Uses: None.
# Outputs: temp.txt.
#
f_code_history_gui () {
      #
      # The variable $THIS_FILE is set to a library file when
      # menu is generated so it needs to be reset to "menu.sh".
      THIS_FILE="menu.sh"
      TEMP_FILE=$THIS_FILE"_temp.txt"
      #
      echo "Script: $THIS_FILE. Version: $VERSION" >$TEMP_FILE
      echo >>$TEMP_FILE
      #
      # Display text (all lines beginning with "#@" but do not print "#@").
      # sed substitutes null for "#@" at the beginning of each line
      # so it is not printed.
      sed -n 's/^##//'p $THIS_DIR/$THIS_FILE >>$TEMP_FILE
      #
      # Calculate longest line length in TEMP_FILE to find maximum menu width for Dialog or Whiptail.
      # The "Word Count" wc command output will not include the TEMP_FILE name
      # if you redirect "<$TEMP_FILE" into wc.
      X=$(wc --max-line-length <$TEMP_FILE)
      let X=X+10
      #
      # Calculate number of lines or Menu Choices to find maximum menu lines for Dialog or Whiptail.
      Y=$(wc --lines <$TEMP_FILE)
      let Y=Y+6
      #
      $1 --title "Code History (use arrow keys to scroll up/down/side-ways)" --textbox $TEMP_FILE $Y $X
      #
      if [ -r $TEMP_FILE ] ; then
         rm $TEMP_FILE
      fi
} # End of function f_code_history_gui.
#
# +------------------------------------+
# |      Function f_help_message       |
# +------------------------------------+
#
#  Inputs: $1=GUI (May or may not exist).
#    Uses: None.
# Outputs: None.
#
f_help_message () {
      case $GUI in
           "dialog" | "whiptail") 
           f_help_message_gui $GUI
           ;;
           *)
           f_help_message_txt
           ;;
      esac
} # End of f_code_history.
#
# +----------------------------------------+
# |     Function f_help_message_txt        |
# +----------------------------------------+
#
#  Inputs: None.
#    Uses: None.
# Outputs: None.
#
f_help_message_txt () {
      #
      # The variable $THIS_FILE is set to a library file when
      # menu is generated so it needs to be reset to "menu.sh".
      THIS_FILE="menu.sh"
      TEMP_FILE=$THIS_FILE"_temp.txt"
      #
      clear # Blank the screen.
      echo
      #
      echo "Script: $THIS_FILE. Version: $VERSION" >$TEMP_FILE
      echo >>$TEMP_FILE
      #
      # Display text (all lines beginning with "#?" but do not print "#?").
      # sed reads each line of this file and substitutes null for "#?"
      # at the beginning of each line so it is not printed.
      sed -n 's/^#?//'p $THIS_DIR/$THIS_FILE >> $TEMP_FILE
      #
      # less -P customizes prompt for
      # %f <FILENAME> page <num> of <pages> (Spacebar, PgUp/PgDn . . .)
      less -P '(Spacebar, PgUp/PgDn, Up/Dn arrows, press q to quit)' $TEMP_FILE
      #
      if [ -r $TEMP_FILE ] ; then
         rm $TEMP_FILE
      fi
} # End of function f_help_message_txt.
#
# +----------------------------------------+
# |     Function f_help_message_gui        |
# +----------------------------------------+
#
#  Inputs: $1=GUI - "dialog" or "whiptail" the preferred user-interface.
#    Uses: None.
# Outputs: None.
#
f_help_message_gui () {
      #
      # The variable $THIS_FILE is set to a library file when
      # menu is generated so it needs to be reset to "menu.sh".
      THIS_FILE="menu.sh"
      TEMP_FILE=$THIS_FILE"_temp.txt"
      #
      echo "Script: $THIS_FILE. Version: $VERSION" >$TEMP_FILE
      echo >>$TEMP_FILE
      #
      # Display text (all lines beginning with "#@" but do not print "#@").
      # sed substitutes null for "#@" at the beginning of each line
      # so it is not printed.
      sed -n 's/^#?//'p $THIS_DIR/$THIS_FILE >>$TEMP_FILE
      #
      # Calculate longest line length in TEMP_FILE to find maximum menu width for Dialog or Whiptail.
      # The "Word Count" wc command output will not include the TEMP_FILE name
      # if you redirect "<$TEMP_FILE" into wc.
      X=$(wc --max-line-length <$TEMP_FILE)
      let X=X+10
      #
      # Calculate number of lines or Menu Choices to find maximum menu lines for Dialog or Whiptail.
      Y=$(wc --lines <$TEMP_FILE)
      let Y=Y+6
      #
      $1 --title "Help Message (use arrow keys to scroll up/down/side-ways)" --textbox $TEMP_FILE $Y $X
      #
      if [ -r $TEMP_FILE ] ; then
         rm $TEMP_FILE
      fi
} # End of f_help_message_gui.
#
# +----------------------------------------+
# |        Function f_menu_arrays          |
# +----------------------------------------+
#
#  Inputs: $1=file of menu choice strings.
#    Uses: ARRAY_NUM, ARRAY_NAME, ARRAY_VALUE, TEMP_FILE, XSTR.
# Outputs: MAX_CHOICE_LENGTH. arrays CHOICE(n), SUMMARY(n), FUNC(n). 
#
f_menu_arrays () {
      # Create arrays CHOICE, SUMMARY, FUNC to store menu option information.
      #
      # Example:
      # Menu option name is "Directory Listing"
      # Shared directory to be mounted is "//hansolo/public/contacts"
      # Local PC mount-point is "/mnt/hansolo/contacts"
      #
      #     CHOICE[1]="Directory Listing"
      #     SUMMARY[1]="get a listing of files in a directory."
      #     FUNC[1]="f_dir_listing"     # Function to do command "ls -l".
      #
      unset CHOICE SUMMARY FUNC  # Delete arrays in memory.
      ARRAY_NUM=1
      TEMP_FILE="menu_temp.txt"
      #
      #                 Field-1 (null)  Field-2                      Field-3                     Field-4
      # Format of XSTR="<Delimiter> <Choice Title> <Delimiter> <Short Description> <Delimiter> <function>"
      #
      if [ -r $TEMP_FILE ] ; then
         rm $TEMP_FILE
      fi
      #
      while read XSTR
      do
            case $XSTR in
                  \#@@*) echo $XSTR >>$TEMP_FILE
                  ;;
            esac
      done < $1  # Read lines from file $1.
      #
      # Delete last line which is from the case statement pattern immediately above.
      sed -i /echo*/d $TEMP_FILE # Delete last line in $TEMP_FILE which is actual code not data.
      #
      # Calculate longest line length in TEMP_FILE to find maximum menu width for Dialog or Whiptail.
      # The "Word Count" wc command output will not include the TEMP_FILE name
      # when you redirect "<$TEMP_FILE" into wc.
      MAX_LENGTH=$(wc --max-line-length <$TEMP_FILE)
      #
      # Calculate number of lines or Menu Choices to find maximum menu lines for Dialog or Whiptail.
      MAX_LINES=$(wc --lines <$TEMP_FILE)
      #
      MAX_CHOICE_LENGTH=0
      #
      while read XSTR
      do
            # Set array CHOICE[n] = <field-1> or "Choice Title" of XSTR.
            ARRAY_NAME="CHOICE"
            ARRAY_VALUE=$(echo $XSTR | awk -F "#@@" '{ if ( $3 ) { print $2 }}')
            ARRAY_VALUE=$(echo $ARRAY_VALUE | tr ' ' '_')
            eval $ARRAY_NAME[$ARRAY_NUM]=$ARRAY_VALUE
            #
            # Calculate length of next Menu Option Choice string.
                CHOICE_LENGTH=${#ARRAY_VALUE}
                # Save the value of the longest length of the Menu Option.
                if [ $CHOICE_LENGTH -gt $MAX_CHOICE_LENGTH ] ; then
                   # Save new maximum string length.
                   MAX_CHOICE_LENGTH=$CHOICE_LENGTH
                fi
            #
            # Set array SUMMARY[n]=<field-2> or "Summary" of XSTR.
            ARRAY_NAME="SUMMARY"
            ARRAY_VALUE=$(echo $XSTR | awk -F "#@@" '{ if ( $3 ) { print $3 }}')
            ARRAY_VALUE=$(echo $ARRAY_VALUE | tr ' ' '_')
            eval $ARRAY_NAME[$ARRAY_NUM]=$ARRAY_VALUE
            #
            # Set array $FUNC=<field-3> or "Function" of XSTR.
            ARRAY_NAME="FUNC"
            ARRAY_VALUE=$(echo $XSTR | awk -F "#@@" '{ if ( $3 ) { print $4 }}')
            ARRAY_VALUE=$(echo $ARRAY_VALUE | tr ' ' '_')
            eval $ARRAY_NAME[$ARRAY_NUM]=$ARRAY_VALUE
            #
            let ARRAY_NUM=$ARRAY_NUM+1
      done < $TEMP_FILE
      #
      if [ -r $TEMP_FILE ] ; then
         rm $TEMP_FILE
      fi
      unset TEMP_FILE XSTR  # Throw out this variable.
} # End of f_menu_arrays.
#
# +----------------------------------------+
# |        Function f_update_menu_txt      |
# +----------------------------------------+
#
#  Inputs: $1=GUI - "dialog" or "whiptail" The CLI GUI application in use.
#          $2=GENERATED_FILE.
#          $3=Menu Title.
#          $4=MAX_CHOICE_LENGTH.
#    Uses: X, Y, XNUM, YNUM, ARRAY_NAME, ARRAY_LEN, PAD, CHOICE.
# Outputs: None.
#
f_update_menu_txt () {
      echo "#!/bin/bash" >$2
      echo "#" >>$2
      grep --max-count=1 Copyright $THIS_FILE >>$2
      echo "#" >>$2
      echo "# Usage: bash menu.sh" >>$2
      echo "#        (not sh menu.sh)" >>$2
      echo "#" >>$2
      echo "VERSION=\"$VERSION\"" >>$2
      echo "#" >>$2
      echo "#***********************************CAUTION***********************************" >>$2
      echo "# Any edits made to this code will be lost since this code is" >>$2
      echo "# automatically generated and updated by running the script," >>$2
      echo "# \"menu.sh\" which contains data for the menu." >>$2
      echo "#***********************************CAUTION***********************************" >>$2
      echo "#" >>$2
      echo "# +----------------------------------------+" >>$2
      echo "# |           Function f_menu_txt          |" >>$2
      echo "# +----------------------------------------+" >>$2
      echo "#" >>$2
      echo "#  Inputs: $1=GUI" >>$2
      echo "#    Uses: X, MENU_TITLE, ARRAY_NAME, ARRAY_LEN, CHOICE, SUMMARY, FUNC." >>$2
      echo "# Outputs: None." >>$2
      echo "#" >>$2
      echo "f_menu_txt () {" >>$2
      echo "      . $ARRAY_FILE   # invoke the necessary files". >>$2
      echo "      #" >>$2
      echo "      CHOICE=\"\"  # Initialize variable." >>$2
      echo "      until [ \"\$CHOICE\" = \"QUIT\" ]" >>$2
      echo "            do    # Start of menu until loop." >>$2
      echo "               clear  #Clear screen." >>$2
      MENU_TITLE=$(echo $3 | tr '_' ' ') # Do not >>$2 this line.
      echo "               MENU_TITLE=\"$MENU_TITLE\"" >>$2
      echo "               echo \"               \$MENU_TITLE\"; echo" >>$2
      #
      # Get display screen or window size to get maximum width.
      # Get the screen resolution or X-window size.
      # Get rows (height).
      Y=$(stty size | awk '{ print $1 }')
      # Get columns (width).
      X=$(stty size | awk '{ print $2 }')
      #
      # Read both CHOICE and SUMMARY arrays and format strings to display
      # in a pretty formatted menu.
      ARRAY_NAME="CHOICE"
      ARRAY_LEN=$(eval "echo \$\{#$ARRAY_NAME[@]\}")
      ARRAY_LEN=$(eval echo $ARRAY_LEN)
      TEMP_FILE="menu_temp.txt"
      #
      for (( XNUM=1; XNUM<=${ARRAY_LEN}; XNUM++ ));
          do
             ARRAY_NAME="CHOICE"
             CHOICE=$(eval "echo \$\{$ARRAY_NAME[$XNUM]\}")
             CHOICE=$(eval echo $CHOICE)
             CHOICE=$(echo $CHOICE | tr '_' ' ')
             # CHOICE_LC is a lower-case CHOICE string for the purpose of easier pattern matching in a case statement.
             CHOICE_LC=$(echo $CHOICE | tr \'[:upper:]\' \'[:lower:]\')
             #
             ARRAY_NAME="SUMMARY"
             SUMMARY=$(eval "echo \$\{$ARRAY_NAME[$XNUM]\}")
             SUMMARY=$(eval echo $SUMMARY)
             SUMMARY=$(echo $SUMMARY | tr '_' ' ')
             #
             ARRAY_NAME="FUNC"
             FUNC=$(eval "echo \$\{$ARRAY_NAME[$XNUM]\}")
             FUNC=$(eval echo $FUNC)
             #
             let YNUM=$XNUM-1  # Start numbering choices from zero so zero selects CHOICE[1]
             #
             # Save the pattern matching for the case statement which is later inserted into the function, "f_menu_txt".
             echo "                    $YNUM | \"${CHOICE_LC:0:1}\" | \"${CHOICE_LC:0:2}\" | \"${CHOICE_LC:0:3}\" | \"${CHOICE_LC:0:4}\" | \"${CHOICE_LC:0:5}\" | \"${CHOICE_LC:0:6}\" | \"${CHOICE_LC:0:7}\" | \"${CHOICE_LC:0:8}\" | \"${CHOICE_LC:0:9}\" | \"${CHOICE_LC:0:10}\" | \"${CHOICE_LC:0:11}\" | \"${CHOICE_LC:0:12}\" | \"${CHOICE_LC:0:13}\" | \"${CHOICE_LC:0:14}\" | \"${CHOICE_LC:0:15}\"*) $FUNC  ;;" >>$TEMP_FILE
             #
             if [ -n "$CHOICE" ] ; then
                # Read next Menu Option Choice string and get its string length.
                CHOICE_LENGTH=${#CHOICE}
                if [ $CHOICE_LENGTH -lt $4 ] ; then
                   let PAD=$4-$CHOICE_LENGTH
                   until [ $PAD -eq 0 ]
                   do
                      # Pad spaces to right (left-justify CHOICE).
                      # CHOICE     - Summary description.
                      CHOICE=$CHOICE" "
                      #
                      # Pad spaces to left (right-justify CHOICE).
                      #     CHOICE - Summary description.
                      #CHOICE=" "$CHOICE
                      #
                      let PAD=$PAD-1
                   done
                fi
                # Truncate "CHOICE - Summary description"
                # if longer than maximum window or screen width.
                #
                # Example: "$YNUM $CHOICE - $SUMMARY"
                # CHOICE="0 Quit - Quit to command-line prompt." where array CHOICE[1]="Quit"
                CHOICE="$YNUM $CHOICE - $SUMMARY"
                CHOICE_LENGTH=${#CHOICE}
                # Is the length of string CHOICE plus SUMMARY > Maximum window width?
                if [ $CHOICE_LENGTH -gt $X ] ; then
                   # Yes, truncate SUMMARY length to fit maximum window or screen width.
                   let X=$X-3
                   CHOICE=${CHOICE:0:$X}"..."
                fi
                # No, leave length alone, just print to screen.
                echo "               echo \"$CHOICE\"" >>$2
             fi
          done
      echo "               echo" >>$2
      echo "               echo -n \" Enter 0-$YNUM or letters (0): \" ; read CHOICE" >>$2
      echo "               #CHOICE Convert to lower-case." >>$2
      echo "               CHOICE=\$(echo \$CHOICE | tr \'[:upper:]\' \'[:lower:]\')" >>$2
      echo "               #" >>$2
      echo "               case \$CHOICE in" >>$2
      echo "                    \"\") CHOICE=\"QUIT\" ;;  # Set default choice pattern match." >>$2
      # Case pattern matching statements are read from TEMP_FILE to be included here.
      cat $TEMP_FILE >>$2
      echo "               esac" >>$2
      echo "           done" >>$2
      echo "       unset MENU_TITLE CHOICE  # Throw out this variable." >>$2
      echo "       #" >>$2
      echo "       } # End of function f_menu_txt." >>$2
      #
      # Remove $TEMP_FILE.
      if [ -r $TEMP_FILE ] ; then
         rm $TEMP_FILE
      fi
      unset X Y XNUM YNUM MENU_TITLE ARRAY_NAME ARRAY_LEN CHOICE SUMMARY FUNC
} # End of function f_update_menu_txt.
#
# +----------------------------------------+
# |        Function f_update_menu_gui      |
# +----------------------------------------+
#
#  Inputs: $1=GUI - "dialog" or "whiptail" The CLI GUI application in use.
#          $2=GENERATED_FILE.
#          $3=Menu Title.
#          $4=MAX_LENGTH
#          $5=MAX_LINES
#    Uses: GENERATED_FILE, ARRAY_NAME, ARRAY_LEN, XNUM.
# Outputs: None.
#
f_update_menu_gui () {
      echo "#!/bin/bash" >$2
      echo "#" >>$2
      grep --max-count=1 Copyright $THIS_FILE >>$2
      echo "#" >>$2
      echo "# Usage: bash menu.sh" >>$2
      echo "#        (not sh menu.sh)" >>$2
      echo "#" >>$2
      echo "VERSION=\"$VERSION\"" >>$2
      echo "#" >>$2
      echo "#***********************************CAUTION***********************************" >>$2
      echo "# Any edits made to this code will be lost since this code is" >>$2
      echo "# automatically generated and updated by running the script," >>$2
      echo "# \"menu.sh\" which contains data for the Main menu." >>$2
      echo "#***********************************CAUTION***********************************" >>$2
      echo "#" >>$2
      echo "# +----------------------------------------+" >>$2
      echo "# |           Function f_menu_gui          |" >>$2
      echo "# +----------------------------------------+" >>$2
      echo "#" >>$2
      echo "#  Inputs: \$1=GUI." >>$2
      echo "#          \$2=MENU_TITLE" >>$2
      echo "#    Uses: VERSION, THIS_FILE, CHOICE, SUMMARY, MENU_TITLE." >>$2
      echo "# Outputs: None." >>$2
      echo "#" >>$2
      echo "f_menu_gui () {" >>$2
      echo "      . $ARRAY_FILE   # invoke the necessary files". >>$2
      echo "      #" >>$2
      echo "      # CHOICE=\"\"  # Initialize variable." >>$2
      #
      # Get the screen resolution or X-window size.
      # Get rows (height).
      Y=$(stty size | awk '{ print $1 }')
      # Get columns (width).
      X=$(stty size | awk '{ print $2 }')
      #
      echo "      until [ \"\$CHOICE\" = \"QUIT\" ]" >>$2
      echo "            do    # Start of Menu until loop." >>$2
                           MENU_TITLE=$(echo $3 | tr '_' ' ')
      echo "               MENU_TITLE=\"$MENU_TITLE\"" >>$2
      # If screen or window width is greater than MAX_LENGTH_UI (number of characters).
      # Then shrink menu display to fit number of characters.
      if [ $X -gt $4 ] ; then
         X=$4
      fi
      #
      # Pad vertical menu box display for a minimum display area.
      if [ $Y -gt $5 ] ; then
         let Y=$5+9
      fi
      #      
      echo "               CHOICE=\$(\$GUI --clear --title \"\$MENU_TITLE\" --menu \"\n\nUse (up/down arrow keys) or (letters):\" $Y $X $Y \\" >>$2
      TEMP_FILE="menu_temp.txt"
      ARRAY_NAME="CHOICE"
      ARRAY_LEN=$(eval "echo \$\{#$ARRAY_NAME[@]\}")
      ARRAY_LEN=$(eval echo $ARRAY_LEN)
            for (( XNUM=1; XNUM<=${ARRAY_LEN}; XNUM++ ));
                do
                   ARRAY_NAME="CHOICE"
                   CHOICE=$(eval "echo \$\{$ARRAY_NAME[$XNUM]\}")
                   CHOICE=$(eval echo $CHOICE)
                   CHOICE=$(echo $CHOICE | tr '_' ' ')
                   #
                   ARRAY_NAME="SUMMARY"
                   SUMMARY=$(eval "echo \$\{$ARRAY_NAME[$XNUM]\}")
                   SUMMARY=$(eval echo $SUMMARY)
                   SUMMARY=$(echo $SUMMARY | tr '_' ' ')
                   #
                   ARRAY_NAME="FUNC"
                   FUNC=$(eval "echo \$\{$ARRAY_NAME[$XNUM]\}")
                   FUNC=$(eval echo $FUNC)
                   #
                   if [ -n "$CHOICE" ] ; then
                      echo "                     \"$CHOICE\" \"$SUMMARY\" \\" >>$2
                      echo "                    \"$CHOICE\") $FUNC  ;;" >>$TEMP_FILE
                   fi
                done
      echo "               2>&1 >/dev/tty)" >>$2
      echo "               case \$CHOICE in" >>$2
      # Case pattern matching statements are read from TEMP_FILE to be included here.
      cat $TEMP_FILE >>$2
      echo "               esac" >>$2
      echo "            done" >>$2
      echo "       unset MENU_TITLE CHOICE  # Throw out this variable." >>$2
      echo "       #" >>$2
      echo "       } # End of function f_menu_gui." >>$2
      #
      # Remove $TEMP_FILE.
      if [ -r $TEMP_FILE ] ; then
         rm $TEMP_FILE
      fi
      unset X Y XNUM TEMP_FILE ARRAY_NAME ARRAY_LEN CHOICE SUMMARY FUNC 
} # End of function f_update_menu_gui.
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
      ARRAY_FILE="$THIS_DIR/menu_module_main.lib"
      f_menu_arrays $ARRAY_FILE
      #
      # Create generated menu script from array data.
      GENERATED_FILE="$THIS_DIR/menu_generated.lib"
      MENU_TITLE="Main_Menu"  # Menu title must substitute underscores for spaces
      f_create_show_menu $GUI $GENERATED_FILE $MENU_TITLE $MAX_LENGTH $MAX_LINES $MAX_CHOICE_LENGTH
} # End of function f_main_menu.
#
# +----------------------------------------+
# |       Function f_create_show_menu      |
# +----------------------------------------+
#
#  Inputs: $1=GUI - "dialog" or "whiptail" The CLI GUI application in use.
#          $2=GENERATED_FILE.
#          $3=Menu Title.
#          $4=MAX_LENGTH.
#          $5=MAX_LINES.
#          $6=MAX_CHOICE_LENGTH
#    Uses: GENERATED_FILE, ARRAY_NAME, ARRAY_LEN, XNUM.
# Outputs: None.
#
f_create_show_menu () {
      case $1 in
           "dialog" | "whiptail")
           f_update_menu_gui $1 $2 $3 $4 $5
           ;;
           "text")
           f_update_menu_txt $1 $2 $3 $6
           ;;
      esac
      #
      . $2  # Invoke Generated file.
      #
      # Use generated menu script to display menu.
      case $1 in
           "dialog" | "whiptail") 
           f_menu_gui $1 $3
           clear  # Clear screen.
           ;;
           "text")
           f_menu_txt
           ;;
       esac
      #
      if [ -r $2 ] ; then
         rm $2
      fi
} # End of function f_create_show_menu.
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
# Set THIS_DIR, SCRIPT_PATH to directory path of script.
f_script_path
#
# Test for Optional Arguments.
f_arguments $1  # Also sets variable GUI.
#
# If command already specifies GUI, then do not detect GUI i.e. "bash dropfsd.sh dialog" or "bash dropfsd.sh text".
if [ -z $GUI ] ; then
   # Test for GUI (Whiptail or Dialog) or pure text environment.
   f_detect_ui
fi
#
#GUI="whiptail"  #Test diagnostic line.
#GUI="dialog"    #Test diagnostic line.
#GUI="text"       #Test diagnostic line.
#
# Test for BASH environment.
f_test_environment
#
# Include library file menu_module_main.lib
. /$THIS_DIR/menu_module_main.lib
#
f_main_menu
#
exit 0  # This cleanly closes the process generated by #!bin/bash. 
        # Otherwise every time this script is run, another instance of
        # process /bin/bash is created using up resources.
# all dun dun noodles.
