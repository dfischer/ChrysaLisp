%include 'inc/func.ninc'
%include 'inc/list.ninc'
%include 'inc/task.ninc'

def_func sys/task_resume
	;inputs
	;r0 = task control node (to resume)
	;trashes
	;r1-r2

	;are we in suspend state ?
	vp_cpy [r0], r1
	if r1, ==, 0
		;add to task list
		f_bind sys_task, statics, r1
		vp_cpy [r1 + tk_statics_current_tcb], r1
		ln_add_node_before r1, r0, r2
	endif
	vp_ret

def_func_end
