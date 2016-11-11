%include 'inc/func.ninc'
%include 'class/class_flow.ninc'
%include 'class/class_text.ninc'
%include 'class/class_label.ninc'

def_func class/label/init
	;inputs
	;r0 = label object
	;r1 = vtable pointer
	;outputs
	;r1 = 0 if error, else ok

	;init parent
	s_call label, init, {r0, r1}, {r1}
	if r1, !=, 0
		vp_push r0

		;init myself
		;add my flow
		f_call flow, create, {}, {r0}
		assert r0, !=, 0
		f_call flow, set_flags, {r0, 0}
		f_call flow, set_flow_flags, {r0, flow_flag_right | flow_flag_align_vcenter}
		vp_cpy [r4], r1
		vp_cpy r0, [r1 + label_flow]
		f_call flow, add_front, {r0, r1}

		;add my text
		f_call text, create, {}, {r0}
		assert r0, !=, 0
		vp_cpy [r4], r1
		vp_cpy r0, [r1 + label_text]
		f_call text, set_color, {r0, 0}
		vp_cpy [r4], r1
		f_call text, add_front, {r0, [r1 + label_flow]}

		vp_pop r0
	endif
	vp_ret

def_func_end
