;(async () => {
  const response = await fetch('http://localhost:3000/chunks/oldest', {
    method: 'GET',
    headers: {
      Accept: 'application/json',
      Cookie: 'session=c000c4b2-3609-4597-ace5-c57c9c2c9564',
      'Content-Type': 'application/json',
    },
  })

  const chunks = await response.json()
  if (chunks.length === 0) {
    return
  }

  const id = chunks[0].id
  console.log(id)
  const response2 = await fetch(`http://localhost:3000/chunks/${id}/ingest`, {
    method: 'POST',
    headers: {
      Accept: 'application/json',
      Cookie: 'session=c000c4b2-3609-4597-ace5-c57c9c2c9564',
      'Content-Type': 'application/json',
    },
  })

  const outcome = await response2.json()
  console.log(outcome)
})()
