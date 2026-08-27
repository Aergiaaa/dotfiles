{ pkgs, self }:
pkgs.st.overrideAttrs (old: {
  src = self + "/st";
})

