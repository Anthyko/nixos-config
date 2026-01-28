{ config
, pkgs
, ...
}: {
  # Enable sound.
  security.rtkit.enable = true; # PulseAudio and PipeWire use this to acquire realtime priority.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 256;
        "default.clock.min-quantum" = 256;
        "default.clock.max-quantum" = 512;
      };
    };
  };

  #   Disable power saving for the snd_hda_intel driver.
  # Prevents audio clicks, pops, and crackling (underruns) during gaming or when audio resumes.
  # Recommended for gaming and real-time audio usage with PipeWire.
  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=0
  '';

}
