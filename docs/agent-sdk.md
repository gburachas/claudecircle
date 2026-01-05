# Claude Agent SDK in Claudebox

This guide explains how to use the Claude Agent SDK within the Claudebox environment.

## Overview

Claudebox provides a dedicated `agent` profile that pre-installs the necessary SDKs for building AI agents using Claude.
The SDKs are available for both Python and TypeScript.

## Enabling the Agent Profile

To enable the Agent SDK in your project, run:

```bash
claudecircle add agent
```

This will trigger a rebuild of your project's Docker image to include the SDKs.

## Python SDK

The Python SDK (`claude-agent-sdk`) is installed in the project's virtual environment.

### Usage Example

```python
import asyncio
from claude_agent_sdk import Agent

async def main():
    agent = Agent()
    result = await agent.run("Hello, Claude!")
    print(result)

if __name__ == "__main__":
    asyncio.run(main())
```

### Environment Variables

The following environment variables are passed from the host to the container and are available to the SDK:
- `CLAUDE_CODE_USE_BEDROCK`
- `CLAUDE_CODE_USE_VERTEX`
- `CLAUDE_CODE_USE_FOUNDRY`
- `AWS_PROFILE`
- `AWS_REGION`
- `GOOGLE_APPLICATION_CREDENTIALS`
- `AZURE_OPENAI_API_KEY`
- `OPENAI_API_KEY`

Ensure these are set in your host environment before running `claudecircle`.

## TypeScript SDK

The TypeScript SDK (`@anthropic-ai/claude-agent-sdk`) is installed globally in the container.

### Usage Example

```typescript
import { Agent } from '@anthropic-ai/claude-agent-sdk';

const agent = new Agent();
const result = await agent.run("Hello, Claude!");
console.log(result);
```

## Multi-Agent Orchestration

Claudebox supports native multi-agent orchestration using the Agent SDK. You can define subagents in `.claude/agents` and delegate tasks to them.

### Defining Subagents

Create a markdown file in `.claude/agents/` (e.g., `.claude/agents/coder.md`) with YAML frontmatter:

```markdown
---
description: A specialized agent for writing code.
---
You are a skilled software engineer. Write clean, efficient, and well-documented code.
```

### Using Subagents

You can invoke subagents from your main agent script using `ClaudeAgentOptions`:

```python
import asyncio
import os
import re
from claude_agent_sdk import query
from claude_agent_sdk.types import ClaudeAgentOptions, AgentDefinition

# Helper to load agent definition from file
def load_agent(name):
    # In Claudebox, agents are typically in .claude/agents relative to project root
    path = f".claude/agents/{name}.md"
    if not os.path.exists(path):
        # Fallback to user home if not in workspace
        path = os.path.expanduser(f"~/.claude/agents/{name}.md")
        
    with open(path, "r") as f:
        content = f.read()
    
    # Parse frontmatter (simplified)
    match = re.match(r"^---\n(.*?)\n---\n(.*)", content, re.DOTALL)
    if not match:
        raise ValueError(f"Invalid agent file format in {path}")
    
    frontmatter = match.group(1)
    prompt = match.group(2).strip()
    
    description = ""
    for line in frontmatter.split("\n"):
        if line.startswith("description:"):
            description = line.split(":", 1)[1].strip()
            
    return AgentDefinition(
        description=description,
        prompt=prompt
    )

async def main():
    # Load the subagent
    coder = load_agent("coder")
    
    # Configure options with the subagent
    options = ClaudeAgentOptions(
        agents={"coder": coder},
        # sandbox={"enabled": False} # Disable sandbox if running inside Docker without nested virtualization
    )
    
    # Delegate task
    async for msg in query(prompt="Please use the 'coder' agent to write a Fibonacci function.", options=options):
        print(msg)

if __name__ == "__main__":
    asyncio.run(main())
```

### Authentication

The Agent SDK requires authentication. In Claudebox, you must authenticate the container slot:

1.  Start a shell in the slot: `./claudecircle/main.sh slot <N> shell`
2.  Run `claude login` and follow the browser instructions.
3.  Once authenticated, the SDK will automatically use the credentials.
