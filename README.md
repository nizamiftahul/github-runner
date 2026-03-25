# github-runner

A minimal, Docker-based self-hosted GitHub Actions runner setup.

This repository provides a small containerized runner you can use to host GitHub Actions runners on machines you control. It includes a `Dockerfile`, `docker-compose.yml`, and `entrypoint.sh` to register/unregister and run the runner process.

## Features
- Simple Docker + docker-compose setup
- Automatic registration/unregistration via `entrypoint.sh`
- Configurable via environment variables

## Prerequisites
- Docker (20.10+)
- docker-compose (1.27+ or Docker Compose v2)

## Quick Start

1. Create a `.env` file with the required variables (example below).
2. Build and start the runner with:

```bash
docker-compose up -d --build
```

3. Check logs:

```bash
docker-compose logs -f
```

## Example `.env`

Use a GitHub personal access token with `repo` (for repo-scoped) or `admin:org` (for org-scoped) permissions, or a registration token obtained via the GitHub API.

```env
# GitHub token or registration token
GITHUB_TOKEN=ghp_XXXXXXXXXXXX

# Either repository (owner/repo) or organization (org)
# For a repository runner use: RUNNER_REPOSITORY=owner/repo
# For an org runner use: RUNNER_ORG=your-org
RUNNER_REPOSITORY=
RUNNER_ORG=

# Optional: name and labels for the runner
RUNNER_NAME=github-runner-1
RUNNER_LABELS=linux,docker

# Working directory for actions
WORK_DIR=/tmp/actions-runner
```

Note: Only set `RUNNER_REPOSITORY` or `RUNNER_ORG` depending on whether you register the runner to a repository or organization.

## How it works

- `entrypoint.sh` registers the runner using the provided token and environment variables, then launches the runner process.
- On shutdown, the entrypoint attempts to unregister the runner so it does not remain listed in GitHub.

## Docker Compose (usage)

Start the service:

```bash
docker-compose up -d --build
```

Stop and remove containers and volumes:

```bash
docker-compose down -v
```

## Troubleshooting
- If the runner fails to register, verify your token and whether you set `RUNNER_REPOSITORY` or `RUNNER_ORG` correctly.
- Check container logs: `docker-compose logs -f`.
- Ensure required ports and network access to GitHub are available from the host.

## Contributing
Contributions are welcome. Open issues or PRs for bugs and improvements.

## License
This project is provided as-is. Add a license file if you plan to share.
