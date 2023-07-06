set -x

cp ~/.vimrc ~/.vimrc.bak
mv ~/.vimrc
cp ~/.vim ~/.vim.bak -r
mv ~/.vim

echo "source ~/.vim/init.vim" > ~/.vimrc

mkdir ~/.vim
cp -r * ~/.vim
