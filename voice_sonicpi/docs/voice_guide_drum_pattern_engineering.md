---

# Drum Pattern Engineering — Voice Guide

## The Logical Ingredients for Infinite Grooves

---

## Overview

Every drum pattern can be built from a set of core dimensions. Mix and match these logical ingredients to create any groove, from rock to jazz to hip-hop to minimal ambient.

---

## 1. The Four Voices

| Voice | Role | Sonic Character | Sonic Pi Sample |
|-------|------|-----------------|-----------------|
| **Kick** | Foundation — the pulse | Low, thud, anchor | `:drum_bass_hard` |
| **Snare / Clap** | Backbeat — the spine | Sharp, crack, mid-high | `:drum_snare_hard`, `:drum_snare_soft` |
| **Hat (Closed)** | Texture — the glue | Crisp, short, high | `:drum_cymbal_closed` |
| **Hat (Open)** | Texture — the air | Sizzle, sustain | `:drum_cymbal_open` |

### Secondary Voices

| Voice | Role | Sonic Pi Sample |
|-------|------|-----------------|
| **Ride Cymbal** | Wash, sustain, jazz feel | `:drum_cymbal_ride` |
| **Crash Cymbal** | Accent, impact | `:drum_cymbal_crash` |
| **Toms** | Tension, fills, melody | `:drum_tom_hi`, `:drum_tom_lo` |
| **Percussion** | Flavor, texture | `:drum_tambourine`, `:drum_cowbell` |
| **Ghost Snare** | Subtle texture, soft crack | `:drum_snare_soft` |

---

## 2. The Metric Grid

| Resolution | Steps per Bar | Subdivision | Sonic Pi Sleep |
|------------|---------------|-------------|----------------|
| **Basic (4)** | 4 steps | Quarter notes | `sleep 1.0` |
| **8th notes** | 8 steps | 8th notes | `sleep 0.5` |
| **16th notes** | 16 steps | 16th notes | `sleep 0.25` |
| **32nd notes** | 32 steps | 32nd notes | `sleep 0.125` |

---

## 3. Pattern Archetypes (Structural Templates)

| Archetype | Kick | Snare | Hat | Feel |
|-----------|------|-------|-----|------|
| **Four-on-the-floor** | 1, 2, 3, 4 | 2, 4 | 8th notes (closed) | Driving, dance |
| **Rock** | 1, 3, 3.5 | 2, 4 | 8th notes (closed) | Steady, driving |
| **Funk** | 1, 2.5, 3.5 | 2, 4 | 16th notes, syncopated | Groovy, tight |
| **Hip-Hop** | 1, 2.5, 3.5 | 3 | 16th notes, loose | Heavy, laid-back |
| **Half-time** | 1, 2.5, 3.5 | 3 | 8th notes, sparse | Heavy, slow |
| **Double-time** | 1, 2, 3, 4 | 2, 4 (or every 8th) | 16th notes | Fast, energetic |
| **Jazz** | Sparse, irregular | Ghost notes, 2 & 4 | Ride cymbal, swing | Loose, flowing |
| **Drum & Bass** | Fast, broken, syncopated | 2 & 4 (or 3) | 16th notes, complex | Fast, intricate |
| **Minimal** | Occasional, sparse | Rare, soft | Almost none | Atmospheric, open |

---

## 4. Density Map

| Density | Hits per Bar (16th notes) | Sonic Feel |
|---------|---------------------------|------------|
| **Minimal** | 1–4 | Sparse, open, meditative |
| **Sparse** | 5–8 | Airy, relaxed |
| **Medium** | 9–14 | Standard, balanced |
| **Dense** | 15–20 | Busy, energetic |
| **Maximal** | 21+ | Overwhelming, complex |

---

## 5. Velocity / Dynamics

| Dynamic Level | Meaning | Sonic Pi Amp |
|---------------|---------|--------------|
| **Accented** | Hit hard — emphasis | `amp: 0.8–1.0` |
| **Normal** | Standard volume | `amp: 0.5–0.7` |
| **Ghost** | Very soft — texture | `amp: 0.1–0.3` |
| **Silent** | Rest — absence | `amp: 0` |

---

## 6. Time Feel

