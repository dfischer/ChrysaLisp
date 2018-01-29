;import sys settings
(bind '(byte_size short_size int_size long_size ptr_size
	kn_call_open kn_call_child lk_data_size id_size)
	(within-compile-env (lambda ()
		(import 'sys/link/link.inc)
		(import 'sys/kernel/kernel.inc)
		(list byte_size short_size int_size long_size ptr_size
			kn_call_open kn_call_child lk_data_size id_size))))

;some simple structure helpers
(defmacro structure (n o &rest b)
	`(progn (defq _e (env) _n ,n _o ,(eval o)) ~b (def _e (sym-cat _n "_size") _o '_e nil)))
(defun struct (s &rest b)
	(each (lambda (_) (def _e (sym-cat _n "_" _) _o) (setq _o (add _o s))) b))
(defun ptr (&rest b)
	(setq _o (align _o ptr_size)) (apply struct (cat (list ptr_size) b)))
(defun long (&rest b)
	(setq _o (align _o long_size)) (apply struct (cat (list long_size) b)))
(defun int (&rest b)
	(setq _o (align _o int_size)) (apply struct (cat (list int_size) b)))
(defun short (&rest b)
	(setq _o (align _o short_size)) (apply struct (cat (list short_size) b)))
(defun byte (&rest b)
	(setq _o (align _o byte_size)) (apply struct (cat (list byte_size) b)))

;system lisp bindings
(ffi mail-mymail "sys/mail/lisp_mymail" 0)
(ffi mail-send "sys/mail/lisp_send" 0)
(ffi open-child "sys/task/lisp_open_child" 0)
(ffi open-remote "sys/task/lisp_open_remote" 0)
(ffi open-farm "sys/task/lisp_open_farm" 0)
(ffi open-pipe "sys/task/lisp_open_pipe" 0)
(ffi cpu-total "sys/kernel/lisp_total" 0)
(ffi task-mailbox "sys/task/lisp_mailbox" 0)
