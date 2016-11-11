%include 'inc/func.ninc'
%include 'inc/gui.ninc'
%include 'class/class_title.ninc'
%include 'class/class_window.ninc'

def_func class/title/mouse_down
	;inputs
	;r0 = title object
	;r1 = mouse event message
	;trashes
	;all but r0, r4

	vp_push r0
	vp_cpy [r1 + ev_msg_rx], r8
	vp_cpy [r1 + ev_msg_ry], r9
	vp_cpy r8, [r0 + title_last_x]
	vp_cpy r9, [r0 + title_last_y]
	vp_cpy [r0 + view_parent], r0
	vp_cpy [r0 + view_parent], r0
	f_call window, to_front, {r0}
	vp_pop r0
	vp_ret

def_func_end