| Feel | Description | Swing Amount (Sonic Pi) |
|------|-------------|------------------------|
| **Straight** | Even timing — robotic, precise | `0` |
| **Swing (8th)** | First 8th longer, second shorter | `0.2–0.4` |
| **Swing (16th)** | Subtle swing on 16th notes | `0.1–0.2` |
| **Shuffle** | Heavy triplet feel | `0.5–0.7` |
| **Loose** | Slightly ahead or behind beat | Variable |

---

## 7. Arrangement Layers

| Layer | Drum Treatment |
|-------|----------------|
| **Intro** | Sparse, build slowly, minimal kicks |
| **Verse** | Steady, foundational pattern |
| **Chorus** | Denser, louder, more hits, crash accents |
| **Bridge** | Variation — change kick/snare pattern |
| **Break** | Drop out — tension, rest, minimal |
| **Fill** | Transition — accent before change, toms |
| **Outro** | Fade, simplify, end on a hit |

---

## 8. Density Matrix (Combine Voices)

| Feel | Kick | Snare | Hat | Other |
|------|------|-------|-----|-------|
| **Rock Verse** | 1, 3, 3.5 | 2, 4 | 8th notes (closed) | — |
| **Rock Chorus** | 1, 2, 3, 4 | 2, 4 | 8th notes (closed) | Crash on 1 |
| **Funk Verse** | 1, 2.5, 3.5 | 2, 4 | 16th notes, syncopated | — |
| **Funk Chorus** | 1, 2.5, 3.5 | 2, 4 | 16th notes, syncopated | Crash on 1, ride |
| **Hip-Hop Verse** | 1, 2.5, 3.5 | 3 (heavy) | 16th notes, loose | — |
| **Hip-Hop Chorus** | 1, 2.5, 3.5 | 3 (heavy) | 16th notes, loose | Tambourine, crash |
| **Jazz Verse** | Sparse, irregular | Ghost notes, 2 & 4 | Ride cymbal | Swing feel |
| **Minimal Verse** | 1, 3 | Rare, soft | None | Soft ambient tone |

---

## 9. The Pattern Recipe Formula

### Build a Pattern:

```
1. Pick your Voices: Kick, Snare, Hat, [Optional]
2. Pick your Grid: 4, 8, 16, 32
3. Pick your Archetype: Rock / Funk / Hip-Hop / etc.
4. Pick your Density: Minimal / Sparse / Medium / Dense / Maximal
5. Pick your Time Feel: Straight / Swing / Shuffle / Loose
6. Pick your Dynamic Curve: Soft / Normal / Accented / Ghost-heavy
7. Pick your Arrangement: Verse / Chorus / Bridge / Break / Intro / Outro
8. Sequence: Map hits across the grid
9. Add Variation: Fills, accents, drop-outs
```

---

## 10. Example Patterns (Sonic Pi Ready)

### Rock Verse (16th notes, 16 steps)

```ruby
pattern = [
  :kick, :rest, :rest, :rest,   # Bar 1
  :kick, :rest, :rest, :rest,   # Bar 2
  :kick, :rest, :rest, :rest,   # Bar 3
  :kick, :rest, :rest, :rest,   # Bar 4
  :snare, :rest, :rest, :rest,  # Bar 1
  :rest, :rest, :rest, :rest,   # Bar 2
  :snare, :rest, :rest, :rest,  # Bar 3
  :rest, :rest, :rest, :rest,   # Bar 4
]
# Add hat on every 8th note
```

### Funk Verse (16th notes, 16 steps)

```ruby
pattern = [
  :kick, :rest, :rest, :kick,   # Bar 1
  :rest, :snare, :kick, :rest,  # Bar 2
  :kick, :rest, :rest, :snare,  # Bar 3
  :rest, :kick, :rest, :rest,   # Bar 4
]
# Hat on every 16th note, syncopated
```

### Hip-Hop Half-Time (16th notes, 16 steps)

```ruby
pattern = [
  :kick, :rest, :rest, :rest,   # Bar 1
  :rest, :kick, :rest, :rest,   # Bar 2
  :kick, :rest, :rest, :rest,   # Bar 3
  :rest, :kick, :rest, :rest,   # Bar 4
  :snare, :rest, :rest, :rest,  # Bar 1 (heavy on 3)
  :rest, :rest, :rest, :rest,   # Bar 2
  :snare, :rest, :rest, :rest,  # Bar 3
  :rest, :rest, :rest, :rest,   # Bar 4
]
# Hat on 16th notes, loose
```

