# Flow & Fracture

**A syncopato_legato study in cello and rhythm**

---

## Overview

This study explores the tension between **flow** (legato, smooth rhythm) and **fracture** (syncopated cello that pushes and pulls against the beat). The rhythm section provides a steady, flowing foundation while the cello phrases anticipate and delay, creating a restless, melancholic quality.

**Inspired by:** Ellen Allien & Apparat's "Metric"

---

## Technical Details

| Property | Value |
|----------|-------|
| BPM | 130 |
| Key | C minor |
| Samples | Sonatina Symphonic Orchestra (SSO) |
| Instrument | Cello (solo + harmony) |
| Technique | syncopato_legato |

---

## The Syncopato Legato Technique

The cello uses `delay` parameters to create push/pull against the steady rhythm:

- `delay: 0.15` → Note anticipates the beat (rushes ahead)
- `delay: -0.1` → Note delays against the beat (drags behind)
- `delay: 0.25` → Strong anticipation
- `delay: -0.2` → Strong delay

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

## Requirements

- **Sonic Pi** v4.0+
- **Sonatina Symphonic Orchestra** samples at `~/develop/sso/Samples/Cello/`

To get the samples:
```bash
git clone https://github.com/peastman/sso.git ~/develop/sso/
