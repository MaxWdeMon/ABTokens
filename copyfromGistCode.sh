srcgistid=df58ccaa8361b67f3f5d6c6c3d2f2b25
srcgistlink=https://gist.github.com/MaxWdeMon/$srcgistid
tgtgitname=ABTokens
tgtgitlink=https://github.com/MaxWdeMon/$tgtgitname
tgtsubfolder=./ABTokens/solidity
echo clone the gist
git clone $srcgistlink
echo clone the GitHub project
git clone $tgtgitlink
echo copy files into the target folder
mv $srcgistid/* $tgtsubfolder
echo change the working directory to the newly renamed directory
cd $tgtsubfolder
echo push to the new repository on github
git push github master

