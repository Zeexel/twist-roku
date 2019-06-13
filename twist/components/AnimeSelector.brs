sub init()
  m.AnimeList = m.top.findNode("AnimeList")
  m.EpisodeList = m.top.findNode("EpisodeList")
  m.animeListPopulated = false

  populateAnimeList()
end sub

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
  m.AnimeList.visible = "true"
  m.animeListPopulated = true
  m.AnimeList.setFocus(true)
end sub

sub selectAnime()
  print "Trying to populate episode list for current anime!"

  currentAnimeSlug = m.AnimeList.content.getChild(m.AnimeList.itemFocused).twist_data.slug.slug

  m.getAnimeEpisodes = createObject("roSGNode", "twistApiCall")
  m.getAnimeEpisodes.setField("url", "https://twist.moe/api/anime/" + currentAnimeSlug + "/sources")
  m.getAnimeEpisodes.setField("token", "1rj2vRtegS8Y60B3w3qNZm5T2Q0TN2NR")
  m.getAnimeEpisodes.setField("title_field", "number")
  m.getAnimeEpisodes.setField("title_prefix", "Episode ")
  m.getAnimeEpisodes.observeField("content", "showEpisodeList")
  m.getAnimeEpisodes.control = "RUN"
end sub

sub showEpisodeList()
  m.EpisodeList.content = m.getAnimeEpisodes.content
  m.EpisodeList.visible = "true"
  m.EpisodeList.setFocus(true)
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
  print "Key pressed: "; key; " "; press
  if m.animeListPopulated = false
    return false
  end if
  if press = true
    if m.AnimeList.hasFocus() = true
      if key = "OK"
        selectAnime()
        return true
      end if
    end if
  end if
  return false
end function


' note: hasFocus() to check focus