set -x

rm -rf ~/.vimrc.bak ~/.vim.bak
mv ~/.vimrc ~/.vimrc.bak
mv ~/.vim ~/.vim.bak

echo "source ~/.vim/init.vim" > ~/.vimrc

mkdir ~/.vim
cp -r * ~/.vim
