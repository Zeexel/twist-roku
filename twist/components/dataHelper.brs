sub accumulateContentNodes(content, apiResponse)
  for each item in apiResponse
    content.appendChild(item.contentItem)
  end for
end sub

function findItemFromLabelList(labelList, labelIndex, arrayList) as Object
  contentId = labelList.content.getChild(labelIndex).id.toInt()  ' contentNodes convert ids to strings
  for each item in arrayList
    if item.id = contentId
      return item
    end if
  end for
  ' error if item not found
end function