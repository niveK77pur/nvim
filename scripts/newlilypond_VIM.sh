#!/bin/bash

# $1 : name (words seperated with dashes "-")
# $2 : key  (the key with M for major or m for minor, i.e. aM for a major)
# $3 : time signature

if [[ -z "$1" ]]
then
        echo "Usage: $(basename "$0") NAME [KEY] [TIME]"
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

VERSION=$(lilypond --version | grep -oP 'LilyPond \K[0-9.]+')
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
[[ -n "$(find "$PROJECT" -name "*.ly")" ]] && { echo "'$PROJECT' already exists. Aborting."; exit 1; }

if type gh;
then
    # use github-cli if available
    GH_ORGANISATION=VinLudens
    gh repo create --public --template "$GH_ORGANISATION/lilypond-workflow-template" "$GH_ORGANISATION/$PROJECT"
    gh repo clone "$GH_ORGANISATION/$PROJECT"
    gh variable --repo "$GH_ORGANISATION/$PROJECT" set LILYPOND_VERSION -b "$VERSION" && (
        cd "$PROJECT" \
            && sed -i '/LILYPOND_VERSION/s/\[ \]/[x]/' README.md \
            && git add README.md \
            && git commit -m "set LILYPOND_VERSION" \
    )
    gh variable --repo "$GH_ORGANISATION/$PROJECT" set MAIN_FILE -b "$NAME" && (
        cd "$PROJECT" \
            && sed -i '/MAIN_FILE/s/\[ \]/[x]/' README.md \
            && git add README.md \
            && git commit -m "set MAIN_FILE" \
            && git push
    )
    # new branch to avoid accidentally pushing to 'main'
    ( cd "$PROJECT" && git checkout -b dev )
else
    # simply make a directory
    mkdir -p "$PROJECT"
fi

# put all the files in place
cd "$PROJECT" || exit 2

mkdir openlilylib &&
    (
        cd openlilylib \
            && git submodule add 'https://github.com/openlilylib/oll-core.git' \
            && git submodule add 'https://github.com/openlilylib/edition-engraver.git'
    ) \
    && sed -i '/openlilylib/s/\[ \]/[x]/' README.md \
    && git add README.md \
    && git commit -m "Add edition engraver"
cp "$HOME/.config/nvim/skeletons/Lilypond/newfile"/* .

# set nvim-lilypond-suite main file
mv {,.}nvimrc.lua
sed -i "s/MAINFILE/$MAINFILE/" .nvimrc.lua

# Put lilypond's version in every file
sed -i "s/\(.version \).*/\1\"$VERSION\"/" -- *.ly

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
