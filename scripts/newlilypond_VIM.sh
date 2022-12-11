#!/bin/bash

# $1 : name (words seperated with dashes "-")
# $2 : key  (the key with M for major or m for minor, i.e. aM for a major)
# $3 : time signature

if [[ -z "$1" ]]
then
        echo "Usage: $(basename $0) NAME [KEY] [TIME]"
        echo 
        echo "NAME - seperate words with dashes (-); prefix categorie seperated by underscore (_)"
        echo 'KEY  - set the key signature (default: C major, see in `global.ly` file)'
        echo 'TIME - set time signature (default: 4/4, see in `global.ly` file)'
        echo
        echo "Examples ..."
        echo "NAME : 'ARR-000_the-title-of-the-song' or simply 'the-title-of-the-song'"
        echo "       use underscore (_) to give 'Untitled'"
        echo "KEY  : append M or m to denote major or minor."
        echo "          aM gives a major"
        echo "          besm gives b flat minor"
        echo "          gisM gives g sharp major"
        echo "TIME : 4/4 or 3/4 or 12/8 ..."
        exit 1
fi

VERSION=$(lilypond --version | head -n 1 | awk '{ print $3 }')
PROJECT="$1"
GLOBALFILE="global.ly"

# set the name of the project
if [[ "$1" = "_" ]]
then
        NAME="Untitled"
        MAINFILE="Untitled.ly"
else
        NAME="${1#*_}"
        MAINFILE="${NAME}.ly"
fi

# make sure the project does not exist
[[ -d "$PROJECT" ]] && { echo "'$PROJECT' already exists. Aborting."; exit 1; }

# put all the files in place
mkdir "$PROJECT"
cd "$PROJECT"
cp "$HOME/.config/nvim/skeletons/Lilypond/newfile"/* .

# Put lilypond's version in every file
sed -i "s/\(.version \).*/\1\"$VERSION\"/" *.ly

# set the title
TITLE="${NAME//-/ }"
sed -i "s/TITLE/$TITLE/" "main.ly"
mv "main.ly" "$MAINFILE"


# set the key signature
if [[ -n "$2" ]]
then
        key=${2:0:-1}
        scale=${2: -1}
        if [[ $scale == 'm' ]]
        then
                scale='minor'
        else
                scale='major'
        fi
        
        sed -i "s/c \(.\)major/$key \1$scale/" "$GLOBALFILE"
fi


# set time signature
if [[ -n "$3" ]]
then
        sed -i "s#4/4#$3#" "$GLOBALFILE"
fi
