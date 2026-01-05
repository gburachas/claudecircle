# Tutorial 01: Single Agent Web App

In this tutorial, we will create a simple "Hello World" web application using a single Claude agent.

## Goal

We want to write a Python script that instructs an agent to:
1.  Create an `index.html` file.
2.  Create a `style.css` file.
3.  Link them together.

## Step 1: Create the Build Script

Create a file named `build.py` in your project directory (e.g., `examples/single-agent/build.py`).

```python
import asyncio
from claude_agent_sdk import query
from claude_agent_sdk.types import ClaudeAgentOptions

async def main():
    print("Initializing Single Agent...")
    
    # Define the task for the agent
    prompt = """
    You are a web developer. Please create a simple "Hello World" web application.
    
    1. Create an `index.html` file with a "Hello World" heading and a button that shows an alert when clicked.
    2. Create a `style.css` file to style the button and center the content.
    3. Link the CSS file in the HTML.
    
    Please write these files to the current directory.
    """
    
    print("Sending request to agent...")
    try:
        # Configure options to allow file writes without confirmation
        # Note: This requires running as a non-root user (default in Claudebox shell)
        options = ClaudeAgentOptions(permission_mode="bypassPermissions")
        
        # Send the query to the agent
        async for msg in query(prompt=prompt, options=options):
            print(msg)
            
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    asyncio.run(main())
```

## Step 2: Run the Script

1.  **Launch a Claudebox Shell**:
    Ensure you have an authenticated slot.
    ```bash
    ./claudecircle/main.sh slot 1 shell
    ```

2.  **Navigate to the Directory**:
    ```bash
    cd examples/single-agent
    ```

3.  **Execute the Script**:
    ```bash
    python build.py
    ```

## Step 3: Verify the Output

After the script completes, check the directory. You should see `index.html` and `style.css`.

You can view the content:
```bash
cat index.html
```

## How It Works

*   **`claude_agent_sdk.query`**: This is the main entry point. It sends your prompt to the Claude agent.
*   **`ClaudeAgentOptions`**: We used `permission_mode="bypassPermissions"` to allow the agent to write files immediately. Without this, the agent would ask for confirmation (which works in interactive mode, but `bypassPermissions` is smoother for automation).

## Next Steps

Now that you've built a simple app with one agent, let's see how to coordinate multiple agents to build something more complex!

[Go to Tutorial 02: Multi-Agent Orchestration](02-multi-agent.md)
