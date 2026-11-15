# 🎮 Neon Escape

### Escape the Maze. Beat the Clock. Own the Leaderboard.

**Neon Escape** is a fast-paced 2D arcade maze game set in a futuristic neon environment. Navigate through a challenging maze, collect three energy cubes, dodge dangerous hazards and reach the exit before time runs out.

Think you're fast enough? Compete for a place in the global Top 10 leaderboard!

---

## 🕹️ Game Overview

You're trapped inside a futuristic maze with just **90 seconds** to escape.

Your mission is simple:
- Find and collect all 3 energy cubes.
- Avoid dangerous bouncing orbs that cost you precious time.
- Unlock the exit.
- Reach it before the countdown hits zero.

Every second counts. Every mistake matters.

## ✨ Features

- **Futuristic Neon Design:** A dark cyberpunk-inspired environment with glowing cyan, purple and pink visuals.
- **Time-Based Gameplay:** Complete the maze within a 90-second countdown.
- **Collectibles:** Find three energy cubes to unlock the exit.
- **Moving Hazards:** Avoid dangerous orbs that deduct 5 seconds from your remaining time.
- **Global Leaderboard:** Compete with other players for a spot among the 10 fastest escape times.
- **Username System:** Enter a username to identify your leaderboard records.
- **Sound Effects:** Audio feedback for collecting cubes, collisions, unlocking exits and winning.
- **Replayability:** Improve your completion time and challenge other players.

## 🎯 Game Details

| Category | Details |
|---|---|
| Genre | Arcade, Maze, Puzzle, Time Attack |
| Game Type | 2D Top-Down |
| Engine | Godot 4.x |
| Programming Language | GDScript |
| Gameplay Duration | 90 seconds |
| Collectibles | 3 Energy Cubes |
| Leaderboard | Global Top 10 |

## 🎮 Controls

| Key | Action |
|---|---|
| W / ↑ | Move Up |
| A / ← | Move Left |
| S / ↓ | Move Down |
| D / → | Move Right |

## 🏆 Leaderboard

Neon Escape features an online leaderboard powered by Google Sheets and Google Apps Script.

- Successful completion times are submitted automatically.
- Faster completion times receive higher rankings.
- The leaderboard displays the top 10 players.
- Players can refresh the rankings to view updated results.

Only successful escapes count towards the rankings.

## 🚀 Getting Started

### Requirements
- Godot Engine 4.x
- A computer running Windows, macOS or Linux.
- Internet connection for the online leaderboard.

### Running the Game

1. Clone or download this repository.
2. Open Godot.
3. Select **Import** in the Project Manager.
4. Select the folder containing `project.godot`.
5. Open the project.
6. Press the Play button to start Neon Escape.

### Leaderboard Configuration

The online leaderboard uses a Google Apps Script Web App connected to a Google Sheet.

To configure your own leaderboard:
1. Set up a Google Sheet to store player records.
2. Deploy a compatible Google Apps Script as a Web App.
3. Update the endpoint URL in `scenes/Online.gd`.
4. Ensure the deployment permissions allow the game to retrieve and submit scores.

## 🛠️ Built With

- [Godot Engine](https://godotengine.org/)
- [GDScript](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/index.html)
- [Google Sheets](https://sheets.google.com/)
- [Google Apps Script](https://developers.google.com/apps-script)

## 💡 Project Goal

Neon Escape was created as a game-development project to explore 2D game development, gameplay mechanics, collision detection, user interfaces, local data storage and online leaderboard integration using Godot.

## 🎯 The Challenge

**90 Seconds. 3 Cubes. One Way Out.**

Can you escape?

---
