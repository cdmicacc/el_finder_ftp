## el_finder

* http://elrte.org/redmine/projects/elfinder

## Description:

Based on a Ruby library to provide server side functionality for elFinder, this version provides a Rails backend for
elFinder that uses an FTP server as its file storage, rather than the local filesystem. 

elFinder is an open-source file manager for web, written in JavaScript using jQuery UI.

## 2.x API

This version provides a partial implementation of the 2.x API (the portions that can be used with FTP).

Operations such as archive, copy, duplicate, etc are not possible using FTP.  Needless to say, thumbnails are also not
supported.

## Requirements:

Net::FTP is used to communicate with the FTP server.

## Install:

* Install elFinder (http://elrte.org/redmine/projects/elfinder/wiki/Install_EN)
* Do whatever is necessary for your Ruby framework to tie it together.

### Rails 3

* Add `gem 'el_finder_ftp'` to Gemfile
* % bundle install
* Switch to using jQuery instead of Prototype
* Add the following action to a controller of your choosing.

* Use ElFinderFtp::Action and el_finder_ftp, which handles most of the boilerplate for an ElFinderFtp action:

```ruby
  require 'el_finder_ftp/action'

  class MyController < ApplicationController
    include ElFinderFtp::Action

    el_finder_ftp(:action_name) do
      {
        :server => { host: 'my.ftp.com', username: 'username', password: 'password' },
        :url: "/ftp",
        :perms => {
           /^(Welcome|README)$/ => {:read => true, :write => false, :rm => false},
           '.' => {:read => true, :write => false, :rm => false}, # '.' is the proper way to specify the home/root directory.
           /^test$/ => {:read => true, :write => true, :rm => false},
           'logo.png' => {:read => true},
           /\.png$/ => {:read => false} # This will cause 'logo.png' to be unreadable.  
                                        # Permissions err on the safe side. Once false, always false.
        },
      }
    end
  end
```

* Add the appropriate route to config/routes.rb such as:

```ruby
  match 'ftp' => 'my_controller#action_name'
```

* Add the following to your layout. The paths may be different depending 
on where you installed the various js/css files.

```erb
  <%= stylesheet_link_tag 'jquery-ui/base/jquery.ui.all', 'elfinder' %>
  <%= javascript_include_tag :defaults, 'elfinder/elfinder.min' %>
```

* Add the following to the view that will display elFinder:

```erb
  <%= javascript_tag do %>
    $().ready(function() { 
      $('#elfinder').elfinder({ 
        url: '/ftp',
        lang: 'en'
      })
    })
  <% end %>
  <div id='elfinder'></div>
```

* That's it.

## License:

(The MIT License)

Copyright (c) 2010 Philip Hallstrom

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
