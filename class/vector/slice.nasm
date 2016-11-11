%include 'inc/func.ninc'
%include 'class/class_vector.ninc'

def_func class/vector/slice
	;inputs
	;r0 = vector object
	;r1 = vector element start
	;r2 = vector element end
	;outputs
	;r0 = vector object
	;r1 = slice vector object
	;trashes
	;r1-r3, r5-r12

	;save inputs
	set_src r0, r1, r2
	set_dst r9, r10, r11
	map_src_to_dst

	;create new vector
	f_call vector, create, {}, {r12}
	vp_cpy r11, r1
	vp_sub r10, r1
	f_call vector, set_capacity, {r0, r1}

	;copy elements
	vp_cpy r10, r5
	vp_cpy r11, r6
	loop_while r5, !=, r6
		d_call vector, ref_element, {r9, r5}, {r1}
		f_call vector, push_back, {r12, r1}
		vp_inc r5
	loop_end

	vp_cpy r9, r0
	vp_cpy r12, r1
	vp_ret

def_func_end
