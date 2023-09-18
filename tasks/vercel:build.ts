import { execSync } from 'child_process'
;(async () => {
  execSync('yarn prisma generate')
  execSync('yarn prisma migrate deploy')
  execSync('yarn next:build')
  process.exit(0)
})()
