// Lifter stage

ship:partsdubbed("lifterAntenna")[0]:getmodule("ModuleRTAntenna"):doaction("activate", true).
for panel in ship:partsdubbed("lifterPanel") {
  panel:getmodule("ModuleDeployableSolarPanel"):doaction("extend solar panel", true).
}

// Explorer: stage aero shell and activate antennas
stage.
ship:partsdubbed("coreAntenna")[0]:getmodule("ModuleRTAntenna"):doaction("activate", true).
ship:partsdubbed("coreAntenna")[0]:getmodule("ModuleRTAntenna"):setfield("target", "Kerbin").
ship:partsdubbed("coreAntenna")[1]:getmodule("ModuleRTAntenna"):doaction("activate", true).
ship:partsdubbed("coreAntenna")[1]:getmodule("ModuleRTAntenna"):setfield("target", "Kerbin").

for panel in ship:partsdubbed("corePanel") {
  panel:getmodule("ModuleDeployableSolarPanel"):doaction("extend solar panel", true).
}
