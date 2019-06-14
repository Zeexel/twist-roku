sub init()
  m.Video = m.top.findNode("Video")
  m.VideoDetails = m.top.findNode("VideoDetails")
  m.VideoActions = m.top.findNode("VideoActions")
  m.VideoActions.observeField("itemSelected", "selectVideoAction")
end sub

function selectVideoAction(selection)
  if m.VideoActions.content.getChild(selection.getData()).title = "Play"
    playVideo()
  end if
end function

sub playVideo()
  VideoContent = CreateObject("roSGNode", "ContentNode")
  VideoContent.url = m.top.videoUrl
  m.Video.content = VideoContent

  m.VideoDetails.visible = false
  m.Video.visible = true
  m.Video.control = "play"
end sub