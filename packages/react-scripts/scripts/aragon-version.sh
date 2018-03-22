#!/bin/sh
set -e

ARAGON_GIT="git@github.com:aragon/create-react-app.git"

pkg_version=$(cat ./package.json | grep '"version":' | sed 's/.*"\([^"]\{1,\}\)",\{0,1\}$/\1/')
prefix=$(sed 's/\(.*-aragon\.\)[0-9]\{1,\}$/\1/' <<< "$pkg_version")
number=$(sed 's/.*-aragon\.\([0-9]\{1,\}\)$/\1/' <<< "$pkg_version")
next=$(echo "$number + 1" | bc)
next_version="${prefix}${next}"

echo ""
echo "Current version:"
echo ""
echo "  $pkg_version"
echo ""
echo "New version:"
echo ""
echo "   $next_version"
echo ""

echo "Apply the new version with npm? (y/n)? "
read answer
if echo "$answer" | grep --invert-match -iq "^y"; then
  exit 0
fi

# npm version only run git commands if a .git dir is present
mkdir .git
npm version "$next_version"
rmdir .git

echo "git push && git push --tags? (y/n)? "
read answer
if echo "$answer" | grep -iq "^y"; then
  git push "$aragon_git" next-aragon
  git push "$aragon_git" --tags
fi

echo "npm publish? (y/n)? "
read answer
if echo "$answer" | grep -iq "^y"; then
  npm publish
fi
