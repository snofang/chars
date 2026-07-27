## 🛠️ Audio Optimization Summary (Ubuntu 22.04 + Sonic Pi)## 1. Real-Time System Privileges (PAM limits)
We ensured your Ubuntu user account has permission to request maximum real-time processing and unlimited memory mapping without needing sudo.

* File: /etc/security/limits.conf (or a dedicated drop-in file)
* Configuration:

@audio   -   rtprio      95
@audio   -   memlock     unlimited


## 2. Immutable Clock Grid (PipeWire)
We forced PipeWire out of its default "flexible/dynamic" clock mode. This locks the hardware into a rigid timeline to prevent pitch-shifting and tempo warping.

* File: ~/.config/pipewire/pipewire.conf.d/99-sonicpi-lock.conf
* Configuration:

context.properties = {
    default.clock.rate          = 48000
    default.clock.allowed-rates =
    default.clock.quantum       = 1024
    default.clock.min-quantum   = 1024
    default.clock.max-quantum   = 1024
    stream.properties = {
        resample.quality        = 4
        resample.disable        = true
    }
}


## 3. Sonic Pi Engine Sample Matching (SuperCollider)
We forced the underlying scsynth audio engine to boot natively at 48 kHz, preventing it from fighting your hardware's 48 kHz clock layout.

* File: ~/.config/SuperCollider/startup.scd
* Configuration:

s.options.sampleRate = 48000;
s.options.hardwareBufferSize = 1024;


## 4. AMD ACP Hardware Driver Override (WirePlumber 0.4 Lua)
We created a targeted rule for your integrated AMD processor (pci-0000_04_00.6.analog-stereo). This stops aggressive sleep timeouts and prevents data buffering bursts (disable-batch = true) that were causing the ERR leaks and audio speed-sagging.

* File: ~/.config/wireplumber/main.lua.d/51-amd-acp-fix.lua
* Configuration:

table.insert(alsa_monitor.rules, {
  matches = {
    {
      { "node.name", "equals", "alsa_output.pci-0000_04_00.6.analog-stereo" },
    },
  },
  apply_properties = {
    ["session.suspend-on-idle"] = false,
    ["api.alsa.period-size"]    = 1024,
    ["api.alsa.headroom"]       = 1024,
    ["api.alsa.disable-mmap"]   = false,
    ["api.alsa.disable-batch"]  = true,
  },
})


------------------------------
## 🚀 Quick Command Cheat Sheet (For Future Reference)

* Check system audio metrics: pw-top
* Check active session priority privileges: ulimit -r -l
* Force-flush/restart the whole audio system:

systemctl --user restart wireplumber pipewire pipewire-pulse


------------------------------
If you want to tweak anything else later—like setting up MIDI routing via PipeWire or reducing the buffer size even further (e.g., to 512) for even lower latency—just let me know! Have fun coding your beats!

