# Agent-to-Agent HTTP Communication

You can communicate with agents in OTHER containers via HTTP. Each container's liaison agent exposes an HTTP API on port 8080.

## Container Hostnames

Containers are addressed by domain name:
- `claudecircle-dev:8080` - Development container
- `claudecircle-marketing:8080` - Marketing container
- `claudecircle-ops:8080` - Operations container
- `claudecircle-cxo:8080` - Executive container

## Making Requests

Use curl for inter-container communication:

```bash
# Query another container's liaison
curl -X POST http://claudecircle-marketing:8080/query \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Generate marketing copy for new auth feature", "from": "dev"}'

# Check container status
curl http://claudecircle-ops:8080/status
```

## API Endpoints

Each liaison agent exposes:

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/query` | POST | Send a prompt to the container's agents |
| `/status` | GET | Get container status |
| `/tasks` | GET | List active tasks |
| `/tasks` | POST | Create new task |

## Request/Response Format

```json
// Request
{
  "prompt": "Your request here",
  "from": "dev",
  "priority": "normal",
  "callback": "http://claudecircle-dev:8080/callback"
}

// Response
{
  "status": "accepted",
  "task_id": "abc123",
  "message": "Task queued for processing"
}
```

## When to Use A2A

Use inter-container communication when:
- Requesting work from a different domain (dev asking marketing for copy)
- Reporting cross-domain status (ops notifying dev of deployment)
- Executive decisions affecting multiple domains
