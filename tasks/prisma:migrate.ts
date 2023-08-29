require('dotenv').config()
;(async () => {
  require('child_process').execSync(`yarn prisma migrate dev`)
})()
