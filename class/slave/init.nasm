%include 'inc/func.ninc'
%include 'class/class_stream_msg_out.ninc'
%include 'class/class_stream_msg_in.ninc'
%include 'class/class_slave.ninc'

def_func class/slave/init
	;inputs
	;r0 = slave object
	;r1 = vtable pointer
	;outputs
	;r1 = 0 if error, else ok
	;trashes
	;all but r0, r4

	const space_char, ' '

	ptr inst, vtable, stream, msg, mymailbox
	ulong error

	;read init args
	push_scope
	retire {r0, r1}, {inst, vtable}

	;init parent
	super_call slave, init, {inst, vtable}, {error}
	if {error != 0}
		;init myself
		func_call sys_task, mailbox, {}, {mymailbox, _}
		func_call sys_mail, read, {mymailbox}, {msg}
		if {msg->msg_length != msg_header_size}
			;create stdin, stdout, stderr
			func_call stream_msg_in, create, {mymailbox}, {inst->slave_stdin}
			func_call stream_msg_out, create, {msg->slave_mail_init_stdout_id.id_mbox, \
												msg->slave_mail_init_stdout_id.id_cpu}, {inst->slave_stdout}
			func_call stream_msg_out, create, {msg->slave_mail_init_stderr_id.id_mbox, \
												msg->slave_mail_init_stderr_id.id_cpu}, {inst->slave_stderr}

			;create args
			func_call stream, create, {0, 0, &msg->slave_mail_init_args, \
										msg->msg_length - slave_mail_init_size}, {stream}
			func_call stream, split, {stream, space_char}, {inst->slave_args}
			func_call stream, deref, {stream}

			;send back ack
			assign {msg->slave_mail_init_ack_id.id_mbox}, {msg->msg_dest.id_mbox}
			assign {msg->slave_mail_init_ack_id.id_cpu}, {msg->msg_dest.id_cpu}
			assign {msg_header_size}, {msg->msg_length}
			func_call sys_mail, send, {msg}
		else
			;abort
			func_call sys_mem, free, {msg}
			assign {0}, {error}
		endif
	endif

	eval {inst, error}, {r0, r1}
	pop_scope
	return

def_func_end
