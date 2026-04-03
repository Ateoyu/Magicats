## **1) Overview**

- **One-sentence pitch:**  
    A fast-paced survivor-like game where you play as a magical cat, auto-casting spells and evolving your build to survive waves of enemies.

- **Target audience:**  
    Fans of survivor-like / roguelite games, casual to mid-core players, ages 12+, players who enjoy build crafting and short session gameplay.

- **Platforms:**  
    PC

- **Player fantasy:**  
    “I am a powerful magical cat effortlessly unleashing chaotic spell combinations while outlasting overwhelming enemy hordes.”

- **Design pillars:**
    - Simple controls, deep builds
    - Constant progression and reward feedback
    - Procedurally generated background, offering an unlimited playing field
    - Readable chaos (clarity despite visual intensity)
    - Short sessions, long-term mastery

- **Non-goals:**
    - No complex narrative-driven gameplay
    - No precise/manual aiming mechanics
    - No multiplayer 

---

## **2) Core Gameplay**
- **Core loop:**  
    Kill enemies -> collect XP gems -> level up -> choose upgrades -> grow stronger -> face harder waves -> survive until the waves end.

- **Controls summary:**
    - Movement: WASD
    - No manual attacking (auto-attacks and abilities)
    - Menu navigation via mouse

- **Win/lose conditions:**
    - **Lose:** Player HP reaches zero
    - **Win:** Survive as long as possible / win ***(survive 10min)***

- **Game modes:**
    - **Standard Run:** Survival with scaling difficulty lasting 10 minutes

---

## **3) Systems (Rules)**

- **Movement:**
    - Free 2D movement across procedurally generated terrain
    - Movement speed affected by upgrades

- **Combat:**
    - Fully automatic attacks and abilities
    - Spells trigger based on cooldowns
    - Combat emphasizes positioning and movement
    - Visual clarity is important despite high enemy counts

- **Progression:**
    - XP gained from enemy drops (gems)
    - Level-ups trigger upgrade selection (randomized choices)
    - Upgrade types:
        - Stat boosts (health, speed)
        - Spell upgrades
        - New spell unlocks
    - Builds evolve dynamically each run

- **Economy:**
    - Primary resource: Experience (XP)
    - Upgrade choices are opportunity-based, not purchasable

- **AI:**
    - Enemies follow simple pathing toward the player
    - Variations include:
        - Fast enemies
        - Tanky enemies

- **Difficulty and balancing notes:**
    - Difficulty ramps over time via:
        - Increased spawn rates
        - Stronger enemies
        - Mixed enemy types
    - Balance focuses on:
        - Avoiding “dead builds”
        - Ensuring multiple viable strategies
        - Managing exponential power growth vs. enemy scaling

---

## **4) Content**

- **Levels / maps:**
    - Procedurally generated terrain
    - Infinite map
    - Visual variation between runs

- **Characters / classes:**
    - Base: Magical cat
    - _(Future)_ Different cats with unique starting abilities or stats

- **Enemies:**
    - Basic chasers
    - High-health tanks
    - _(Future)_ Elite enemies with special abilities
    - _(Future)_ Boss encounters at time intervals

- **Items:**
    - Passive upgrades (stat boosts)
    - Passive spells (projectiles, AoE, orbitals)
    - Upgrade tiers for abilities

- **Narrative beats:**
    - Minimal narrative
    - Light theme: magical survival fantasy

---

## **5) UX and UI**

- **Player journey (flow):**  
    Start game -> spawn into map -> fight enemies -> level up -> choose upgrades -> escalate difficulty -> die -> restart or continue saved run

- **HUD requirements:**
    - Health bar
    - XP bar / level indicator
    - Timer (run duration)
    - Current abilities display
    - Upgrade selection screen (on level-up)

- **Menus:**
    - Main menu (start/continue/settings)
    - Pause menu
    - Death menu
    - Win Menu
    - Settings menu:
        - Resolution
        - Display mode (fullscreen/windowed/borderless)
        - Audio controls

- **Accessibility:**
    - Adjustable audio levels
    - Scalable UI

---

## **6) Production**

- **Milestones:**
    - **Prototype:** Core loop functional (movement, combat, XP, leveling)
    - **Alpha:** Basic content (enemies, spells, procedural map)
    - **Beta:** Balancing, UI polish, save system, audio
    - **Release:** Stable build with sufficient content variety

- **Risks and unknowns:**
    - Balancing exponential scaling (player vs. enemies)
    - Maintaining visual clarity during chaos
    - Ensuring long-term replayability
    - Performance with large enemy counts

- **Dependencies:**
    - Game engine (unspecified in repo)
    - Audio assets (music + SFX)
    - Procedural generation system
    - Save/load system implementation

---

## **7) Marketing and Monetization**

- **Positioning:**  
    A charming, accessible survivor-like with a magical cat theme and strong build experimentation.

- **Competitors:**
    - Vampire Survivors
    - Brotato

- **Pricing / business model:**
    - One-time purchase