# Spring Boot Smoke Tester Skill

Use this skill after making changes to a Spring Boot service to verify it starts, responds, and handles basic requests correctly.

## Goal

Start the application locally, run a minimal set of smoke tests against the running service, and report any startup failures, HTTP errors, or behavioral regressions. Do not modify production data or external systems.

## Rules

- Confirm the project compiles before starting the application: `./mvnw clean compile`.
- Use the dev profile (in-memory DB) unless the user specifies otherwise.
- Do not call destructive endpoints (DELETE, PUT without idempotency, POST without test data).
- Stop the application after tests complete.
- If the service fails to start, report the first error in the log — do not retry with different config.

## Context Needed

- `pom.xml` — to know the artifact name and port
- `application-dev.yml` or `application.yml` — to know the port, context path, and active profiles
- `Secrets` — if the service needs API keys or keystores to start

## Inspect / Search

```bash
# Find the port and context path
rg "server.port\|server.servlet.context-path" src/main/resources/application*.yml 2>/dev/null

# Find the main class
rg "SpringApplication\.run\|SpringApplicationBuilder" --type java | head -3
```

## Required Steps

### Step 1: Compile

```bash
./mvnw clean compile -pl <module> -Pdev
```

### Step 2: Start application in background

```bash
./mvnw spring-boot:run -pl <module> -Pdev > /tmp/app.log 2>&1 &
echo $! > /tmp/app.pid
# Wait for startup
sleep 30
grep "Started\|ERROR\|Exception" /tmp/app.log
```

### Step 3: Smoke test endpoints

```bash
curl -s -o /dev/null -w "%{http_code}" http://localhost:<port>/actuator/health
curl -s http://localhost:<port>/swagger-ui/index.html | head -5
curl -s http://localhost:<port>/v3/api-docs | head -5
```

### Step 4: Test a representative endpoint

```bash
curl -s -w "\n%{http_code}" -X POST "http://localhost:<port>/api/..." \
  -H "Content-Type: application/json" \
  -H "X-API-Key: test-key" \
  -d '{"field": "value"}'
```

### Step 5: Stop application

```bash
kill $(cat /tmp/app.pid) 2>/dev/null
```

## Required Output

1. Startup status (success/failure, time, first error if failed)
2. Health check HTTP status
3. Swagger UI accessibility
4. Representative endpoint response (status code + body snippet)
5. Any errors or warnings from application log

## Final Rule

A service that compiles but does not start is broken. Report the startup error before suggesting code changes.
