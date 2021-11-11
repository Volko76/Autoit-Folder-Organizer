#include <Array.au3>

Global $searcher, $file, $folder, $filePath, $destFolder
$folder = @ScriptDir
HotKeySet("p", "AddDirectory")


If FileExists("settings.ini") Then
	MsgBox(0, "", "Il y a déja des parametres enregistrés")
Else
	AddDirectory()
EndIf

$ini = IniReadSectionNames("settings.ini")
_ArrayDelete($ini, 0)


While 1
	Sleep(2000)
	Clean()
WEnd

Func Clean()
	$ini = IniReadSectionNames("settings.ini")
	_ArrayDelete($ini, 0)
	For $folder In $ini
		MsgBox(0,"",$folder)
		FileChangeDir($folder)
		$searcher = FileFindFirstFile("*.*")
		; If @error Then ExitLoop
		If $searcher = -1 Then MsgBox(0,"Error","Aucun fichier trouvé")
		ShellExecute($folder)
		For $i=0 To DirGetSize($folder)
			$file = FileFindNextFile($searcher)
			$filePath = $folder & "\" & $file
			$destFolder = $folder & "\" & _GetFileNameExt($file)

			If @error Then ExitLoop
			; MsgBox(0,"",$file)

			If FileExists($destFolder) Then
				; MsgBox(0, "", "An error occurred. The directory already exists.")
				; MsgBox(0,"","ici")
				ExitLoop
			Else
				DirCreate($destFolder)
			EndIf

			FileCopy($filePath, $destFolder & "\" & $file)
			FileDelete($filePath)
		Next

	Next

EndFunc
Func AddDirectory()
	IniWriteSection("settings.ini", InputBox("Add Directory", "Add a folder to clean"), "")
	$ini = IniReadSectionNames("settings.ini")
EndFunc
Func _GetFileNameExExt($gFileName) ; Requires A Full Path Or FileName. [C:\Program Files\AutoIt3.chm Or AutoIt3.chm]
    #cs
        Description: Removes The FileName Extension.
        Returns: FileName Without The Extension.
    #ce
    Local $gTempString = StringRight($gFileName, 1)
    While 1
        If $gTempString = "." Then
            $gFileName = StringTrimRight($gFileName, 1)
            Return $gFileName
        Else
            $gFileName = StringTrimRight($gFileName, 1)
            $gTempString = StringRight($gFileName, 1)
        EndIf
    WEnd
EndFunc   ;==>_GetFileNameExExt

Func _GetFileNameExt($fileName) ; Requires A Full Path Or FileName. [C:\Program Files\AutoIt3.chm Or AutoIt3.chm]
    Return StringReplace(StringRight($fileName,4),".","")
EndFunc   ;==>_GetFileNameExExt