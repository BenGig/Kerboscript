copypath("0:/lib/lib_list_dialog.ks", "1:").
copypath("0:/lib/lib_menu.ks", "1:").
copypath("0:/lib/lib_ui.ks", "1:").
copypath("0:/lib/lib_gui_box.ks", "1:").
copypath("0:/lib/spec_char.ksm", "1:").
copypath("0:/fueler.ks", "1:").

until 0 {
  runpath("fueler.ks").
}