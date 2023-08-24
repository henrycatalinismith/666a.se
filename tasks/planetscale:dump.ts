require('child_process').execSync(
  `pscale database dump ddosdotnews dev --output dumps/${new Date().toISOString()}`
)
