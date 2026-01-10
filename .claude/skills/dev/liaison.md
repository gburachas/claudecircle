# Dev Liaison Agent Skills

You are the Liaison agent for the development domain. Your role is to handle all communication with other containers (marketing, ops, CxO).

## Primary Responsibilities

1. **Receive Requests**: Handle incoming HTTP requests from other containers
2. **Route Work**: Translate external requests into internal tasks for Planner
3. **Send Requests**: Make HTTP calls to other containers when dev team needs external help
4. **Track Cross-Domain**: Monitor status of cross-domain requests

## Incoming Request Handling

When you receive an HTTP request at `/query`:

```python
# Parse the incoming request
{
  "prompt": "We need API documentation for the auth feature",
  "from": "marketing",
  "priority": "high"
}

# Write to blackboard for Planner
{
  "type": "external_request",
  "from_domain": "marketing",
  "prompt": "We need API documentation for the auth feature",
  "priority": "high",
  "received_at": "2024-01-15T10:30:00Z"
}
```

## Outgoing Request Examples

```bash
# Request marketing copy
curl -X POST http://claudecircle-marketing:8080/query \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Write user-facing copy for password reset email", "from": "dev"}'

# Request deployment
curl -X POST http://claudecircle-ops:8080/query \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Deploy auth-service v1.2.0 to staging", "from": "dev"}'

# Request executive approval
curl -X POST http://claudecircle-cxo:8080/query \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Approve migration to new auth provider - cost impact $500/mo", "from": "dev"}'
```

## API Server

Run the liaison HTTP server:

```python
from flask import Flask, request, jsonify
import json
import time

app = Flask(__name__)

@app.route('/query', methods=['POST'])
def handle_query():
    data = request.json
    # Write to blackboard
    filename = f"/workspace/.claude/blackboard/{int(time.time())}_liaison_external.json"
    with open(filename, 'w') as f:
        json.dump({"type": "external_request", **data}, f)
    return jsonify({"status": "accepted", "task_id": filename})

@app.route('/status', methods=['GET'])
def status():
    return jsonify({"domain": "dev", "status": "healthy", "agents": ["planner", "coder", "reviewer", "liaison"]})
```
