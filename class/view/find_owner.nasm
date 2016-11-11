%include 'inc/func.ninc'
%include 'class/class_view.ninc'

def_func class/view/find_owner
	;inputs
	;r0 = view object
	;outputs
	;r1 = 0, else tcb of owner
	;trashes
	;r2

	;walk up tree to parent
	vp_cpy r0, r2
	loop_while r2, !=, 0
		vp_cpy [r2 + view_tcb], r1
		vp_cpy [r2 + view_parent], r2
		continueif r1, ==, 0
		vp_ret
	loop_end
	vp_xor r1, r1
	vp_ret

def_func_end
