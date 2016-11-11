%include 'inc/func.ninc'
%include 'class/class_view.ninc'

def_func class/view/change
	;inputs
	;r0 = view object
	;r8 = new x
	;r9 = new y
	;r10 = new w
	;r11 = new h
	;trashes
	;all but r0, r4

	;save old info
	vp_cpy [r0 + view_w], r12
	vp_cpy [r0 + view_h], r13

	;set new info
	f_call view, set_bounds, {r0, r8, r9, r10, r11}

	;layout if changed size
	if r10, ==, r12
		if r11, ==, r13
			vp_ret
		endif
	endif
	v_jmp view, layout, {r0}

def_func_end
