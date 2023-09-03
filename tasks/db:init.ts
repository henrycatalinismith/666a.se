require('dotenv').config()
;(async () => {
  require('child_process').execSync('yarn county:import')
  require('child_process').execSync('yarn municipality:import')
  require('child_process').execSync('yarn type:import')
})()
