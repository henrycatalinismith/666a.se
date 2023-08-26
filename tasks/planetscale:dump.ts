require('child_process').execSync(
  `pscale database dump 666a dev --output dumps/${new Date().toISOString()}`
)
