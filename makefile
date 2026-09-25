result: lockfile.jdn project.janet
	@nix build .

lockfile.jdn: project.janet
	@jpm make-lockfile

jpm_tree: project.janet
	@jpm deps -l
