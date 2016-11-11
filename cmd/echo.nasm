%include 'inc/func.ninc'
%include 'class/class_string.ninc'
%include 'class/class_stream.ninc'
%include 'class/class_vector.ninc'
%include 'class/class_slave.ninc'

def_func cmd/echo

	const char_lf, 10

	ptr slave, arg, args, stream
	ulong argc, index, length

	;init app vars
	push_scope

	;initialize pipe details and command args, abort on error
	func_call slave, create, {}, {slave}
	if {slave}
		;echo args to stdout, arg 1 is command name
		func_call slave, get_args, {slave}, {args}
		devirt_call vector, get_length, {args}, {argc}
		if {argc != 1}
			;strings from command line
			assign {1}, {index}
			loop_while {index != argc}
				func_call vector, get_element, {args, index}, {arg}
				func_call stream, write, {slave->slave_stdout, &arg->string_data, arg->string_length}
				func_call stream, write_char, {slave->slave_stdout, char_lf}
				assign {index + 1}, {index}
				func_call sys_task, yield
			loop_end
		endif

		;clean up
		func_call slave, deref, {slave}
	endif
	pop_scope
	return

def_func_end
