# Blackboard Communication Pattern

You have access to a shared blackboard folder at `/workspace/.claude/blackboard/` for coordinating with other agents in your container.

## Writing to Blackboard

When you complete a task or have information to share:

```bash
# Create a timestamped entry
echo '{"type": "task_complete", "agent": "coder", "task": "implement-auth", "output": "Created auth.py"}' > /workspace/.claude/blackboard/$(date +%s)_coder_complete.json
```

## Reading from Blackboard

Check for updates from other agents:

```bash
# List recent entries
ls -lt /workspace/.claude/blackboard/ | head -10

# Read latest entry from a specific agent
cat /workspace/.claude/blackboard/*_planner_*.json | tail -1
```

## File Naming Convention

`{timestamp}_{agent}_{type}.json`

Examples:
- `1704825600_planner_task.json` - New task from planner
- `1704825700_coder_complete.json` - Coder completed task
- `1704825800_reviewer_feedback.json` - Reviewer feedback

## Message Types

- `task` - New task assignment
- `complete` - Task completed
- `feedback` - Review feedback
- `question` - Question for another agent
- `status` - Status update
