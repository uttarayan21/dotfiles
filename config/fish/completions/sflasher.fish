complete -c sflasher -n "__fish_use_subcommand" -s h -l help -d 'Print help information'
complete -c sflasher -n "__fish_use_subcommand" -f -a "list" -d 'List the connected keyboards supported by this tool'
complete -c sflasher -n "__fish_use_subcommand" -f -a "firmware" -d 'Operation on a specific keyboard'
complete -c sflasher -n "__fish_use_subcommand" -f -a "flash"
complete -c sflasher -n "__fish_use_subcommand" -f -a "reboot"
complete -c sflasher -n "__fish_use_subcommand" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c sflasher -n "__fish_seen_subcommand_from list" -s v -l verbose -d 'Print the devices in verbose mode'
complete -c sflasher -n "__fish_seen_subcommand_from list" -s b -l bootloader -d 'Show devices in bootloader mode'
complete -c sflasher -n "__fish_seen_subcommand_from list" -s n -l normal -d 'Show devices in normal mode'
complete -c sflasher -n "__fish_seen_subcommand_from list" -s a -l all -d 'Show devices in any mode'
complete -c sflasher -n "__fish_seen_subcommand_from list" -s h -l help -d 'Print help information'
complete -c sflasher -n "__fish_seen_subcommand_from firmware; and not __fish_seen_subcommand_from check; and not __fish_seen_subcommand_from help" -s h -l help -d 'Print help information'
complete -c sflasher -n "__fish_seen_subcommand_from firmware; and not __fish_seen_subcommand_from check; and not __fish_seen_subcommand_from help" -f -a "check"
complete -c sflasher -n "__fish_seen_subcommand_from firmware; and not __fish_seen_subcommand_from check; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c sflasher -n "__fish_seen_subcommand_from firmware; and __fish_seen_subcommand_from check" -s h -l help -d 'Print help information'
complete -c sflasher -n "__fish_seen_subcommand_from firmware; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from check; and not __fish_seen_subcommand_from help" -f -a "check"
complete -c sflasher -n "__fish_seen_subcommand_from firmware; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from check; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c sflasher -n "__fish_seen_subcommand_from flash" -s k -l keyboard -d 'The path to the keyboard' -r
complete -c sflasher -n "__fish_seen_subcommand_from flash" -s o -l offset -d 'The offset to flash from' -r
complete -c sflasher -n "__fish_seen_subcommand_from flash" -s h -l help -d 'Print help information'
complete -c sflasher -n "__fish_seen_subcommand_from reboot" -s h -l help -d 'Print help information'
complete -c sflasher -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from firmware; and not __fish_seen_subcommand_from flash; and not __fish_seen_subcommand_from reboot; and not __fish_seen_subcommand_from help" -f -a "list" -d 'List the connected keyboards supported by this tool'
complete -c sflasher -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from firmware; and not __fish_seen_subcommand_from flash; and not __fish_seen_subcommand_from reboot; and not __fish_seen_subcommand_from help" -f -a "firmware" -d 'Operation on a specific keyboard'
complete -c sflasher -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from firmware; and not __fish_seen_subcommand_from flash; and not __fish_seen_subcommand_from reboot; and not __fish_seen_subcommand_from help" -f -a "flash"
complete -c sflasher -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from firmware; and not __fish_seen_subcommand_from flash; and not __fish_seen_subcommand_from reboot; and not __fish_seen_subcommand_from help" -f -a "reboot"
complete -c sflasher -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from firmware; and not __fish_seen_subcommand_from flash; and not __fish_seen_subcommand_from reboot; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c sflasher -n "__fish_seen_subcommand_from help; and __fish_seen_subcommand_from firmware; and not __fish_seen_subcommand_from check" -f -a "check"
