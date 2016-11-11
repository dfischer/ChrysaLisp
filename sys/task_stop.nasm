%include 'inc/func.ninc'
%include 'inc/task.ninc'

def_func sys/task_stop
	;remove task control block
	f_bind sys_task, statics, r0
	vp_cpy [r0 + tk_statics_current_tcb], r1
	vp_cpy r1, r2
	ln_remove_node r2, r15

	;decrement task count
	vp_cpy [r0 + tk_statics_task_count], r2
	vp_dec r2
	vp_cpy r2, [r0 + tk_statics_task_count]

	;free our task control block
	vp_sub ptr_size, r1
	vp_cpy [r1], r0
	hp_freecell r0, r1, r2
	f_jmp sys_task, restore

def_func_end
