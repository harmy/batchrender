fn getFilesRecursive root pattern = (
    dir_array = GetDirectories (root+"*")
    for d in dir_array do
      join dir_array (GetDirectories (d+"\\*"))
    my_files = #()
    for f in dir_array do
      join my_files (getFiles (f + pattern))
    my_files
)


fn RenderObj fileName prefix = (
   prefix = (if prefix == undefined then "" else prefix)
    if  not doesFileExist(fileName) do(
        messageBox("File not exists: " + fileName)
        return false
    )
   renderDir = getFilenamePath(fileName) + getFilenameFile(fileName)
    if not doesFileExist(renderDir) do(
        if not makeDir(renderDir) do(
            messageBox("Could not create directory: " + renderDir)
            return false
        )
    )
    if not loadMaxFile(fileName) do(
        messageBox("Could not open max file: " + fileName)
        return false
    )
    dir = #("00","01","02","03","04","05","06","07")
    setProperty autobackup "enabled" false
    progressStart "start rendering"
    try(
        for d = 1 to 8 do(
            td = d * 12
            progressUpdate td
            outfilename = (renderDir + "\\" + prefix + dir[d] + ".tga")
            tempvfb = render outputfile:outfilename camera:$Camera01 fromframe:rendStart toframe:rendEnd nthframe:rendNThFrame outputwidth:renderwidth outputheight:renderheight renderer:#production
            undisplay tempvfb
            animate off(
                    try(rotate $ตฦนโ 45 [0,0,1])catch("No light!")
                )
        )
    )
    catch(messageBox(getCurrentException()))
    progressEnd()
    setProperty autobackup "enabled" true
)

fn main = (
    path = getSavePath()
    if path != undefined then(
        maxFiles = getFilesRecursive path "*.max"
        for maxFile in maxFiles do(
            RenderObj maxFile ""
        )
    )
)

main()
quitMax #noPrompt