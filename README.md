# Braceless [![Build Status](https://travis-ci.org/tweekmonster/braceless.vim.svg?branch=master)](https://travis-ci.org/tweekmonster/braceless.vim)

Text objects, folding, and more for Python and other indented languages.
CoffeeScript support is already baked in, but mainly as an incomplete proof of
concept.


## Usage

Use your favorite plugin plugin of choice to install
`tweekmonster/braceless.vim`, then add a line like this to your vimrc file:

```vim
autocmd FileType python BracelessEnable +indent
```

The command arguments are:

Option | Description
------ | -----------
`+indent` | Enable indent handling
`+fold` | Enable folding
`+fold-inner` | Enable folding, but fold on the inner block
`+highlight` | Enable indent guide
`+highlight-cc` | Enable indent guide, but use `colorcolumn`
`+highlight-cc2` | Enable indent guide **and** use `colorcolumn`


The default motion of interest is `P`.  It can be used for things like `vaP`,
`ciP`, `>iP`, etc.  `:h braceless` Covers the details of this plugin.


### Text objects
Braceless doesn't give you similarly indented blocks as text objects.  You get
actual code blocks using `iP` and `aP`.

![braceless-motions](https://cloud.githubusercontent.com/assets/111942/13040603/5da43e56-d37c-11e5-835a-2135d30451e2.gif)


### Object motions

Moving to recognized blocks is done with `[[` and `]]`.

![braceless-movement](https://cloud.githubusercontent.com/assets/111942/13040689/4a3bb9b0-d37d-11e5-985e-f94fe23b280c.gif)


### Folding

Get useful code folding.  Unfortunately, this can be a little slow on large
scripts.

![braceless-fold](https://cloud.githubusercontent.com/assets/111942/13040746/f5f29332-d37d-11e5-95b0-6b30a2f2adc1.gif)


### Indent guide

See what indent level you're operating on.  You can also enable `colorcolumn`
so the guide can span the height of the window.

![braceless-highlight](https://cloud.githubusercontent.com/assets/111942/13040915/11a1cf74-d380-11e5-8e56-da487f0536f8.gif)


### Somewhat intelligent auto-indent

Auto indent is based on recognized blocks instead of simply using the previous
line's indent level.  If you enter two blank lines, you'll drop back a level.
There's no GIF for this because you need a break from all the excitement.


### EasyMotion

Built-in support for EasyMotion.

![braceless-easymotion](https://cloud.githubusercontent.com/assets/111942/13041314/20748e02-d384-11e5-9387-30f5362cf3f4.gif)


### Not just Python!

Braceless can simply recognize indentation.

![braceless-others](https://cloud.githubusercontent.com/assets/111942/13052462/f87c07ce-d3cc-11e5-8024-328d58371e5d.gif)

The above GIF was using:

```vim
autocmd FileType haml,yaml,coffee BracelessEnable +indent +fold +highlight
```

You can extend Braceless to give full support to other indented languages.
See `:h braceless-custom`


## License

MIT
