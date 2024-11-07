import express from "express"

const app = express()

app.set("port", process.env.PORT || 3000)
const PORT = app.get("port")

app.get("/", (req, res) => {
    res.send("Hello world!")
})

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`)
})
