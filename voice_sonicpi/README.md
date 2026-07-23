# Voice Sonic Pi Engine

A declarative, strict-schema step-sequencer, granular synthesizer, and sampling engine built for Sonic Pi. 

This engine separates musical *data* (the playbooks) from the *synthesis and timing logic* (the engine). It enforces a rigid 16-step, 4/4 time signature grid, allowing the composer to focus entirely on crafting patterns and parameters without worrying about thread management, timing drift, or counting rests.

## Core Philosophy

1. **Single Master Clock:** The entire engine runs inside a single `live_loop`. There are no `in_thread` calls, no `cue`/`sync` race conditions, and zero timing drift. All instruments are triggered sequentially step-by-step.
2. **DRY Sequencing (`gen_score`):** The engine includes a built-in `gen_score` helper. Instead of manually typing `(ring :c4, nil, nil, ...)`, you pass a 16-character string (`"x...x..."`) and an array of notes. This guarantees every score is exactly 16 steps long, eliminating manual counting errors.
3. **Strict Schema Validation:** Every score must be exactly 16 steps long. If a score has 15 or 17 steps, the engine "fails fast" and throws an error, preventing hidden timing bugs.
4. **Bulletproof Parameter Hashing:** A step in a score can be a simple note (`:c4`), a rest (`nil`), an array of notes (a chord), or a Hash of parameters (`{note: :c4, amp: 0.5}`). The engine's `parse_step` function sanitizes all incoming data—automatically cleaning out `nil` values from arrays to prevent runtime crashes.
5. **Professional Signal Chain:** FX routing (reverbs, echoes) is encapsulated directly inside the instrument definitions, keeping the musical data clean.

## The Schema

The engine expects a specific data structure: a **Playbook** containing **Scenes**, which reference **Scores**.

### 1. Scores (Generated via `gen_score`)
The `gen_score` function takes a 16-character string (where `x` is a hit and `.` is a rest) and an array of data. It automatically cycles through your data array to fill the `x` positions.

```ruby
# Simple 4-on-the-floor kick
s_kick = gen_score("x...x...x...x...", [:c4])

# 16-step sequence using Parameter Hashes for dynamics
s_kick = gen_score("x...x...x...x...", [:c4, {note: :c4, amp: 0.7}])

# Chords (Arrays) inside the grid
s_chords = gen_score("..x.....x.....x.", [
  [:c3, :eb4, :g4, :bb4], 
  [:f3, :ab4, :c5, :eb5]
])

# Algorithmic generation (e.g., a 16-step filter sweep)
bass_data = 16.times.map { |i| {note: :c2, cutoff: 60 + (i * 4)} }
s_bass = gen_score("xxxxxxxxxxxxxxxx", bass_data)
```

### 2. Playbook (Timeline of Scenes)
The playbook is a ring of "Scenes". Each Scene is an array of tasks that play concurrently.
Format: `[ [:instrument, score, bars_to_play], ... ]`

```ruby
playbook = (ring
  # Scene 1: Play kick for 2 bars
  [ [:play_kick, s_kick, 2] ],
  
  # Scene 2: Play kick (4 bars) and sub bass (2 bars) concurrently
  [ [:play_kick, s_kick, 4], 
    [:play_sub,  s_bass, 2] ]
)

start_engine(playbook)
```

## Engine API Reference

### Instruments
The engine comes with 10 built-in instrument functions. All pitched instruments map relative to `:c4` (MIDI 60).

**Bass & Sub:**
*   `:play_sub` - Distorted subtractive bass (`:dsaw`).

**Synths & Leads:**
*   `:play_lead` - Wavetable lead (`:prophet`) routed through a tape echo.
*   `:play_chords` - Warm sustained pad (`:blade`) designed to play arrays of notes (chords).
*   `:play_fm` - FM Bell/Synth (`:fm`).
*   `:play_pluck` - Physical modeling (`:pluck`).
*   `:play_pad` - Dark ambient drone (`:dark_ambience`).

**Granular:**
*   `:play_grain` - **True Granular Synthesizer.** (See Granular Parameters below).

**Drums & Percussion:**
*   `:play_kick` - Pitched kick drum sampler.
*   `:play_snare` - Snare sampler routed through a massive hall reverb.
*   `:play_hats` - Micro-timed hi-hats with ghost notes.

### The Granular Synthesizer (`:play_grain`)
The `:play_grain` instrument is a fully featured granular engine. You can control it by passing these optional keys in your Parameter Hash:

*   `note:` - The pitch to shift the grain to (relative to `:c4`).
*   `buffer:` - The Sonic Pi sample to granulate (Default: `:ambi_choir`).
*   `pos:` - The buffer playback position / scrub head (`0.0` to `1.0`).
*   `size:` - Grain duration in seconds (Default: `0.05` / 50ms). Short sizes sound like static; long sizes sound like a pad.
*   `density:` - Number of grains fired per 16th step (Default: `4`).

**Example Granular Step:**
```ruby
{note: :c4, buffer: :misc_lori, pos: 0.5, density: 8, size: 0.08}
```

## Execution

To use the engine, load it into memory using `eval_file` in your composition script, define your scores using `gen_score`, define your playbook, and call `start_engine`.

```ruby
use_bpm 120
eval_file "path/to/engine.sonicpi"

# Define scores using gen_score...
s_kick = gen_score("x...x...x...x...", [:c4])

# Define playbook...
playbook = (ring
  [ [:play_kick, s_kick, 4] ]
)

start_engine(playbook)
