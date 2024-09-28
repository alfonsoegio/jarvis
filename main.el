(defun trim-lines (string)
  (replace-regexp-in-string "\n" "" string))

(defun fill-string (s)
  (with-temp-buffer
     (emacs-lisp-mode)
     (insert s)
     (fill-region (point-min) (point-max))
     (buffer-substring (point-min) (point-max))))

(defun prompt-gemini-region (start end prompt)
  (insert (format "\n\n🥪 JARVIS INPUT BEGIN 👩🏼‍🔧\n\n%s🥪 JARVIS INPUT END 🕵🏼\n\n"
                  (fill-string
                   (shell-command-to-string
                    (format "curl -s -H 'Content-Type: application/json' -d \
                               '{\"contents\":[{\"parts\":[{\"text\":\"%s:\n\n%s\"}]}]}' \
                               -X POST 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=%s' \
                               | jq -r -M .candidates[0].content.parts[0].text"
                            prompt
                            (trim-lines (buffer-substring (mark) (point)))
                            gemini-api-key))))))

(defun translate-to-english (start end)
  (interactive "r")
  (prompt-gemini-region start end "Can you please translate this to english?"))

(defun improve-region (start end)
  (interactive "r")
  (prompt-gemini-region start end "Hello, please, help me improve and correct this text"))

(defun analyze-this-code (start end)
  (interactive "r")
  (prompt-gemini-region start end "Hello, please, analyze this source code"))
