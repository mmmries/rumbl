import Player from "./player"

let Video = {
  init(socket, element){ if(!element) { return }
    let msgContainer = document.getElementById("msg-container")
    let msgInput = document.getElementById("msg-input")
    let postButton = document.getElementById("msg-submit")
    let videoId = element.getAttribute("data-id")
    let playerId = element.getAttribute("data-player-id")

    socket.connect()
    let vidChannel = socket.channel("videos:" + videoId)
    // TODO join the video channel
}
export default Video
