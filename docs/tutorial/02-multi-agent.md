# Tutorial 02: Multi-Agent Orchestration

In this tutorial, we will build a more complex application (a Todo List) by orchestrating multiple specialized agents.

## Goal

We will create a system with:
1.  **Planner Agent**: Breaks down the requirements.
2.  **Frontend Agent**: Writes HTML/CSS.
3.  **Backend Agent**: Writes JavaScript logic.

## Step 1: Define the Agents

We define agents using Markdown files with YAML frontmatter. Create a directory `.claude/agents` in your project root if it doesn't exist.

### Planner Agent (`.claude/agents/planner.md`)
```markdown
---
description: A planning agent that breaks down tasks and delegates them.
---
You are a Project Planner. Your goal is to break down a complex web application request into smaller, manageable tasks for specialized agents.

You have access to two specialized agents:
1.  `frontend`: Expert in HTML and CSS.
2.  `backend`: Expert in JavaScript logic and data handling.

When you receive a request:
1.  Analyze the requirements.
2.  Create a step-by-step plan.
3.  Delegate the UI tasks to the `frontend` agent.
4.  Delegate the logic tasks to the `backend` agent.
5.  Coordinate the integration of their work.
```

### Frontend Agent (`.claude/agents/frontend.md`)
```markdown
---
description: A frontend specialist agent.
---
You are a Frontend Developer. You specialize in creating semantic HTML5 and responsive CSS3.

Your responsibilities:
1.  Create the structure of web pages (`.html` files).
2.  Create the styling of web pages (`.css` files).
3.  Ensure the HTML correctly links to the CSS and JS files as instructed.
```

### Backend Agent (`.claude/agents/backend.md`)
```markdown
---
description: A backend/logic specialist agent.
---
You are a Backend/Logic Developer. You specialize in writing JavaScript for web applications.

Your responsibilities:
1.  Implement the application logic (`.js` files).
2.  Handle user interactions (event listeners).
3.  Manage data storage (e.g., localStorage).
```

## Step 2: Create the Orchestrator Script

Create `examples/multi-agent/main.py`. This script loads the agents and starts the process.

```python
import asyncio
import os
import re
from claude_agent_sdk import query
from claude_agent_sdk.types import ClaudeAgentOptions, AgentDefinition

# Helper function to load agent definitions
def load_agent(name):
    # Logic to find .claude/agents/{name}.md
    # (See full implementation in examples/multi-agent/main.py)
    ...

async def main():
    print("Initializing Multi-Agent System...")
    
    # Load agents
    planner = load_agent("planner")
    frontend = load_agent("frontend")
    backend = load_agent("backend")

    # Configure options with all agents
    options = ClaudeAgentOptions(
        agents={
            "planner": planner,
            "frontend": frontend,
            "backend": backend
        },
        permission_mode="bypassPermissions"
    )
    
    prompt = """
    Please build a simple Todo List application.
    Requirements:
    1. Users can add new tasks.
    2. Users can mark tasks as complete.
    3. Users can delete tasks.
    4. Tasks should be saved in localStorage.
    
    Use the 'planner' agent to coordinate the 'frontend' and 'backend' agents.
    """
    
    print("Sending request to Planner...")
    async for msg in query(prompt=prompt, options=options):
        print(msg)

if __name__ == "__main__":
    asyncio.run(main())
```

## Step 3: Run the System

1.  **Navigate to the Directory**:
    ```bash
    cd examples/multi-agent
    ```

2.  **Execute the Script**:
    ```bash
    python main.py
    ```

## Step 4: Verify the Output

You should see the agents collaborating in the output logs. Once finished, check for:
*   `index.html`
*   `styles.css`
*   `app.js`

Open `index.html` in a browser to test your new Todo List app!

## Conclusion

You have successfully built a multi-agent system using the Claude Agent SDK! The **Planner** agent took your high-level request, broke it down, and delegated specific tasks to the **Frontend** and **Backend** agents, resulting in a complete application.
