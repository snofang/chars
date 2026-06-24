# ============================================
# The Weight That Remains
# Sonic Pi Score
# ============================================
# A meditation on loss, pressure, and what stays.
# Designed for spoken word performance over a 4/4 rhythmic bed.
# ============================================

use_bpm 85

# ============================================
# LIVE LOOP: weight
# ============================================
# The core rhythmic pattern.
# Sparse. Grounded. Not a beat to move to — a beat to sit in.
# Kick appears, rests, returns — like the weight itself.
# Snare lands on stressed moments — never overwhelming, just present.
# Hat is ghostly — barely there breath between lines.
# Rests are honored. Silence holds as much as sound.
# ============================================

live_loop :weight do
  pattern = [
    :kick, :rest, :snare, :rest,
    :kick, :rest, :snare, :hat,
    :kick, :rest, :snare, :rest,
    :kick, :rest, :snare, :hat,
    :rest, :rest, :kick, :rest,
    :snare, :rest, :hat, :rest,
    :kick, :rest, :snare, :rest,
    :kick, :rest, :rest, :rest
  ]
  
  pattern.each do |hit|
    case hit
    when :snare
      sample :drum_snare_hard, amp: 0.5
    when :kick
      sample :drum_bass_hard, amp: 0.65
    when :hat
      sample :drum_cymbal_closed, amp: 0.25
    when :rest
      # silence — let it breathe
    end
    sleep 0.25
  end
end

# ============================================
# LIVE LOOP: forge
# ============================================
# Low rumble underneath the rhythm.
# Represents pressure — the forge that shaped.
# Always present. Never loud. Just underneath.
# Syncs with the weight loop — appears every 4 beats.
# ============================================

live_loop :forge do
  sync :weight
  
  sample :drum_heavy_kick, amp: 0.15, rate: 0.5, attack: 0.3, release: 1.0
  sleep 4
end

# ============================================
# LIVE LOOP: silence
# ============================================
# The pause between — where the poem sits.
# Ambient buzz — almost inaudible.
# The stillness when nothing is choosing.
# ============================================

live_loop :silence do
  sync :forge
  
  sleep 8
  sample :ambi_soft_buzz, amp: 0.04, attack: 3, release: 5
  sleep 8
end

# ============================================
# LIVE LOOP: holds
# ============================================
# A single deep tone.
# What remains after everything else fades.
# The center. The core. The weight that stays.
# ============================================

live_loop :holds do
  sync :silence
  
  use_synth :hollow
  play :e2, amp: 0.08, attack: 2, release: 6, cutoff: 60
  sleep 16
end

# ============================================
# PERFORMANCE INTEGRATION NOTES
# ============================================
# When performing the poem over this:
#
# "Losing money..."     → Kick on 1, snare on 3 — steady, flat
# "Loneliness..."      → Softer — hat drops out, just kick and snare
# "Another sit..."     → Pattern settles — repetitive, tired
# "But the forge..."   → Kick hits harder — the turn
# "The wheel turns..." → Full pattern — spine of the piece
# "So sit still..."    → Everything drops to forge rumble only — then silence
# ============================================

# ============================================
# END
# The weight remains. So does the rhythm underneath.
# ============================================
