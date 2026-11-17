# 🗼 Tower of Hanoi (Prolog + HTML)

A Tower of Hanoi game you play in your browser. The game rules and the solver are written in **Prolog (SWI-Prolog)**, and the page is plain **HTML + JavaScript**. A small Prolog web server connects the two.

---

## ✨ What it does

- Drag and drop disks to play
- Choose 3 to 7 disks
- Prolog checks every move and tells you if it is not allowed
- Click **Auto Solve (Prolog)** and watch Prolog solve it for you
- Counts your moves and shows the minimum possible

---

## 📋 What you need

Only one thing: **SWI-Prolog** (free)

Download it here: https://www.swi-prolog.org/Download.html

> Windows tip: during install, tick **"Add swipl to the system PATH"**.

---

## 🚀 How to run it (3 steps)

**Step 1.** Download or clone this repo.

```
git clone https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git
```

**Step 2.** Open a terminal (PowerShell) inside the project folder and run:

```
swipl server.pl
```

You should see:

```
Server running. Open http://localhost:8080 in your browser.
```

**Step 3.** Open your browser and go to:

```
http://localhost:8080
```

That's it. Have fun! 🎉

To stop the server, press `Ctrl + C` then type `halt.` and press Enter.

---

## 🎮 How to play

1. Goal: move all disks from **Peg 1** to **Peg 3**.
2. Drag the top disk of a peg and drop it on another peg.
3. Rule: a bigger disk can never go on top of a smaller one.
4. Stuck? Press **Auto Solve (Prolog)**.
5. Press **Reset** to start over, or pick a different number of disks.

---

## 📁 Project files

| File | What it is |
|------|------------|
| `server.pl` | The Prolog web server. Has the game rules and the solver. **Run this one.** |
| `index.html` | The game page you see in the browser |
| `hanoi.pl` | Older standalone Prolog solver (prints moves in the terminal) |
| `Hanoi.html` | Older version of the page that reads `moves.js` (no server needed) |
| `moves.js` | Moves saved by `hanoi.pl`, used by `Hanoi.html` |

---

## 🧠 How it works

```
Browser (index.html)  <──── JSON ────>  Prolog server (server.pl)
   drag a disk        ── POST /move ──>   is this move legal?
   Auto Solve         ── GET /solve ──>   hanoi/5 returns all moves
```

The solver uses recursion:

1. Move the top `N-1` disks to the middle peg
2. Move the biggest disk to the last peg
3. Move the `N-1` disks on top of it

The smallest number of moves is always `2^N - 1` (3 disks = 7 moves).

---

## 🛠️ Troubleshooting

| Problem | Fix |
|---------|-----|
| `swipl` is not recognized | SWI-Prolog is not in PATH. Reinstall and tick the PATH option, or restart PowerShell. |
| Page does not open | Make sure the terminal still shows "Server running" and use `http://localhost:8080` |
| Port 8080 already in use | Close the other program using it, or change `8080` in the last lines of `server.pl` |
| Moves do nothing | Do not open `index.html` by double-clicking. Always open it through the server link. |

---

## 👥 Author

- Ken Austria

