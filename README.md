<div align="center">

# 🗿 caveman-sigma

**Cut the token bill per task, not just the word count.**

A Claude Code skill that fuses [caveman](https://github.com/JuliusBrussee/caveman)-style terse output with cost-aware agent behavior and a harness-audit playbook.
Quality is the floor. Tokens are the variable.

[Install](#install) · [What it does](#what-it-does) · [Levels](#levels) · [Audit mode](#audit-mode) · [Why not just "be brief"](#why-not-just-be-brief) · [Русский](#по-русски)

</div>

---

## The problem

"Be brief" saves a few output tokens and nothing else. The real bill is **per task**:

- every turn re-sends the whole prefix (tools, instructions, history);
- output, uncached input and cached input are priced very differently;
- one giant file read or log dump is re-billed on every later turn;
- a trick that shrinks each message but adds turns can cost *more*.

Terse style alone optimizes the cheapest part. `caveman-sigma` optimizes the whole task.

## What it does

Two layers in one skill.

### Layer A — Behave (every session)

| Area | Rule |
|---|---|
| **Output** | Answer first. No greeting, preamble, recap, or sign-off. Fragments, short words, one idea per sentence. |
| **Preserved verbatim** | Code, commands, paths, URLs, identifiers, error text, numbers, units, and negations (`not`, `never`, `only`). |
| **Reading** | Search before read. Read the range, not the file. Never re-read what is already in context. |
| **Tool calls** | Batch independent calls in one turn. Filter output at the source. Big output goes to a file, then `tail`/`grep`. |
| **Editing** | Smallest correct diff. No drive-by refactors, no unrequested extras, no half-finished stubs. |
| **Delegation** | Subagent only when fresh context beats coordination cost. Short handoffs: done / findings / concerns / deviations. |
| **Cache** | Keep the prefix stable, volatile content last, never switch models mid-conversation. |
| **Auto-clarity** | Security warnings, irreversible actions, step-by-step instructions and confused users get full plain sentences. |

Commits, PR descriptions and docs for other people are always written normally.

### Layer B — Audit (on request)

A playbook for making any LLM agent harness cheaper without hurting task success:

`map → measure → rank → change safely → flag the rest → report`

Covers system prompt triage (keep / rewrite / delete / move), tool-definition offloading, cache layout, tool-result handling, compaction, subagents and model mix, per-model fit, and offline/online validation. Includes a change policy (what to change directly, what goes behind a flag, what to only propose) and a five-part report format.

## Install

```bash
git clone https://github.com/yeainworks/caveman-sigma.git
cd caveman-sigma
./install.sh
```

The script symlinks `skills/caveman-sigma` into `~/.claude/skills/`. Restart Claude Code, then:

```
/caveman-sigma          # full level
/caveman-sigma ultra    # most compressed
/caveman-sigma lite     # light trim
```

Stop with `stop caveman` or `normal mode`.

Manual install: copy `skills/caveman-sigma/` into `~/.claude/skills/` (user-wide) or `.claude/skills/` (per project).

## Levels

| Level | Style |
|---|---|
| `lite` | Drop filler and pleasantries. Normal sentences. |
| `full` *(default)* | Also drop articles, use fragments and short synonyms. |
| `ultra` | Also abbreviations (`DB`, `cfg`, `req`), arrows for causality (`X → Y`), one-line status. |

Example:

> **Normal:** "The reason your component re-renders is likely that you create a new object reference on each render, so React's shallow comparison sees a different prop every time. I'd recommend memoizing it."
>
> **full:** "New object ref each render. Inline object prop = new ref = re-render. Wrap in `useMemo`."
>
> **ultra:** "Inline obj prop → new ref → re-render. `useMemo`."

## Audit mode

Ask for it in plain words:

```
Use caveman-sigma to audit this agent harness for token cost.
```

You get a harness map, cost share by source × billing type, a ranked list of changes (with estimated savings, risk, validation and rollback), a system-prompt diff with a reason per line, a test plan for flagged changes, and a list of gaps.

## Why not just "be brief"

The skill deliberately avoids the traps that make token-saving backfire:

- ❌ Telling the model to "conserve tokens" makes it reluctant and quit early. Change what is *sent*, not how hard the model tries.
- ❌ Truncating tool output loses data. Write it to a file and return path, size and tail.
- ❌ Dropping reasoning items to save input costs more in re-derivation.
- ❌ Forcing terser output than a model was trained on can mean less thinking and worse results.
- ❌ Optimizing raw tokens, per request, on evals. Optimize price-weighted cost, per task, on real usage.

Terseness applies to what is **said**, never to how carefully the work is **done**.

## FAQ

**Does it make answers worse?** It compresses wording, not work. Verification, tests and reasoning are explicitly protected. Measure on your own tasks before trusting any percentage, including ours.

**Do you publish savings numbers?** No. Savings depend on your tasks, models and caching. Benchmark before/after on your own workload (Layer B explains how).

**Does it work with other agents?** The skill is a plain `SKILL.md`; Layer A's rules are tool-agnostic and can be pasted into `AGENTS.md`/`CLAUDE.md` equivalents.

## Credits

Terse-output idea from [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman). Token-efficiency principles adapted from public write-ups on agent-harness cost optimization.

## License

[MIT](LICENSE)

---

## По-русски

**caveman-sigma** — скилл для Claude Code: краткий «пещерный» стиль ответов + привычки, которые снижают стоимость **всей задачи** (дешёвое чтение, параллельные вызовы, большой вывод в файл, стабильный кэш, короткие handoff от субагентов) + плейбук аудита агентного харнесса.

Установка:

```bash
git clone https://github.com/yeainworks/caveman-sigma.git && cd caveman-sigma && ./install.sh
```

Запуск: `/caveman-sigma [lite|full|ultra]`. Выключить: «stop caveman». Качество — нижняя граница, экономия — переменная: краткость касается того, что агент *говорит*, а не того, насколько тщательно он *работает*.
