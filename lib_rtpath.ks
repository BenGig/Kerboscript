
function runpath_rt {
	parameter filepath.

	if addons::available("RT") {
	  if RTAddon::hasksconnection(ship) {
		if exists("0:" + filepath) {
		  runpath("0:" + filepath).
		  return.
		}
	  } 
	}
	runpath(filepath).
}