if os.getenv('SHELL'):match('/nu') then
  vim.opt.shelltemp = false
  vim.opt.shellredir = "out+err> %s"
  vim.opt.shellcmdflag = "--stdin --no-newline -c"
  vim.opt.shellxescape = ""
  vim.opt.shellxquote = ""
  vim.opt.shellquote = ""
  vim.opt.shellpipe = '| complete | update stderr { ansi strip } | tee { get stderr | save --force --raw %s } | into record'
end
