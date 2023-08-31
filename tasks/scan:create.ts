;(async () => {
  const response = await fetch('http://localhost:3000/scans', {
    method: 'POST',
    headers: {
      Accept: 'application/json',
      Cookie: 'session=c000c4b2-3609-4597-ace5-c57c9c2c9564',
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      county: process.argv[2],
    }),
  })
  const body = await response.json()
  console.log(22)
  console.log(body)
})()
