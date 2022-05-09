(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("4a8d4375d90a7051115db94ed40e9abb2c0766e80e228ecad60e06b3b397acab" "8d7684de9abb5a770fbfd72a14506d6b4add9a7d30942c6285f020d41d76e0fa" default))
 '(org-agenda-files '("/Users/mph/org/notes.org" "/Users/mph/org/todo.org"))
 '(safe-local-variable-values
   '((lsp-metals-mill-script . "./bin/mill")
     (lsp-metals-mill-script . "./mill")
     (lsp-metals-mill-script . "/home/mph/Devel/thirdparty/mill/out/dev/launcher.dest/run")
     (projectile-project-compilation-cmd . "/home/mph/Devel/thirdparty/mill/out/dev/launcher.dest/run app.fastLinkJS")
     (projectile-project-run-cmd . "docker-compose exec -T uber /bin/sh -c 'touch $DEPLOYMENTS_DIR/uber-ear.ear.dodeploy'")
     (projectile-project-compilation-cmd . "mvn -o -Dmaven.test.skip -am -pl webapps/evi-war package"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
