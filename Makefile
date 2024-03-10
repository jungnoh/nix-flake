apply:
	nix run nix-darwin -- switch --flake .
gc:
	nix-collect-garbage
refresh: apply gc
