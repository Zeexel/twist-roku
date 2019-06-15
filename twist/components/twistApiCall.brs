sub init()
  m.top.functionName = "getContent"
end sub

sub getContent()
  print "Querying AnimeTwist API at "; m.top.url

  url = createObject("roUrlTransfer")
  url.SetCertificatesFile("common:/certs/ca-bundle.crt")
  url.AddHeader("X-Roku-Reserved-Dev-Id", "")
  url.InitClientCertificates()

  url.setUrl(m.top.url)
  url.AddHeader("x-access-token", m.top.token)
  
  response = parseJSON(url.GetToString())

  for each item in response
    contentItem = createObject("RoSGNode", "ContentNode")

    contentItem.id = item.id  ' assume there will be an id field

    itemTitle = item[m.top.title_field]
    if type(itemTitle) = "String"
      contentItem.title = m.top.title_prefix + itemTitle
    else if type(itemTitle) = "Integer"
      contentItem.title = m.top.title_prefix + StrI(itemTitle)
    else
      contentItem.title = "Error parsing API data"
    end if

    item.contentItem = contentItem
  end for

  m.top.response = response

  print "Done with API call!"
end sub