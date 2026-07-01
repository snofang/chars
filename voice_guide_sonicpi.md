# Sonic Pi: A Practical Guide to Notes, Ticks, and Debugging

---

## Table of Contents

1. [Understanding Notes in Sonic Pi](#understanding-notes-in-sonic-pi)
2. [The Scale Function](#the-scale-function)
3. [The Tick System](#the-tick-system)
4. [Data Flow and Method Chaining](#data-flow-and-method-chaining)
5. [Debugging Techniques](#debugging-techniques)
6. [Practical Examples](#practical-examples)
7. [Quick Reference](#quick-reference)

---

## Understanding Notes in Sonic Pi

### Two Ways to Specify Notes

Sonic Pi accepts notes in two formats, both of which produce the same sound:

```ruby
play 52        # MIDI number
play :E3       # note name (more readable)
```

### MIDI Numbers

MIDI numbers range from 0 to 127. Each number represents a specific pitch:

```
:C3  = 48
:Cs3 = 49
:D3  = 50
:Ds3 = 51
:E3  = 52   ← your root note
:F3  = 53
:Fs3 = 54
:G3  = 55   ← your minor third
:Gs3 = 56
:A3  = 57   ← your fourth
:As3 = 58
:B3  = 59   ← your fifth
:C4  = 60   (middle C)
:Cs4 = 61
:D4  = 62   ← your minor seventh
```

### Octaves and Pitch Class

Notes repeat in octaves. The pitch class is the letter (C, D, E, etc.), and the octave number changes:

```ruby
:C3 = 48
:C4 = 60    # middle C (one octave higher = +12 semitones)
:C5 = 72    # another octave higher
```

**Rule:** One octave = 12 semitones.

### Sharps and Flats

```ruby
:Fs4    # F sharp, octave 4
:Bb3    # B flat, octave 3
:Ab5    # A flat, octave 5
```

### The Chromatic Scale (Semitone by Semitone)

From C4 upward:

```
:C4   = 60
:Cs4  = 61  (+1 semitone)
:D4   = 62  (+2)
:Ds4  = 63  (+3)
:E4   = 64  (+4)
:F4   = 65  (+5)
:Fs4  = 66  (+6)
:G4   = 67  (+7)
:Gs4  = 68  (+8)
:A4   = 69  (+9)
:As4  = 70  (+10)
:B4   = 71  (+11)
:C5   = 72  (+12)
```

### Transposition (Shifting Pitch)

Add or subtract numbers to shift all notes:

```ruby
play (scale :C4, :major).tick + 12    # all notes up one octave
play (scale :C4, :major).tick - 5     # down a perfect fourth
play :C4 + 7                           # up a perfect fifth (to :G4)
play :C4 - 2                           # down a major second (to :Bb3)
```

---

## The Scale Function

### What It Returns

`scale` returns a **ring** (an immutable list) of note numbers:

```ruby
puts (scale :E3, :minor_pentatonic)
# Output: (ring 52, 55, 57, 59, 62)
```

These correspond to:
- 52 = E3 (root)
- 55 = G3 (minor third)
- 57 = A3 (fourth)
- 59 = B3 (fifth)
- 62 = D4 (minor seventh)

### Common Scales

```ruby
:major              # happy, bright
:minor              # sad, dark
:minor_pentatonic   # blues, rock (what you're using)
:major_pentatonic   # folk, country
:dorian             # jazzy minor
:blues              # blues scale
:chromatic          # all 12 notes
```

### Scale Examples

```ruby
scale :C4, :major        # (60, 62, 64, 65, 67, 69, 71)
scale :C4, :minor        # (60, 62, 63, 65, 67, 68, 70)
scale :C4, :dorian       # (60, 62, 63, 65, 67, 69, 70)
scale :C4, :blues        # (60, 63, 65, 66, 67, 70)
```

### Ring Properties

Rings automatically wrap when you access beyond their length:

```ruby
my_ring = (scale :C4, :major)  # 7 notes
my_ring[0]   # first note
my_ring[6]   # last note
my_ring[7]   # wraps to first note (index 0)
my_ring[14]  # wraps to first note again
```

---

## The Tick System

### What Tick Does

`tick` is a method that:
1. Returns the next value from a ring
2. Advances an internal counter
3. Wraps back to the beginning when it reaches the end

### Basic Usage

```ruby
live_loop :simple do
  play (scale :E3, :minor_pentatonic).tick
  sleep 0.25
end
```

This cycles through: E3 → G3 → A3 → B3 → D4 → E3 → G3 → ...

### Multiple Ticks (Named Ticks)

Use symbols to create independent tick counters:

```ruby
live_loop :multi do
  # One tick for notes
  note = (scale :E3, :minor_pentatonic).tick(:melody)
  
  # Another tick for rhythm
  duration = (ring 0.125, 0.25, 0.5).tick(:rhythm)
  
  play note, release: 0.1
  sleep duration
end
```

### The `look` Function (Inspection Without Advancing)

`look` returns the current tick index without changing it:

```ruby
live_loop :inspect do
  note = (scale :E3, :minor_pentatonic).tick
  puts "Note: #{note}, Index: #{look}"
  play note
  sleep 0.25
end
```

### Resetting Ticks

```ruby
tick_reset(:melody)       # reset just the :melody tick
tick_reset_all            # reset all tick counters
```

---

## Data Flow and Method Chaining

### The `.` Operator

`.` is the **method call operator**. It means: "take what's on the left, and call the method on the right."

### Breaking Down Your Code

```ruby
play (scale :E3, :minor_pentatonic).tick, release: 0.1
```

**Step-by-step data flow:**

```
Step 1: scale(:E3, :minor_pentatonic)
        ↓
Returns: (ring 52, 55, 57, 59, 62)

Step 2: (ring 52, 55, 57, 59, 62).tick
        ↓
Returns: 52 (first call), advances counter to index 1

Step 3: play 52, release: 0.1
        ↓
Plays MIDI note 52 for 0.1 seconds
```

### Chaining Methods

Data flows left to right:

```ruby
# Ring → reverse → tick
(scale :C4, :major).reverse.tick   # plays scale backwards

# Ring → shuffle → tick
(scale :C4, :major).shuffle.tick   # random order

# Ring → take → tick
(scale :C4, :major).take(3).tick   # only first 3 notes
```

### Storing Intermediate Values

```ruby
my_scale = scale :E3, :minor_pentatonic
my_note = my_scale.tick
play my_note
```

### Multiple Uses of the Same Tick Value

```ruby
live_loop :example do
  current_note = (scale :E3, :minor_pentatonic).tick
  play current_note, release: 0.1
  synth :beep, note: current_note + 12  # same note, octave up
  sleep 0.125
end
```

---

## Debugging Techniques

### Important Limitation

Sonic Pi's logging system processes only the first `puts` statement per iteration. Multiple `puts` statements will not all appear in the log.

**✅ Do this:**
```ruby
live_loop :debug do
  notes = scale :E3, :minor_pentatonic
  current_note = notes.tick
  current_idx = look
  
  # Single puts with all debug info
  puts "Idx: #{current_idx} | Note: #{current_note} | Ring: #{notes}"
  
  play current_note, release: 0.1
  sleep 0.25
end
```

**❌ Don't do this:**
```ruby
live_loop :debug do
  notes = scale :E3, :minor_pentatonic
  current_note = notes.tick
  
  puts "Note: #{current_note}"   # Only this prints
  puts "Ring: #{notes}"           # This never prints
  puts "---"                      # This never prints
  
  play current_note
  sleep 0.25
end
```

### Printing Ring Elements

**Works:**
```ruby
puts "Ring: #{my_ring}"                    # Prints full ring
puts "First: #{my_ring[0]}"               # Prints with interpolation
```

**Does NOT work:**
```ruby
puts my_ring[0]                            # Prints nothing
puts my_ring[1]                            # Prints nothing
```

### Recommended Debugging Pattern

```ruby
live_loop :debug do
  notes = scale :E3, :minor_pentatonic
  current_note = notes.tick
  current_idx = look
  
  # Combine everything into one formatted string
  next_idx = (current_idx + 1) % notes.length
  puts "🔍 Idx: #{current_idx} | Note: #{current_note} | Next: #{notes[next_idx]} | Ring: #{notes}"
  
  play current_note, release: 0.1
  sleep 0.25
end
```

**Output:**
```
🔍 Idx: 0 | Note: 52 | Next: 55 | Ring: (ring 52, 55, 57, 59, 62)
🔍 Idx: 1 | Note: 55 | Next: 57 | Ring: (ring 52, 55, 57, 59, 62)
🔍 Idx: 2 | Note: 57 | Next: 59 | Ring: (ring 52, 55, 57, 59, 62)
🔍 Idx: 3 | Note: 59 | Next: 62 | Ring: (ring 52, 55, 57, 59, 62)
🔍 Idx: 4 | Note: 62 | Next: 52 | Ring: (ring 52, 55, 57, 59, 62)
```

### Visual Debugging

Instead of relying on log output, you can use synthesizer parameters to hear where you are in the pattern. This is useful during development when you want to keep your focus on the sound rather than reading the log.

**Full Version with Customization:**

```ruby
define :visual_debug do |notes, opts = {}|
  # Defaults
  synth_type = opts[:synth] || :blade
  release_time = opts[:release] || 0.1
  sleep_time = opts[:sleep] || 0.25
  amp_min = opts[:amp_min] || 0.3
  amp_max = opts[:amp_max] || 0.9
  cutoff_min = opts[:cutoff_min] || 50
  cutoff_max = opts[:cutoff_max] || 82
  pan_min = opts[:pan_min] || -0.8
  pan_max = opts[:pan_max] || 0.8
  verbose = opts[:verbose] || false
  
  current_note = notes.tick
  current_idx = look % notes.length
  
  # Calculate values based on position in ring
  amp_val = amp_min + (current_idx * (amp_max - amp_min) / (notes.length - 1))
  cutoff_val = cutoff_min + (current_idx * (cutoff_max - cutoff_min) / (notes.length - 1))
  pan_val = pan_min + (current_idx * (pan_max - pan_min) / (notes.length - 1))
  
  # Optional logging
  if verbose
    puts "Idx: #{current_idx} | Note: #{current_note} | Amp: #{amp_val.round(2)} | Cutoff: #{cutoff_val.round(2)} | Pan: #{pan_val.round(2)}"
  end
  
  use_synth synth_type
  play current_note,
    release: release_time,
    amp: amp_val,
    cutoff: cutoff_val,
    pan: pan_val
  
  sleep sleep_time
end
```

**Usage Examples:**

```ruby
# Basic usage (audio feedback only)
live_loop :debug1 do
  visual_debug (scale :E3, :minor_pentatonic)
end

# Custom synth and timing
live_loop :debug2 do
  visual_debug (scale :C4, :major), 
    synth: :fm,
    release: 0.2,
    sleep: 0.15,
    amp_min: 0.1,
    amp_max: 0.8
end

# Different scale with custom ranges
live_loop :debug3 do
  visual_debug (scale :A3, :blues), 
    synth: :saw,
    cutoff_min: 40,
    cutoff_max: 100,
    pan_min: -1.0,
    pan_max: 1.0
end

# With logging enabled (when you need both)
live_loop :debug_verbose do
  visual_debug (scale :E3, :minor_pentatonic), verbose: true
end
```

**Parameter Mapping Reference:**

| Parameter | Formula | Range (5-note) | What You Hear |
|-----------|---------|----------------|---------------|
| `amp` | `min + (idx * (max - min) / (len - 1))` | 0.3 → 0.9 | Volume increases |
| `cutoff` | `min + (idx * (max - min) / (len - 1))` | 50 → 82 | Filter opens (brighter) |
| `pan` | `min + (idx * (max - min) / (len - 1))` | -0.8 → 0.8 | Moves left to right |

**What you hear (5-note ring):**

- Index 0: Quiet, dark, far left
- Index 1: Medium-quiet, slightly bright, center-left
- Index 2: Medium, bright, center
- Index 3: Medium-loud, brighter, center-right
- Index 4: Loud, very bright, far right

Each note in the cycle has a unique sonic fingerprint, letting you hear where you are in the pattern without looking at the log. The optional `verbose` mode adds log output when you need it for deeper inspection.

**Why this is useful during development:**

- You can keep your ears focused on the sound
- You don't need to split attention between code and log
- Each position has a distinct sonic signature
- Adapts to any ring length automatically
- Optional verbose mode for when you need log output too

**Benefits of the Function-Based Approach:**

1. **Reusable** — call it with any scale or ring
2. **Adaptable** — automatically adjusts to ring length
3. **Customizable** — override defaults with options
4. **Clean** — keeps your live_loop code minimal
5. **Testable** — swap scales easily to hear differences
6. **Performance-friendly** — no log spam, just audio feedback (unless you enable verbose)

### Debugging Summary

| Debugging Method | Works? | Best For |
|------------------|--------|----------|
| `puts ring` | ✅ | Quick inspection |
| `puts ring[0]` | ❌ | — |
| `puts "Value: #{ring[0]}"` | ✅ | Individual element inspection |
| Multiple `puts` in loop | ❌ | — |
| Single `puts` with all info | ✅ | Log-based debugging |
| Visual feedback (synth params) | ✅ | Ear-based development |
| `verbose` mode | ✅ | When you need both |

---

## Practical Examples

### Example 1: Simple Melody

```ruby
live_loop :melody do
  use_synth :blade
  play (scale :E3, :minor_pentatonic).tick, release: 0.2
  sleep 0.125
end
```

### Example 2: Rhythm and Melody Combined

```ruby
live_loop :complex do
  use_synth :fm
  
  # Different tick for different aspects
  note = (scale :E3, :minor_pentatonic).tick(:notes)
  amp = (ring 0.5, 0.7, 1.0, 0.7).tick(:volume)
  dur = (ring 0.125, 0.25).tick(:timing)
  
  play note, release: 0.1, amp: amp
  sleep dur
end
```

### Example 3: Chord Progression

```ruby
live_loop :chords do
  # Play full chords from scale
  play_chord (scale :E3, :minor_pentatonic).tick
  sleep 0.5
end
```

### Example 4: Arpeggio with Transposition

```ruby
live_loop :arpeggio do
  use_synth :piano
  
  base_note = (scale :E3, :minor_pentatonic).tick(:base)
  play base_note, release: 0.1
  
  # Add a harmony note an octave up
  play base_note + 12, release: 0.1, amp: 0.5
  
  sleep 0.125
end
```

### Example 5: Pattern with Variation

```ruby
live_loop :evolving do
  use_synth :mod_fm
  
  notes = scale :E3, :minor_pentatonic
  note = notes.tick(:melody)
  
  # Change the sound based on position in scale
  cutoff_val = 60 + (look(:melody) * 5)
  
  play note, release: 0.2, cutoff: cutoff_val
  sleep 0.15
end
```

---

## Quick Reference

### Note Functions

| Function | Example | Description |
|----------|---------|-------------|
| `scale` | `scale :C4, :major` | Returns ring of notes in scale |
| `chord` | `chord :C4, :major` | Returns ring of chord notes |
| `play` | `play 60` | Plays a single note |
| `play_chord` | `play_chord [60, 64, 67]` | Plays multiple notes |
| `synth` | `synth :blade, note: 60` | Plays with specific synth |

### Ring Methods

| Method | Example | Description |
|--------|---------|-------------|
| `.tick` | `ring.tick` | Get next value, advance counter |
| `.tick(:name)` | `ring.tick(:foo)` | Named independent tick |
| `.look` | `look` | Get current index without advancing |
| `.look(:name)` | `look(:foo)` | Get named tick index |
| `.[]` | `ring[2]` | Access by index |
| `.reverse` | `ring.reverse` | Reverse the ring |
| `.shuffle` | `ring.shuffle` | Randomize order |
| `.take(n)` | `ring.take(3)` | First n items |
| `.choose` | `ring.choose` | Random element |

### Debugging Functions

| Function | Example | Description |
|----------|---------|-------------|
| `puts` | `puts ring` | Print to log (single per iteration) |
| `look` | `look` | Get tick index without advancing |
| `tick_reset` | `tick_reset(:foo)` | Reset named tick |
| `tick_reset_all` | `tick_reset_all` | Reset all ticks |

### Common Scale Types

```
:major                 :major_pentatonic
:minor                 :minor_pentatonic
:dorian                :phrygian
:lydian                :mixolydian
:aeolian               :locrian
:blues                 :chromatic
```

### Common Note Names

```
:C3  :Cs3  :D3  :Ds3  :E3  :F3  :Fs3  :G3  :Gs3  :A3  :As3  :B3
:C4  :Cs4  :D4  :Ds4  :E4  :F4  :Fs4  :G4  :Gs4  :A4  :As4  :B4
:C5  :Cs5  :D5  :Ds5  :E5  :F5  :Fs5  :G5  :Gs5  :A5  :As5  :B5
```

### Useful Patterns

```ruby
# Simple melody
play (scale :E3, :minor_pentatonic).tick

# With rhythm control
sleep (ring 0.125, 0.25).tick(:rhythm)

# Random variation
play (scale :E3, :minor_pentatonic).shuffle.tick

# Changing octaves
play (scale :E3, :minor_pentatonic).tick + (ring 0, 12).tick(:octave)

# Dynamics
play note, amp: (ring 0.5, 0.7, 1.0).tick(:amp)

# Filter sweeps
play note, cutoff: 70 + (look(:melody) * 5)
```

---

## Final Tips

1. **Use single `puts` per iteration** — multiple `puts` statements won't all appear in the log
2. **Use string interpolation** — `puts "Value: #{ring[0]}"` works; `puts ring[0]` doesn't
3. **Always use `look` for debugging** — never call `.tick` just to inspect values
4. **Name your ticks** when using multiple — it prevents counter collisions
5. **Store rings in variables** if you reuse them — it's cleaner and more efficient
6. **Remember that rings wrap** — they loop forever, which is perfect for live loops
7. **Experiment with transposition** — shift entire patterns up/down for variation
8. **Combine ticks** — control melody, rhythm, dynamics, and effects independently
9. **Use visual debugging** — synth parameters like `amp`, `cutoff`, and `pan` show tick position during development
10. **Accept limitations** — Sonic Pi prioritizes audio performance over logging

---

*The grid exists. The grid is active. The grid is invisible.*
