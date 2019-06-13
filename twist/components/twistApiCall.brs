sub init()
  m.top.functionName = "getContent"
end sub

sub getContent()
  print "Querying AnimeTwist API at "; m.top.url
  content = createObject("roSGNode", "ContentNode")

  url = createObject("roUrlTransfer")
  url.SetCertificatesFile("common:/certs/ca-bundle.crt")
  url.AddHeader("X-Roku-Reserved-Dev-Id", "")
  url.InitClientCertificates()

  url.setUrl(m.top.url)
  url.AddHeader("x-access-token", m.top.token)
  
  response = parseJSON(url.GetToString())

  for each item in response
    listitem = content.createChild("ContentNode")
    listitem.addFields({ "twist_data" : item })

    itemTitle = item[m.top.title_field]
    if type(itemTitle) = "String"
      listitem.title = m.top.title_prefix + itemTitle
    else if type(itemTitle) = "Integer"
      listitem.title = m.top.title_prefix + StrI(itemTitle)
    end if
  end for

  m.top.content = content

  print "Done with API call!"
end sub