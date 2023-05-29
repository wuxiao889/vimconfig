set -x

mv ~/.vimrc ~/.vimrc.bak
if [ -d ~/.vim ]; then
  mv ~/.vim ~/.vim.bak
fi

echo "source ~/.vim/init.vim" > ~/.vimrc

mkdir ~/.vim
cp -r * ~/.vim
