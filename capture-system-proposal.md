# Personal Life Capture System - Detailed Proposal

**Date:** 2026-01-03
**Goal:** Build a zero-leakage task capture and planning system for personal life

---

## Problem Statement

**What's Working:**
- ✅ Coding workflow with Taskwarrior is solid
- ✅ Have digital tools (Taskwarrior, fzf, shell automation)
- ✅ Use contexts to separate work/personal/dance

**What's Not Working:**
- ❌ Personal tasks fall through the cracks (household, dance curriculum, administration)
- ❌ Random thoughts don't get captured
- ❌ Lack of structured planning at daily/weekly/monthly/yearly time horizons
- ❌ No forcing functions to ensure reviews happen

---

## Solution: Five-Tier Planning System

### Tier 1: Quick Capture
**Problem:** Random thoughts and tasks don't get captured in the moment

**Solution:** Instant capture via keyboard shortcut

**Implementation:**
- Script: `task-capture` in `~/.dotfiles/bin/`
- Keybinding: `Ctrl+M T` (T for Task)
- Interactive prompts:
  1. Task description
  2. Context selection (home/work/zouk) via fzf
  3. Due date selection (today/tomorrow/this week/next week/this month/custom)
- Adds task to Taskwarrior immediately

**Usage Example:**
```bash
# Press Ctrl+M T from anywhere
Task: Schedule dentist appointment
Context: home
Due: this week
✓ Task captured
```

---

### Tier 2: Daily Planning

#### Morning Planning
**Problem:** Starting the day without clarity on priorities

**Solution:** Morning planning routine

**Implementation:**
- Script: `task-daily-plan`
- Keybinding: `Ctrl+M D` (D for Daily)
- Shows:
  - Tasks due today
  - Overdue tasks
  - This week's tasks
- Prompts to:
  - Set priorities (mark with priority:H)
  - Defer tasks if needed
  - Break down large tasks
- Opens `tw` (fzf interface) for interactive management

#### Evening Review
**Problem:** Day ends without capturing follow-ups or reviewing progress

**Solution:** Evening review routine

**Implementation:**
- Script: `task-daily-review`
- Keybinding: `Ctrl+M R` (R for Review)
- Shows:
  - Tasks completed today (celebration!)
  - Still pending today
  - Blocked tasks
- Prompts to:
  - Mark completed tasks as done
  - Defer incomplete tasks
  - Delete irrelevant tasks
- Brain dump session at end
- Records review completion

---

### Tier 3: Weekly Review

**Problem:** Lose sight of the bigger picture, tasks get stale, no weekly planning

**Solution:** Comprehensive weekly review (GTD-style)

**Implementation:**
- Script: `task-weekly-review`
- Keybinding: `Ctrl+M Shift+W` (W for Weekly)
- Workflow:
  1. **Summary:** Stats from this week (completed, added, pending)
  2. **By context:** Review each context (home/work/zouk) separately
     - All pending tasks
     - Old tasks (>30 days) needing review
     - Waiting/blocked tasks
  3. **Review checklist:**
     - Complete done tasks
     - Defer/delete stale tasks
     - Unblock waiting tasks
     - Set due dates
     - Break down large tasks
     - Set priorities for next week
  4. **Next week planning:**
     - Tasks due next week
     - High priority items
     - What are the 3 most important outcomes?

**Best time:** Sunday evening or Monday morning

---

### Tier 4: Monthly Planning

**Problem:** No monthly goal setting or major initiative planning

**Solution:** Monthly planning session

**Implementation:**
- Script: `task-monthly-plan`
- Keybinding: `Ctrl+M Shift+M` (M for Monthly)
- Workflow:
  1. **Last month summary:** Highlights and completed tasks
  2. **By context:** Plan for each area (home/work/zouk)
     - Tasks due this month
     - High priority items
  3. **Planning questions:**
     - What are this month's 3 major goals?
     - What projects need to be started?
     - What habits or routines to establish?
     - What's blocking progress?
  4. **Goal capture:** Add tasks with +monthly_goal tag

**Best time:** Last day or first day of each month

---

### Tier 5: Yearly Planning

**Problem:** No annual reflection or long-term goal setting

**Solution:** Yearly review and planning

