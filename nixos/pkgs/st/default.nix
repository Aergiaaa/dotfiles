{ pkgs, self ? null }:
pkgs.st.overrideAttrs (old: {
  src = self + "/st";
})

