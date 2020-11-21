const express=require("express")
const morgan = require("morgan")
const app=express()
const fs=require ('fs')
const ytdl=require('ytdl-core')
const bodyParser = require("body-parser")

app.use(morgan("dev"))
app.use(bodyParser.urlencoded({extended: false}))
app.use(bodyParser.json())
app.get("/:id",(req,res,next)=>{
    id = req.params.id
    url = `https://www.youtube.com/watch?v=${id}`
    const writeableStream=fs.createWriteStream(`video.mp4`)
    writeableStream.on('finish',()=>{
        console.log(`downloaded successfully`);
        res.download(__dirname+'/video.mp4');
        // chrome.downloads.download({'url': __dirname+'/video.mp4'})
    })
    ytdl(url)
    .pipe(writeableStream)
})

module.exports=app


