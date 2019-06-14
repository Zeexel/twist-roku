sub init()
  ' AnimeSelector nodes
  m.MenuOptions = m.top.findNode("MenuOptions")
  m.AnimeList = m.top.findNode("AnimeList")
  m.EpisodeList = m.top.findNode("EpisodeList")
  m.currentList = "MenuOptions"

  ' VideoOverlay nodes
  m.VideoOverlay = m.top.findNode("VideoOverlay")
  m.VideoActions = m.top.findNode("VideoActions")

  m.MenuOptions.observeField("itemSelected", "selectMenuOption")
  m.MenuOptions.setFocus(true)
end sub

function selectMenuOption(selection)
  if m.MenuOptions.content.getChild(selection.getData()).title = "Browse"
    m.MenuOptions.setFocus(false)
    populateAnimeList()
  end if
end function

sub populateAnimeList()
  print "Trying to populate anime list!"

  m.getAnimeList = createObject("roSGNode", "twistApiCall")
  m.getAnimeList.setField("url", "https://twist.moe/api/anime")
  m.getAnimeList.setField("token", "1rj2vRtegS8Y60B3w3qNZm5T2Q0TN2NR")
  m.getAnimeList.setField("title_field", "title")
  m.getAnimeList.observeField("content", "showAnimeList")
  m.getAnimeList.control = "RUN"
end sub

sub showAnimeList()
  m.AnimeList.content = m.getAnimeList.content
  m.AnimeList.visible = true
  focusAnimeList()
  m.AnimeList.observeField("itemSelected", "selectAnime")
end sub

function selectAnime(selection)
  print "Trying to populate episode list for selected anime!"

  currentAnimeSlug = m.AnimeList.content.getChild(selection.getData()).twist_data.slug.slug

  m.getAnimeEpisodes = createObject("roSGNode", "twistApiCall")
  m.getAnimeEpisodes.setField("url", "https://twist.moe/api/anime/" + currentAnimeSlug + "/sources")
  m.getAnimeEpisodes.setField("token", "1rj2vRtegS8Y60B3w3qNZm5T2Q0TN2NR")
  m.getAnimeEpisodes.setField("title_field", "number")
  m.getAnimeEpisodes.setField("title_prefix", "Episode ")
  m.getAnimeEpisodes.observeField("content", "showEpisodeList")
  m.getAnimeEpisodes.control = "RUN"
end function

sub showEpisodeList()
  m.EpisodeList.content = m.getAnimeEpisodes.content
  m.EpisodeList.visible = true
  focusEpisodeList()
  m.EpisodeList.observeField("itemSelected", "selectEpisode")
end sub

function selectEpisode(selection)
  source_encrypted = m.EpisodeList.content.getChild(selection.getData()).twist_data.source
  source = "https://twist.moe" + decryptSource(source_encrypted)

  m.VideoOverlay.videoUrl = source
  m.VideoOverlay.visible = true
  m.VideoActions.setFocus(true)
end function

sub focusMenuOptions()
  m.currentList = "MenuOptions"
  m.MenuOptions.setFocus(true)
end sub

sub focusAnimeList()
  m.currentList = "AnimeList"
  m.AnimeList.setFocus(true)
end sub

sub focusEpisodeList()
  m.currentList = "EpisodeList"
  m.EpisodeList.setFocus(true)
end sub

sub scrollRight() as Boolean
  if m.currentList = "MenuOptions"
    if m.AnimeList.visible = false
      return false
    end if
    focusAnimeList()
    return true
  end if
  if m.currentList = "AnimeList"
    if m.EpisodeList.visible = false
      return false
    end if
    focusEpisodeList()
    return true
  end if
  return false
end sub

sub scrollLeft() as Boolean
  if m.currentList = "AnimeList"
    focusMenuOptions()
    return true
  end if
  if m.currentList = "EpisodeList"
    focusAnimeList()
    return true
  end if
  return false
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
  print "Key pressed: "; key; " "; press
  if press = true
    if key = "left"
      scrollLeft()
      return true
    else if key = "right"
      scrollRight()
      return true
    end if
  end if
  return false
end function
