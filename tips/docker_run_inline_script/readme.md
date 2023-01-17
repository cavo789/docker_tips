# Run an inline script

The example comes from [https://github.com/romkatv/powerlevel10k/blob/master/README.md#try-it-in-docker](https://github.com/romkatv/powerlevel10k/blob/master/README.md#try-it-in-docker).

Using a `docker run` command, it's well possible to provide inline bash statements like below:

```bash
docker run -e TERM -e COLORTERM -e LC_ALL=C.UTF-8 -it --rm alpine sh -uec '
  apk add git zsh nano vim
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
  echo "source ~/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
  cd ~/powerlevel10k
  exec zsh'
```

The idea is to avoid to use a `Dockerfile` for very basic usage. Here, above, the `Alpine` Linux image is used and a few statements are fired to f.i. install `git` and `zsh`. Then a `git clone` is executed followed by a few more statements.

Using inline statements, we can then easily avoid using a specific image.
