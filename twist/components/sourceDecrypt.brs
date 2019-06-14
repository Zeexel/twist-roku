function decryptSource(source as String)
  passphrase = CreateObject("roByteArray")
  passphrase.fromAsciiString("k8B$B@0L8D$tDYHGmRg98sQ7!%GOEGOX27T")
  bytes = CreateObject("roByteArray")
  bytes.fromBase64String(source)

  salt = sliceBytes(bytes, 8, 16)
  encrypted = sliceBytes(bytes, 16, bytes.count())

  passPlusSalt = concatBytes(passphrase, salt)
  
  md5Digest = CreateObject("roEVPDigest")
  md5Digest.Setup("md5")

  key = md5Digest.Process(passPlusSalt)

  bytes.FromHexString(key)

  finalKey = copyBytes(bytes)

  while finalKey.count() < 48
    key = md5Digest.Process(concatBytes(bytes, passPlusSalt))
    bytes.FromHexString(key)
    finalKey = concatBytes(finalKey, bytes)
  end while

  aesKey = sliceBytes(finalKey, 0, 32)
  aesIv = sliceBytes(finalKey, 32, 48)

  aesDigest = CreateObject("roEVPCipher")
  aesDigest.Setup(false, "aes-256-cbc", aesKey.toHexString(), aesIv.toHexString(), 1)

  result = aesDigest.process(encrypted)
  return result.toAsciiString()
end function

' function printBytes(bytes as object, prefix as String)
'   print prefix, ": ", bytes.toHexString()
' end function

function sliceBytes(bytes as object, s as Integer, e as Integer) as object
  newBytes = CreateObject("roByteArray")
  for i = s to e-1
    newBytes.push(bytes[i])
  end for
  return newBytes
end function

function concatBytes(bytes1 as object, bytes2 as object) as object
  newBytes = CreateObject("roByteArray")
  for i = 0 to bytes1.count()-1
    newBytes.push(bytes1[i])
  end for
  for i = 0 to bytes2.count()-1
    newBytes.push(bytes2[i])
  end for
  return newBytes
end function

function copyBytes(bytes as object) as object
  newBytes = CreateObject("roByteArray")
  for i = 0 to bytes.count()-1
    newBytes.push(bytes[i])
  end for
  return newBytes
end function
