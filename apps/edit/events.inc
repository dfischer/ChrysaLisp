(defmacro mouse-event (m)
	`(= (get-long ,m ev_msg_type) ev_type_mouse))

(defmacro kb-event (m)
	`(= (get-long ,m ev_msg_type) ev_type_mouse))

(defmacro kb-key-down (m & optional k)
	`(and (key-event ,m) (> (get-int ,m ev_msg_key_keycode) 0)
		(if k (= (get-int msg ev_msg_key_key) ,k) t)))
		
(defmacro kb-keys-up (m)
	`(and (key-event ,m) (= (get-int ,m ev_msg_key_keycode) 0)))

(defmacro mouse-button-down (m & optional b)
	`(and (mouse-event ,m)
		(if ,b (= (get-int ,m ev_msg_mouse_buttons) ,b)
			(/= (get-int ,m ev_msg_mouse_buttons) 0))))

(defmacro mouse-buttons-up (m)
	`(when (mouse-event ,m) (= (get-int ,m ev_msg_mouse_buttons) 0)))

(defmacro kb-get-keycode (m)
	`(and (key-event ,m) (get-int ,m ev_msg_key_keycode)))

(defmacro kb-get-key (m)
	`(when (kb-key-down ,m) (get-int ,m ev_msg_key_key)))

(defmacro mouse-get-btn
	`(when (mouse-event ,m) (get-int ,m ev_msg_mouse_buttons)))


