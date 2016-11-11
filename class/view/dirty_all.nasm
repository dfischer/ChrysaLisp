%include 'inc/func.ninc'
%include 'class/class_view.ninc'

def_func class/view/dirty_all
	;inputs
	;r0 = view object
	;trashes
	;all but r0, r4

	;iterate through views
	;dirty all
	f_jmp view, forward_tree, {r0, r0, $dirty_down_callback, $null_up_callback}

dirty_down_callback:
	f_call view, dirty, {r0}
	vp_cpy r0, r1
null_up_callback:
	vp_ret

def_func_end
