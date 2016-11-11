%include 'inc/func.ninc'
%include 'inc/load.ninc'
%include 'inc/string.ninc'
%include 'class/class_stream.ninc'
%include 'class/class_boxed_long.ninc'
%include 'class/class_lisp.ninc'

def_func class/lisp/repl_read_num
	;inputs
	;r0 = lisp object
	;r1 = stream
	;r2 = next char
	;outputs
	;r0 = lisp object
	;r1 = number
	;r2 = next char

	const char_0, '0'
	const char_9, '9'
	const char_a, 'a'
	const char_z, 'z'
	const char_ca, 'A'
	const char_cz, 'Z'
	const char_minus, '-'
	const char_x, 'x'
	const char_b, 'b'
	const char_o, 'o'

	ptr this, stream, num
	pubyte reloc, buffer
	ulong char, sign
	long val

	push_scope
	retire {r0, r1, r2, r2}, {this, stream, char, sign}

	if {char == char_minus}
		func_call stream, read_char, {stream}, {char}
	endif

	func_path sys_load, statics
	assign {@_function_.ld_statics_reloc_buffer}, {reloc}
	assign {reloc}, {buffer}

	loop_while {char >= char_0 && char <= char_9 \
				|| char >= char_a && char <= char_z \
				|| char >= char_ca && char <= char_cz}
		assign {char}, {*buffer}
		assign {buffer + 1}, {buffer}
		func_call stream, read_char, {stream}, {char}
	loop_end
	assign {0}, {*buffer}

	;pick base
	assign {reloc + 1, 10}, {buffer, val}
	if {*buffer == char_x}
		assign {reloc + 2, 16}, {reloc, val}
	elseif {*buffer == char_o}
		assign {reloc + 2, 8}, {reloc, val}
	elseif {*buffer == char_b}
		assign {reloc + 2, 2}, {reloc, val}
	endif

	;create the number
	func_call boxed_long, create, {}, {num}
	func_call sys_string, to_long, {reloc, val}, {val}
	if {sign == char_minus}
		assign {-val}, {val}
	endif
	func_call boxed_long, set_value, {num, val}

	eval {this, num, char}, {r0, r1, r2}
	pop_scope
	return

def_func_end
