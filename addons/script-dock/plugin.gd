@tool
extends EditorPlugin

var control := MarginContainer.new()
var panel: Control
var default_parent: Control  
var script_editor :ScriptEditor = null
var last_screen:=''

 

func _enter_tree()->void:
	#print(" current screen " ,get_main_screen())
	script_editor = EditorInterface.get_script_editor()
	script_editor.editor_script_changed.connect(script_visibility_changed)
	script_editor.visibility_changed.connect(script_visibility_changed)
	 
	default_parent = script_editor.get_child(0).get_child(1)
	panel = default_parent.get_child(0)
	panel.reparent(control)
	
	control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	control.size_flags_vertical = Control.SIZE_EXPAND_FILL
	control.name = "Scripts"
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BR, control)
	 
	## connect to what screen is active 
	main_screen_changed.connect(screen_changed)
	 
		

func screen_changed(screen)->void:
	last_screen = screen
	if !script_editor && !script_editor.is_visible_in_tree():
		return
	var parent: TabContainer = control.get_parent()
	
	match screen:
		"Script":
			parent.current_tab = control.get_index()
		_:
			parent.current_tab = 0
			
 
func script_visibility_changed(a = null)->void:
	if !script_editor && !script_editor.is_visible_in_tree():
		return
	
	if last_screen=="":
		return
		
	if last_screen=="Script":
		var parent: TabContainer = control.get_parent()
		parent.current_tab = control.get_index()

func _exit_tree():
	panel.reparent(default_parent)
	default_parent.move_child(panel, 0)
	remove_control_from_docks(control)
 
