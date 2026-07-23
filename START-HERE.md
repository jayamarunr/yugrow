# Yugrow Startup Checklist

## Begin Session

- [ ] `git pull`
- [ ] Check `RELEASE-CANDIDATE.md`
- [ ] Check `LEARNINGS.md`
- [ ] Start API: `cd apps/api && pnpm run build && pnpm run start`
- [ ] Start Flutter: `cd apps/mobile && flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0 --dart-define=API_BASE_URL=http://<YOUR_IP>:4000`
- [ ] Test on Phone: `http://<YOUR_IP>:8080`
- [ ] Review today's goal
- [ ] Begin work

## Shutdown

- [ ] `git status`
- [ ] `git add .`
- [ ] `git commit -m "Sprint X — description"`
- [ ] `git push`
- [ ] Stop API (Ctrl+C in API terminal)
- [ ] Stop Flutter (q in Flutter terminal)
- [ ] Close VS Code
