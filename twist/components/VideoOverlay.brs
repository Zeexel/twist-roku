sub init()
  m.Video = m.top.findNode("Video")
  m.VideoDetails = m.top.findNode("VideoDetails")
  m.VideoActions = m.top.findNode("VideoActions")
  m.VideoActions.observeField("itemSelected", "selectVideoAction")

  m.ResumeButton = CreateObject("roSGNode", "ContentNode")
  m.ResumeButton.title = "Resume"
end sub

sub reinitialize()
  if m.top.needsReinitialize = true
    m.VideoActions.content.removeChild(m.ResumeButton)
    m.top.needsReinitialize = false
  end if
end sub

function selectVideoAction(selection)
  choice = m.VideoActions.content.getChild(selection.getData()).title
  if choice = "Play From Start"
    playVideo()
  else if choice = "Resume"
    resumeVideo()
  end if
end function

sub playVideo()
  VideoContent = CreateObject("roSGNode", "ContentNode")
  VideoContent.url = m.top.videoUrl
  m.Video.content = VideoContent

  m.Video.visible = true
  m.Video.setFocus(true)
  m.Video.control = "play"
end sub

sub resumeVideo()
  m.Video.visible = true
  m.Video.setFocus(true)
  m.Video.control = "resume"
end sub

sub pauseAndExitVideo()
  m.Video.control = "pause"

  m.VideoActions.content.appendChild(m.ResumeButton)

  m.VideoActions.setFocus(true)
  m.Video.visible = false
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
  print "VideoOverlay: Key pressed: "; key; " "; press
  if press = true
    if key = "back"
      if m.Video.hasFocus()
        pauseAndExitVideo()
        return true
      else
        return false
      end if
    end if
  end if
  return false
end function