**Implementation:**
- Script: `task-yearly-review`
- Keybinding: `Ctrl+M Shift+Y` (Y for Yearly)
- Workflow:
  1. **Last year summary:** Statistics and achievements
  2. **By context:** Set goals for each area
  3. **Reflection questions:**
     - What went well last year?
     - What didn't go as planned?
     - What do you want to achieve this year?
     - What habits support those goals?
     - What might get in the way?
  4. **Goal capture:** Add 3-5 tasks per context with +yearly_goal tag

**Best time:** End of December or early January

---

## Forcing Functions (Ensuring Reviews Happen)

### Shell Reminders

**Implementation:** `_task_daily_reminder()` function called on shell startup

**Behavior:**
- **Morning (6am-11am):** "☀️ Good morning! Ready to plan your day? (Ctrl+M D)"
- **Evening (6pm-11pm):** "🌙 Time to review your day! (Ctrl+M R)"
- **Weekly (Sun evening/Mon morning):** "📅 Weekly review time! (Ctrl+M Shift+W)"
- **Monthly (last/first day):** "📆 Monthly planning time! (Ctrl+M Shift+M)"

**Smart features:**
- Only shows once per day (uses cache files in `$XDG_CACHE_HOME`)
- Only in tmux sessions (not on every shell)
- Non-intrusive, just a gentle reminder

---

## Taskwarrior Configuration Enhancements

### New Reports

**`task today`** - Tasks due today
- Quick view of today's commitments
- Sorted by urgency

**`task thisweek`** - Tasks due this week
- Planning the week ahead
- Sorted by due date, then urgency

**`task stale`** - Old tasks needing review
- Tasks >30 days old that might need cleanup
- Sorted by age (oldest first)

**`task goals`** - Goals and major initiatives
- Shows tasks tagged with +yearly_goal or +monthly_goal
- Sorted by due date

### New Tags

- `+review` - Marks that a review was completed
- `+daily` / `+weekly` / `+monthly` / `+yearly` - Type of review
- `+monthly_goal` - Monthly goals
- `+yearly_goal` - Yearly goals

### Urgency Adjustments

Tweaked coefficients to better prioritize:
- High priority: 6.0 (up from default)
- Due date: 12.0 (up from default)
- Blocking: 8.0 (up from default)
- Age: 2.0 (standard)

---

## Integration with Existing Workflow

### Keybinding Design

Uses `Ctrl+M` prefix (already established in your config):
- Existing: `Ctrl+M J` (projects), `Ctrl+M W` (vimwiki), `Ctrl+M B` (bindings)
- New: `Ctrl+M T` (capture), `Ctrl+M D` (daily), `Ctrl+M R` (review)
- Weekly/Monthly/Yearly use Shift for less frequent operations

**Why this works:** Follows your existing pattern, won't conflict with coding

### Respects Contexts

All scripts work with your existing context system:
- home (174 tasks currently)
- work (91 tasks)
- zouk (18 tasks)

Scripts prompt to select which context to plan/review, maintaining separation.

### Doesn't Interfere with Coding

- No changes to git hooks that might affect coding workflow
- No changes to coding-related task management
- Focused entirely on personal life organization
- All keybindings are opt-in (you trigger them)

### Works with Existing `tw` Script

Your existing `tw` fzf wrapper continues to work as-is. The planning scripts complement it:
- Planning scripts = structured reviews
- `tw` script = interactive task management
- They work together seamlessly

---

## Optional Enhancements

### 1. Visual Task Count in Prompt

**What:** Enable the taskwarrior segment in Powerlevel10k

**How:** Uncomment line 101 in `.p10k.zsh`

**Benefit:** Always see task counts in your prompt (overdue + pending)

### 2. Git Post-Commit Capture Hook

**What:** Occasionally prompt for follow-ups after commits

**How:** Enhance existing `post-commit` hook

**Benefit:** Catch tasks related to code changes (docs, tests, reviews)

**Note:** Only 10% of commits, skippable, personal repos only

### 3. Enhanced `tw` Script Keybindings

**What:** Add planning shortcuts to existing fzf interface

**Additions:**
- `P` key - Open daily planning
- `R` key - Open daily review
- `W` key - Open weekly review
- `G` key - Show goals report

**Benefit:** Access planning from within your existing task interface

---

## Implementation Approach

### Phase 1: Core Capture (Week 1)
Focus on quick capture to stop the bleeding:
1. Create `task-capture` script
2. Add keybinding (`Ctrl+M T`)
3. **Checkpoint:** Can capture tasks instantly from anywhere

