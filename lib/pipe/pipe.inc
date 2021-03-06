;;;;;;;;;;;;
; pipe utils
;;;;;;;;;;;;

(import "sys/lisp.inc")
(import "class/lisp.inc")

;pipe tuple structure
(structure '+pipe 0
	(byte 'state+ 'select+ 'streams+))

(defun pipe-open (cmds &optional flag)
	(defq cmdpipe (list) args (map (lambda (cmd)
		(defq cmd (split cmd " "))
		(push cmdpipe (cat "cmd/" (elem 0 cmd) ".lisp"))
		(slice 0 -2 (apply cat (map (lambda (_) (cat _ " ")) cmd)))) (split cmds "|")))
	(cond
		;error with pipe element ?
		((some (lambda (_) (= 0 (get-long _ 0))) (defq mboxs (open-pipe cmdpipe)))
			;send abort to any started pipe elements
			(each (lambda (_) (if (/= 0 (get-long _ 0)) (mail-send _ ""))) mboxs)
			nil)
		(t	;wire up pipe and send args
			(defq select (list) pipe_streams (list))
			(each (lambda (_)
				(push pipe_streams (in-stream))
				(push select (in-mbox (elem -2 pipe_streams)))) mboxs)
			(defq stdout (in-stream) stdout_mbox (in-mbox stdout) ack_mbox (mail-alloc-mbox))
			(each-rev (lambda (mbox arg stderr_mbox)
				(mail-send mbox (cat
					stdout_mbox
					stderr_mbox
					ack_mbox
					(char 0 (const int_size)) arg))
				(setq stdout_mbox (cat
					(char (get-int (mail-read ack_mbox) (const (* 3 net_id_size))) (const long_size))
					(slice (const long_size) -1 mbox)))) mboxs args select)
			(push pipe_streams stdout (out-stream stdout_mbox))
			(push select (in-mbox stdout) (if flag (to-net-id (pad "" (const (* net_id_size 2)) "a")) (task-mailbox)))
			(mail-free-mbox ack_mbox)
			(list t select pipe_streams))))

(defun pipe-close (pipe)
	;clear the stdin stream, which will send stopping and stopped
	(bind '(_ select pipe_streams) pipe)
	(pop select) (pop pipe_streams) (clear pipe)
	;wait for stdout and stderr streams to stop
	(while (/= (length select) 0)
		(if (= (in-get-state (in-next-msg (elem (defq idx (mail-select select)) pipe_streams)))
				(const stream_mail_state_stopped))
			(setq pipe_streams (erase pipe_streams idx (inc idx)) select (erase select idx (inc idx))))))

(defun pipe-read (pipe)
	(cond
		;nil if pipe closed
		((elem +pipe_state+ pipe)
			;pipe is open
			(cond
				;t if task mailbox
				((= (- (defq idx (mail-select (elem +pipe_select+ pipe)))
						(length (elem +pipe_select+ pipe))) -1))
				(t	;must be stdout or one of the stderr's
					(if (/= (in-get-state (in-next-msg
								(defq msg_in (elem idx (elem +pipe_streams+ pipe)))))
							(const stream_mail_state_started))
						(elem-set +pipe_state+ pipe nil))
					(read-avail msg_in))))))

(defun pipe-write (pipe s)
	(stream-flush (write (elem -2 (elem +pipe_streams+ pipe)) s)))

(defun pipe-run (cmdline &optional out)
	; (pipe-run cmdline &optional outfun)
	(setd out print)
	(defq cmd (pipe-open cmdline t))
	(while cmd
		(defq data (pipe-read cmd))
		(cond
			((eql data nil)
				;pipe is closed
				(pipe-close cmd)
				(setq cmd nil))
			(t	;string from pipe
				(out data)))))
