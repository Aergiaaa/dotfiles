{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      qutebrowser

      vimb
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-libav
    ];

    sessionVariables = {
      WEBKIT_DISABLE_SANDBOX_THIS_IS_DANGEROUS = "1";
    };
  };
}
