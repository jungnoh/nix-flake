fmt:
	nix fmt
update:
	nix flake update
apply:
	nix-channel --update darwin
	nix run nix-darwin -- switch --flake .
dry-run:
	nix run nix-darwin -- switch --dry-run --flake .
gc:
	nix-collect-garbage
gc_full:
	sudo nix-collect-garbage -d
refresh: apply gc
