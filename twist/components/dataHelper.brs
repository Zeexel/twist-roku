sub accumulateContentNodes(myList, apiResponse)
  needToReplaceContent = false
  if myList.content.getChildCount() = 0
    myContent = myList.content
  else
    myContent = createEmptyContent()
    needToReplaceContent = true
  end if

  for each item in apiResponse
    myContent.appendChild(item.contentItem)
  end for

  if needToReplaceContent = true
    myList.content = myContent
  end if
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

' TODO: make splitString function that splits on - . ; etc

function arrayInArray(arrayOne, arrayTwo) as boolean
  if arrayTwo.count() = 0 then return false
  for each toMatch in arrayOne
    toMatchLower = lCase(toMatch)
    toMatchLen = len(toMatch)
    foundMatch = false
    for each toContain in arrayTwo
      if toMatchLen <= len(toContain) and toMatchLower = left(lCase(toContain), toMatchLen)
        foundMatch = true
        exit for
      end if
    end for
    if foundMatch = false
      return false
    end if
  end for
  return true
end function

function animeItemMatches(search as String, animeItem as Object) as boolean
  searchArray = search.split(" ")
  titleOne = animeItem.title.split(" ")
  if animeItem.alt_title = invalid
    titleTwo = []
  else
    titleTwo = animeItem.alt_title.split(" ")
  end if
  if arrayInArray(searchArray, titleOne) or arrayInArray(searchArray, titleTwo)
    return true
  end if
  return false
end function

sub searchAndFillContent(search as String, prevSearch as String, myArray as Object, myList as Object)
  newContent = createEmptyContent()
  for each item in myArray
    if animeItemMatches(search, item)
      newContent.appendChild(item.contentItem)
    end if
  end for
  myList.content = newContent
end sub

function createEmptyContent() as Object
  return createObject("RoSGNode", "ContentNode")
end function
