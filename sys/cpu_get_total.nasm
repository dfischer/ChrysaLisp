%include 'inc/func.ninc'
%include 'inc/task.ninc'

def_func sys/cpu_get_total
	;outputs
	;r0 = cpu total

	f_bind sys_task, statics, r0
	vp_cpy [r0 + tk_statics_cpu_total], r0
	vp_ret

def_func_end
