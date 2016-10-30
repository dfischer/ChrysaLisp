%include 'inc/func.inc'
%include 'class/class_vector.inc'
%include 'class/class_error.inc'
%include 'class/class_lisp.inc'

def_func class/lisp/func_while
	;inputs
	;r0 = lisp object
	;r1 = args
	;outputs
	;r0 = lisp object
	;r1 = value

	def_struct pdata
		ptr pdata_this
		ptr pdata_value
	def_struct_end

	ptr this, value, args
	ulong length

	push_scope
	retire {r0, r1}, {this, args}

	devirt_call vector, get_length, {args}, {length}
	if {length >= 1}
		loop_start
			func_call vector, get_element, {args, 0}, {value}
			func_call lisp, repl_eval, {this, value}, {value}
			breakif {value->obj_vtable == @class/class_error}
			breakif {value == this->lisp_sym_nil}
			func_call vector, for_each, {args, 1, length, $callback, &this}, {_}
			breakif {value->obj_vtable == @class/class_error}
			func_call ref, deref, {value}
		loop_end
	else
		func_call error, create, {"(while tst form ...) wrong number of args", args}, {value}
	endif

	eval {this, value}, {r0, r1}
	pop_scope
	return

callback:
	;inputs
	;r0 = predicate data pointer
	;r1 = element iterator
	;outputs
	;r1 = 0 if break, else not

	pptr iter
	ptr pdata

	push_scope
	retire {r0, r1}, {pdata, iter}

	func_call ref, deref, {pdata->pdata_value}
	func_call lisp, repl_eval, {pdata->pdata_this, *iter}, {pdata->pdata_value}

	eval {pdata->pdata_value->obj_vtable != @class/class_error}, {r1}
	pop_scope
	return

def_func_end
