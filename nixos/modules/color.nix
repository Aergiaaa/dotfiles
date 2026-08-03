{ pkgs, ...}:
let
	pywalWithBackends = pkgs.python314Packages.pywal16.overridePythonAttrs (old: {
		propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ (with pkgs.python314Packages; [
			colorthief
			haishoku
			colorzero
		]);
	});
in
{
  environment.systemPackages = [ (pkgs.python314Packages.toPythonApplication pywalWithBackends) ];
}
