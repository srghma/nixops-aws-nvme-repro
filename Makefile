make_dhparam:
	openssl dhparam -out backend/dhparams.pem 2048

nixops_create:
	nixops create '<base.nix>'

nixops_purge:
	nixops destroy --all
	nixops delete --all