### Phase 2: Daily Routines (Week 2)
Build the daily habit:
1. Create `task-daily-plan` script
2. Create `task-daily-review` script
3. Add keybindings (`Ctrl+M D`, `Ctrl+M R`)
4. **Checkpoint:** Daily planning/review becomes routine

### Phase 3: Forcing Functions (Week 2-3)
Ensure reviews happen:
1. Add `_task_daily_reminder()` function
2. Add call to .zshrc
3. **Checkpoint:** Reminders appear at appropriate times

### Phase 4: Weekly/Monthly/Yearly (Week 3-4)
Add longer time horizons:
1. Create weekly/monthly/yearly scripts
2. Add keybindings
3. **Checkpoint:** All time horizons covered

### Phase 5: Configuration (Week 4)
Polish the system:
1. Update taskrc with reports and settings
2. Test all reports
3. **Checkpoint:** System fully operational

### Phase 6: Optional Enhancements (Ongoing)
Add nice-to-haves:
1. Enable P10k taskwarrior segment
2. Add git hook if desired
3. Enhance `tw` script

---

## File Changes Summary

### New Files (6 scripts in `~/.dotfiles/bin/`)
- `task-capture` - Quick capture
- `task-daily-plan` - Morning planning
- `task-daily-review` - Evening review
- `task-weekly-review` - Weekly review
- `task-monthly-plan` - Monthly planning
- `task-yearly-review` - Yearly review

### Modified Files
1. **`~/.dotfiles/lib/config/zsh/functions.zsh`**
   - Add 7 new functions (6 keybindings + 1 reminder)
   - ~100 lines total

2. **`~/.dotfiles/lib/config/zsh/.zshrc`**
   - Add 3 lines at the end to call reminder function

3. **`~/.dotfiles/lib/config/task/taskrc`**
   - Add 4 new reports
   - Add UDA for review types
   - Add urgency tweaks
   - ~50 lines total

### Optional Files
- `~/.dotfiles/lib/config/git/git_template/hooks/post-commit` - Git integration
- `~/.dotfiles/lib/config/zsh/.p10k.zsh` - Visual task count

---

## Success Metrics

### Immediate (Week 1-2)
- [ ] Quick capture works and is used daily
- [ ] Daily planning happens most mornings
- [ ] Daily review happens most evenings
- [ ] Reminders appear at appropriate times

### Short-term (Month 1)
- [ ] Weekly review happens consistently
- [ ] Fewer personal tasks falling through cracks
- [ ] Clear visibility into household/dance/admin work
- [ ] No interference with coding productivity

### Long-term (Month 2-3)
- [ ] Monthly planning becomes routine
- [ ] Yearly goals are set and tracked
- [ ] Task completion rate improves
- [ ] System feels natural and sustainable

---

## Maintenance

### Weekly
- Check reminder cache files aren't accumulating

### Monthly
- Review which routines you're actually using
- Adjust scripts based on usage patterns

### Quarterly
- Evaluate system effectiveness
- Refine based on what works

---

## Design Rationale

### Why This Approach?

1. **Leverages existing tools:** No new apps to learn, uses Taskwarrior + fzf + Zsh
2. **Non-intrusive:** Keybindings won't interfere with coding
3. **Context-aware:** Respects your existing home/work/zouk separation
4. **Progressive disclosure:** Simple capture, detailed reviews only when needed
5. **Forcing functions:** Reminders ensure reviews happen
6. **Flexible:** Can run any routine on-demand via keybindings
7. **Incremental:** Implement one tier at a time, validate before moving forward

### Why Not [Alternative Approach]?

**GUI apps (Todoist, Things, etc.):**
- You already have Taskwarrior working
- Context switching to GUI would slow you down
- Less scriptable and automatable

**Bullet journal / paper:**
- Digital is faster for you (tech-savvy)
- Harder to integrate with existing shell workflow
- Can't automate reminders or reports

**Just better discipline:**
- Discipline fails without forcing functions
- System should make good behavior the default
- Friction is the enemy of capture

---

## Next Steps

1. **Review this proposal** - Does this solve your problems?
2. **Approve implementation** - Ready to proceed?
3. **Start with Phase 1** - Quick capture first
4. **Iterate** - Refine based on actual usage

Ready to build this?
