(defun trim-lines (string)
  (replace-regexp-in-string "\n" "" string))

(defun fill-string (s)
  (with-temp-buffer
     (emacs-lisp-mode)
     (insert s)
     (fill-region (point-min) (point-max))
     (buffer-substring (point-min) (point-max))))

(defun improve-region-prompt (start end prompt)
  (progn
    (insert (format "\n\n🥪 JARVIS INPUT BEGIN 👩🏼‍🔧\n\n%s🥪 JARVIS INPUT END 🕵🏼\n\n"
                    (fill-string
                     (shell-command-to-string
                      (format "curl -s -H 'Content-Type: application/json' -d \
                               '{\"contents\":[{\"parts\":[{\"text\":\"%s:\n\n%s\"}]}]}' \
                               -X POST 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=%s' \
                               | jq -r -M .candidates[0].content.parts[0].text"
                              prompt
                              (trim-lines (buffer-substring (mark) (point)))
                              gemini-api-key)))))))

(defun translate-to-english (start end)
  (interactive "r")
  (improve-region-prompt start end "Can you please translate this to english?"))

(defun improve-region (start end)
  (interactive "r")
  (improve-region-prompt start end "Hello, please, help me improve and correct this text"))

(defun refactor-this-code (start end)
  (interactive "r")
  (improve-region-prompt start end "Hello, please, provide me a code refactor"))
