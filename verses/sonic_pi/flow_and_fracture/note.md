# Flow & Fracture

**A syncopato_legato study in cello and rhythm**

---

## Overview

This study explores the tension between **flow** (legato, smooth rhythm) and **fracture** (syncopated cello that pushes and pulls against the beat). The rhythm section provides a steady, flowing foundation while the cello phrases anticipate and delay, creating a restless, melancholic quality.

At 80 BPM, the slower tempo gives the syncopated cello more space to breathe, making the push/pull against the legato rhythm more pronounced and spacious.

**Inspired by:** Ellen Allien & Apparat's "Metric"

---

## Technical Details

| Property | Value |
|----------|-------|
| BPM | 80 |
| Key | C minor |
| Samples | Sonatina Symphonic Orchestra (SSO) |
| Instrument | Cello (solo + harmony) |
| Technique | syncopato_legato |

---

## The Syncopato Legato Technique

The cello uses `delay` parameters to create push/pull against the steady rhythm:

| Delay Value | Effect |
|-------------|--------|
| `delay: 0.2` | Note anticipates the beat (rushes ahead) |
| `delay: -0.15` | Note delays against the beat (drags behind) |
| `delay: 0.25-0.3` | Strong anticipation |
| `delay: -0.2 to -0.25` | Strong delay |

This creates a conversational quality where the cello seems to float independently of the rhythm.

---

## Structure

| Layer | Description |
|-------|-------------|
| Legato Drums | Smooth 4/4 with subtle variations |
| Legato Hi-hats | Consistent, flowing eighth-note feel |
| Legato Bass | Sustained saw wave, smooth transitions |
| Syncopated Cello | 8-note phrase with push/pull timing |
| Syncopated Harmony | Counter-melody with syncopated timing |
| Cello Bowing | Subtle attack layer |
| Legato Glitch | Gentle, smooth textures |
| Atmospheric Pad | Swelling ambient background |
| Legato Delay | Smooth echoes (phase: 0.5) |
| Syncopated Filter | LPF modulation following cello |
| Rhythmic Pulse | Subtle legato pulse |

---

## Tempo Comparison

| Aspect | 130 BPM | 80 BPM |
|--------|---------|--------|
| Cello durations | 1.5-2.2s | 2.0-3.2s |
| Cello attack | 0.1s | 0.15s |
| Cello release | 0.2s | 0.3s |
| Delay values | ±0.1-0.25s | ±0.15-0.3s |
| Pad attack/sustain | 2/4s | 4/6s |
| Echo decay | 6 beats | 8 beats |
| Feel | Tense, driving | Spacious, breathing |

The 80 BPM version gives the syncopated cello more room to breathe, making the push/pull against the legato rhythm more pronounced and dramatic.

---

## Requirements

- **Sonic Pi** v4.0+
- **Sonatina Symphonic Orchestra** samples at `~/develop/sso/Samples/Cello/`

To get the samples:
```bash
git clone https://github.com/peastman/sso.git ~/develop/sso/
