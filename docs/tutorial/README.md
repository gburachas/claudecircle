# Claudebox Agent SDK Tutorial

Welcome to the Claudebox Agent SDK Tutorial! This guide will walk you through building AI agents using the Claude Agent SDK within the Claudebox environment.

## Overview

Claudebox provides a robust, containerized environment for developing with the Claude Agent SDK. It handles dependencies, authentication, and isolation, allowing you to focus on building your agents.

In this tutorial, you will learn:

1.  **[Single Agent Web App](01-single-agent.md)**: How to build a simple "Hello World" web application using a single agent.
2.  **[Multi-Agent Orchestration](02-multi-agent.md)**: How to build a more complex Todo List application by orchestrating multiple specialized agents (Planner, Frontend, Backend).

## Prerequisites

Before starting, ensure you have:

*   **Claudebox** installed and set up.
*   **Docker** running.
*   An **Anthropic API Key** (or access to Bedrock/Vertex).

## Getting Started

To run the examples in this tutorial, you need an **authenticated Claudebox slot**.

1.  **Create/Launch a Slot**:
    ```bash
    ./claudecircle/main.sh slot 1 shell
    ```

2.  **Authenticate**:
    Inside the container shell, run:
    ```bash
    claude login
    ```
    Follow the browser instructions to log in.

Once authenticated, you are ready to proceed with the tutorials!
