Here is the updated `README.md`, tailored specifically for your newly optimized engine architecture. It reflects the performance caching, the global FX buses, and the expanded instrument set.

```markdown
# Voice Sonic Pi Engine (Optimized)

A declarative, strict-schema step-sequencer, granular synthesizer, and sampling engine built for Sonic Pi. 

This engine separates musical *data* (the playbooks) from the *synthesis and timing logic* (the engine). It enforces a rigid 16-step, 4/4 time signature grid, allowing the composer to focus entirely on crafting arrays of notes, chords, and parameters without worrying about thread management, timing drift, or concurrency bugs.

## Core Philosophy

1. **Single Master Clock:** The entire engine runs inside a single `live_loop`. There are no `in_thread` calls, no `cue`/`sync` race conditions, and zero timing drift. All instruments are triggered sequentially step-by-step.
2. **Strict Schema Validation:** Every score must be exactly 16 steps long. If a score has 15 or 17 steps, the engine "fails fast" and throws an error, preventing hidden timing bugs.
3. **Bulletproof Parameter Hashing:** A step in a score can be a simple note (`:c4`), a rest (`nil`), an array of notes (a chord), or a Hash of parameters (`{note: :c4, amp: 0.5}`). The engine's `parse_step` function sanitizes all incoming data—automatically cleaning out `nil` values from arrays to prevent runtime crashes.
4. **Performance Caching:** To handle high-BPM, dense genres (like Gabber or Breakcore) without CPU spikes, the engine memoizes (caches) the results of `parse_step` and MIDI note calculations in instance variables (`@parse_cache`, `@note_cache`).
5. **Global FX Buses:** Instantiating audio effects (`with_fx`) is computationally expensive. The engine routes specific instruments (like `:play_lead` and `:play_snare`) through global FX buses using queues (`@lead_notes`, `@snare_notes`). A dedicated `live_loop` processes these queues through a single, persistent Echo and Reverb instance, mimicking professional DAW routing.
6. **Professional Signal Chain:** FX routing is encapsulated directly inside the instrument definitions, keeping the musical data clean.

## The Schema

The engine expects a specific data structure: a **Playbook** containing **Scenes**, which reference **Scores**.

### 1. Scores (16-Step Rings)
A score is a ring of exactly 16 elements. Elements can be notes, chords (arrays of notes), `nil` (rests), or Hashes (for dynamic parameters).

```ruby
# Simple 16-step bassline
s_bass = (ring :c2, nil, nil, nil, :c2, nil, nil, nil, :eb2, nil, nil, nil, :g2, nil, nil, nil)

# 16-step sequence using Parameter Hashes for dynamics
s_kick = (ring :c4, nil, nil, nil, {note: :c4, amp: 0.7}, nil, nil, nil, :c4, nil, nil, nil, :c4, nil, nil, nil)

# Chords (Arrays) inside the grid
s_chords = (ring [:c3, :eb4, :g4, :bb4], nil, nil, nil, nil, nil, nil, nil, 
            [:f3, :ab4, :c5, :eb5], nil, nil, nil, nil, nil, nil, nil)
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
The engine comes with 13 built-in instrument functions. All pitched instruments map relative to `:c4` (MIDI 60).

**Bass & Sub:**
*   `:play_sub` - Distorted subtractive bass (`:dsaw`).
*   `:play_subbass` - Clean, pure sine wave sub-bass. Ideal for cinematic booms and deep low-end.

**Synths & Leads:**
*   `:play_lead` - Wavetable lead (`:prophet`) routed through the **Global Tape Echo Bus**.
*   `:play_chords` - Warm sustained pad (`:blade`) designed to play arrays of notes (chords).
*   `:play_fm` - FM Bell/Synth (`:fm`).
*   `:play_pluck` - Physical modeling (`:pluck`).
*   `:play_pad` - Dark ambient drone (`:dark_ambience`).

**Granular & Sampling:**
*   `:play_grain` - **True Granular Synthesizer.** (See Granular Parameters below).
*   `:play_sample` - Sample player. Pass `sample: :sample_name` in the Hash to trigger any built-in Sonic Pi sample. Pitch shifts relative to `:c4`.
*   `:play_noise` - Filtered noise generator. The `note` passed in the Hash controls the `cutoff` frequency, allowing you to sequence filter sweeps/risers purely via data.

**Drums & Percussion:**
*   `:play_kick` - Pitched kick drum sampler.
*   `:play_snare` - Snare sampler routed through the **Global Hall Reverb Bus**.
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

### The Noise Generator (`:play_noise`)
The `:play_noise` instrument maps the incoming `note` to a filter `cutoff`. This allows you to use the 16-step grid to create massive cinematic risers and transitions.

**Example Noise Riser Step:**
```ruby
# As the notes go up, the filter opens up
{note: :c4, amp: 0.2, release: 0.1}
{note: :c6, amp: 1.0, release: 0.1}
```

## Execution

To use the engine, load it into memory using `eval_file` in your composition script, define your scores and playbook, and call `start_engine`.

```ruby
use_bpm 120
eval_file "path/to/engine.sonicpi"

# Define scores...

# Define playbook...

start_engine(playbook)
```
```
