%include 'inc/func.ninc'
%include 'class/class_text.ninc'
%include 'class/class_label.ninc'

def_func class/label/get_text
	;inputs
	;r0 = label object
	;outputs
	;r0 = label object
	;r1 = 0, else string object

	def_struct local
		ptr local_inst
	def_struct_end

	;save inputs
	vp_sub local_size, r4
	set_src r0
	set_dst [r4 + local_inst]
	map_src_to_dst

	f_call text, get_text, {[r0 + label_text]}, {r1}

	vp_cpy [r4 + local_inst], r0
	vp_add local_size, r4
	vp_ret

def_func_end