---

## 11. The Mix & Match Matrix

Pick one from each category:

| Category | Options |
|----------|---------|
| **Grid** | 4, 8, 16, 32 |
| **Voices** | Kick, Snare, Hat, Ride, Crash, Toms, Percussion |
| **Time Feel** | Straight, Swing (8th), Swing (16th), Shuffle, Loose |
| **Density** | Minimal, Sparse, Medium, Dense, Maximal |
| **Dynamic** | Soft, Normal, Accented, Ghost-heavy |
| **Structure** | Verse, Chorus, Bridge, Break, Intro, Outro |
| **Focus** | Kick-heavy, Snare-heavy, Hat-heavy, Balanced |

---

## 12. Logical Combinations

### Use Case 1: Build Tension

- Start sparse (Minimal)
- Add density gradually (Sparse → Medium → Dense)
- Add crash on transitions
- Drop to Break (Minimal) for tension

### Use Case 2: Create a Chorus

- Increase density (Dense)
- Add crash on 1
- Add open hat on off-beats
- Increase velocity (Accented)

### Use Case 3: Make it Laid-Back

- Use Half-time archetype
- Apply Swing (or Shuffle)
- Use ghost notes on snare
- Keep dynamics soft

### Use Case 4: Make it Aggressive

- Use Double-time archetype
- Increase density (Maximal)
- Accent all hits
- Add crash every 4 bars

---

## 13. Sonic Pi Implementation Template

```ruby
# ============================================
# Pattern Recipe Template
# ============================================

use_bpm 85

# Parameters
grid = 16  # 4, 8, 16, 32
feel = :straight  # :straight, :swing, :shuffle
density = :medium  # :minimal, :sparse, :medium, :dense, :maximal

# Voices
kick_pattern = [
  :kick, :rest, :rest, :kick,   # Bar 1
  :rest, :rest, :kick, :rest,   # Bar 2
  :kick, :rest, :rest, :rest,   # Bar 3
  :rest, :kick, :rest, :rest    # Bar 4
]

snare_pattern = [
  :rest, :rest, :rest, :rest,   # Bar 1
  :snare, :rest, :rest, :rest,  # Bar 2
  :rest, :rest, :rest, :rest,   # Bar 3
  :snare, :rest, :rest, :rest   # Bar 4
]

hat_pattern = [
  :hat, :hat, :hat, :hat,       # Bar 1
  :hat, :hat, :hat, :hat,       # Bar 2
  :hat, :hat, :hat, :hat,       # Bar 3
  :hat, :hat, :hat, :hat        # Bar 4
]

# Playback
live_loop :drums do
  kick_pattern.each do |hit|
    case hit
    when :kick
      sample :drum_bass_hard, amp: 0.7
    when :snare
      sample :drum_snare_hard, amp: 0.6
    when :hat
      sample :drum_cymbal_closed, amp: 0.3
    when :rest
      # silence
    end
    sleep 0.25  # 16th notes
  end
end
```

---

## 14. Vocabulary Summary

| Term | Meaning |
|------|---------|
| **Beat** | The fundamental pulse |
| **Groove** | The feel or swing of the rhythm |
| **Pattern** | The specific sequence of hits |
| **Grid** | The resolution of the pattern (4, 8, 16, 32) |
| **Density** | How many hits per bar |
| **Velocity** | The volume of each hit (accented, normal, ghost) |
| **Archetype** | A template pattern (rock, funk, hip-hop, etc.) |
| **Arrangement** | The structure (verse, chorus, bridge, break) |
| **Ostinato** | A continuously repeated rhythmic figure |
| **Syncopation** | Accents on off-beats |

---

## 15. Endless Combinations

The formula is simple:

```
Pick Your Voices → Pick Your Grid → Pick Your Archetype → 
Pick Your Density → Pick Your Feel → Pick Your Dynamics → 
Sequence → Add Variation → Repeat
```

Every combination creates a new groove. There is no limit.

---

*The logic is simple. The variations are infinite.*
