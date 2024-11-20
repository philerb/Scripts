##--VARIABLES--
#Number of days that files are kept, after which they are deleted
$deleteFilesOlderThanXDays = 7
#Where are the files to be examined and deleted
$rootPathToFiles = "G:\"
#These files/folders will not be deleted... comma separated, for example:
#$excludedPaths = @("G:\ameliabackup\splunkdb\","G:\otisbackup\netflow\","G:\netscreen\")
$excludedPaths = @("")
##--END VARIABLES--

##--EXAMINE FILES AND DELETE AS NECESSARY--
$filesToExamine = Get-ChildItem $rootPathToFiles

foreach($file in $filesToExamine)
{
	$fileAgeInDays = ((Get-Date) - $file.CreationTime).Days
	if ($fileAgeInDays -gt $deleteFilesOlderThanXDays)
	{
		Remove-Item $file.FullName -Exclude $excludedPaths -Recurse -Force -Confirm:$false
	}
}