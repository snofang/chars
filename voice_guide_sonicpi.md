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

### Printing Ring Contents

```ruby
puts (scale :E3, :minor_pentatonic)
# (ring 52, 55, 57, 59, 62)
```

### Safe Debugging with `look`

```ruby
live_loop :debug do
  notes = scale :E3, :minor_pentatonic
  current_note = notes.tick
  current_index = look
  
  puts "Index: #{current_index} → Note: #{current_note}"
  puts "Next in ring: #{notes[current_index + 1]}" if current_index < notes.length - 1
  puts "Ring wraps to: #{notes[0]}" if current_index == notes.length - 1
  
  play current_note, release: 0.1
  sleep 0.25
end
```

### Debugging Multiple Named Ticks

```ruby
live_loop :multi_debug do
  notes = scale :E3, :minor_pentatonic
  durations = ring 0.125, 0.25, 0.5
  
  note = notes.tick(:melody)
  duration = durations.tick(:rhythm)
  
  puts "Melody: #{note} (idx: #{look(:melody)})"
  puts "Rhythm: #{duration} (idx: #{look(:rhythm)})"
  puts "---"
  
  play note, release: 0.1
  sleep duration
end
```

### Log Output Example

```
Index: 0 → Note: 52
Next in ring: 55
---
Index: 1 → Note: 55
Next in ring: 57
---
Index: 2 → Note: 57
Next in ring: 59
---
Index: 3 → Note: 59
Next in ring: 62
---
Index: 4 → Note: 62
Ring wraps to: 52
```

### Common Pitfall

**DON'T do this** (calls tick twice, advancing it extra):

```ruby
# ❌ Bad: calls tick twice
puts (scale :E3, :minor_pentatonic).tick
play (scale :E3, :minor_pentatonic).tick
```

**DO this** (calls tick once, stores result):

```ruby
# ✅ Good: calls tick once
note = (scale :E3, :minor_pentatonic).tick
puts note
play note
```

### Visualizing Tick State

```ruby
live_loop :visualize do
  notes = scale :E3, :minor_pentatonic
  note = notes.tick
  idx = look
  
  # Visual representation
  bar = notes.map_with_index do |n, i|
    i == idx ? "[#{n}]" : " #{n} "
  end.join
  
  puts bar
  play note, release: 0.1
  sleep 0.5
end
```

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
| `puts` | `puts ring` | Print to log |
| `print` | `print "hello"` | Print to log |
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

1. **Always use `look` for debugging** — never call `.tick` just to inspect values
2. **Name your ticks** when using multiple — it prevents counter collisions
3. **Store rings in variables** if you reuse them — it's cleaner and more efficient
4. **Use `puts` liberally** when learning — see exactly what your code produces
5. **Remember that rings wrap** — they loop forever, which is perfect for live loops
6. **Experiment with transposition** — shift entire patterns up/down for variation
7. **Combine ticks** — control melody, rhythm, dynamics, and effects independently

---

