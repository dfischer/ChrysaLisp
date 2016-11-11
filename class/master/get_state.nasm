%include 'inc/func.ninc'
%include 'class/class_master.ninc'

def_func class/master/get_state
	;inputs
	;r0 = master object
	;outputs
	;r0 = master object
	;r1 = current state

	vp_cpy [r0 + master_state], r1
	vp_ret

def_func_end
