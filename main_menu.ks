runoncepath("lib_list_dialog").

set main_actions to list("Maneuver","Mission","Fueling","Exit").
set maneuver_actions to list("Launch","Approach","Dock","Exit").

until 0 {
  set action to open_list_dialog("Select action", main_actions).

  if main_actions[action] = "Exit" { break. }
  if main_actions[action] = "Mission" {
    if exists("mission.ks") {
      runpath("mission.ks").
    }
  }
  print "Action is " + action.
  print "Actions: ".
  print main_actions.
  if action <= main_actions:length and main_actions[action] = "Maneuver" {
    // standard submenu maneuvers
    until 0 {
      set maneuver to open_list_dialog("Select action", maneuver_actions).
      if maneuver_actions[maneuver] = "Exit" { break. }
      if maneuver_actions[maneuver] = "Launch" {
        runpath("0:/generic_launch", 100000).
      }
      if maneuver_actions[maneuver] = "Approach" { runpath("approach.ks"). }
      if maneuver_actions[maneuver] = "Dock" { runpath("dock.ks"). }
    }
  }
}