sub init()
  ' AnimeSelector nodes
  m.MenuOptions = m.top.findNode("MenuOptions")
  m.AnimeList = m.top.findNode("AnimeList")
  m.AnimeList.observeField("itemSelected", "selectAnime")
  m.EpisodeList = m.top.findNode("EpisodeList")
  m.EpisodeList.observeField("itemSelected", "selectEpisode")
  m.ExitWarning = m.top.findNode("ExitWarning")
  m.ExitWarning.buttons = ["OK", "Cancel"]
  m.ExitWarning.observeField("buttonSelected", "maybeExit")

  ' VideoOverlay nodes
  m.VideoOverlay = m.top.findNode("VideoOverlay")
  m.VideoActions = m.top.findNode("VideoActions")

  m.currentList = "MenuOptions"
  m.AnimeListPopulated = false
  m.AnimeListWaiting = false

  fetchAnimeList()

  ' note: m.AnimeArray and m.EpisodeArray are set upon AnimeList and EpisodeList loading

  m.MenuOptions.observeField("itemSelected", "selectMenuOption")
  m.MenuOptions.setFocus(true)
end sub

sub maybeExit(selection)
  if m.ExitWarning.buttons[selection.getData()] = "OK"
    m.top.exit = true
  else
    m.ExitWarning.visible = false
    if m.currentList = "MenuOptions"
      m.MenuOptions.setFocus(true)
    else if m.currentList = "AnimeList"
      m.AnimeList.setFocus(true)
    else if m.currentList = "EpisodeList"
      m.EpisodeList.setFocus(true)
    end if
  end if
end sub

sub selectMenuOption(selection)
  if m.MenuOptions.content.getChild(selection.getData()).title = "Browse"
    m.MenuOptions.setFocus(false)
    if m.AnimeListPopulated = false
      m.AnimeListWaiting = true
    else
      showAnimeList()
    end if
  end if
end sub

sub fetchAnimeList()
  print "Trying to populate anime list!"

  m.getAnimeList = createObject("roSGNode", "twistApiCall")
  m.getAnimeList.setField("url", "https://twist.moe/api/anime")
  m.getAnimeList.setField("token", "1rj2vRtegS8Y60B3w3qNZm5T2Q0TN2NR")
  m.getAnimeList.setField("title_field", "title")
  m.getAnimeList.observeField("response", "populateAnimeListContent")
  m.getAnimeList.control = "RUN"
end sub

sub populateAnimeListContent()
  m.AnimeArray = m.getAnimeList.response
  accumulateContentNodes(m.AnimeList.content, m.AnimeArray)
  m.AnimeListPopulated = true

  if m.AnimeListWaiting = true
    showAnimeList()
  end if
end sub

sub selectAnime(selection)
  print "Trying to populate episode list for selected anime!"

  currentAnimeSlug = findItemFromLabelList(m.AnimeList, selection.getData(), m.AnimeArray).slug.slug

  m.getAnimeEpisodes = createObject("roSGNode", "twistApiCall")
  m.getAnimeEpisodes.setField("url", "https://twist.moe/api/anime/" + currentAnimeSlug + "/sources")
  m.getAnimeEpisodes.setField("token", "1rj2vRtegS8Y60B3w3qNZm5T2Q0TN2NR")
  m.getAnimeEpisodes.setField("title_field", "number")
  m.getAnimeEpisodes.setField("title_prefix", "Episode ")
  m.getAnimeEpisodes.observeField("response", "showEpisodeList")
  m.getAnimeEpisodes.control = "RUN"
end sub

sub showEpisodeList()
  m.EpisodeArray = m.getAnimeEpisodes.response
  accumulateContentNodes(m.EpisodeList.content, m.EpisodeArray)
  m.EpisodeList.visible = true
  focusEpisodeList()
end sub

sub selectEpisode(selection)
  source_encrypted = findItemFromLabelList(m.EpisodeList, selection.getData(), m.EpisodeArray).source
  source = "https://twist.moe" + decryptSource(source_encrypted)

  m.VideoOverlay.videoUrl = source
  m.VideoOverlay.needsReinitialize = true
  m.VideoOverlay.visible = true
  m.VideoActions.setFocus(true)
end sub

function focusOccupied() as Boolean
  if m.ExitWarning.visible = true
    return true
  end if
  return false
end function

sub focusMenuOptions()
  m.currentList = "MenuOptions"
  if focusOccupied() = false
    m.MenuOptions.setFocus(true)
  end if
end sub

sub showAnimeList()
  m.AnimeList.visible = true
  focusAnimeList()
end sub

sub focusAnimeList()
  m.currentList = "AnimeList"
  if focusOccupied() = false
    m.AnimeList.setFocus(true)
  end if
end sub

sub focusEpisodeList()
  m.currentList = "EpisodeList"
  if focusOccupied() = false
    m.EpisodeList.setFocus(true)
  end if
end sub

function scrollRight() as Boolean
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
end function

function scrollLeft() as Boolean
  if m.currentList = "AnimeList"
    focusMenuOptions()
    return true
  end if
  if m.currentList = "EpisodeList"
    focusAnimeList()
    return true
  end if
  return false
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
  print "AnimeSelector: Key pressed: "; key; " "; press
  if press = true
    if key = "left"
      scrollLeft()
      return true
    else if key = "right"
      scrollRight()
      return true
    end if
    if key = "back"
      if m.VideoOverlay.visible = true
        m.VideoOverlay.visible = false
        m.EpisodeList.setFocus(true)
        return true
      else
        m.ExitWarning.visible = true
        m.ExitWarning.focusButton = 0  ' focus OK button
        m.ExitWarning.setFocus(true)
        return true
      end if
    end if
  end if
  return false
end function
