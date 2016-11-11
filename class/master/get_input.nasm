%include 'inc/func.ninc'
%include 'class/class_master.ninc'
%include 'class/class_vector.ninc'

def_func class/master/get_input
	;inputs
	;r0 = master object
	;outputs
	;r0 = master object
	;r1 = input stream object

	vp_cpy [r0 + master_streams], r1
	vp_cpy [r1 + vector_array], r1
	vp_cpy [r1], r1
	vp_ret

def_func_end
