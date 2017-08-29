Rubocop.tmbundle
================

Rubocop (http://batsov.com/rubocop/) Textmate 2 Bundle

(c) 2014 Michał Kalbarczyk fazibear@gmail.com

Supports
--------
* severities
* different icons for severities

Install
-------

First, make sure `$TM_RUBY` is set to your current ruby directory.

_**Important:** If you're using `rvm`, see "Installation notes for `rvm` users" below._

Once `$TM_RUBY` has been properly set, finish the installation:

    gem install rubocop
    mkdir -p ~/Library/Application\ Support/TextMate/Bundles
    cd ~/Library/Application\ Support/TextMate/Bundles
    git clone https://github.com/fazibear/Rubocop.tmbundle.git

Installation notes for `rvm` users
----------------------------------

You may need to [generate a wrapper](https://rvm.io/integration/textmate) to ensure that TextMate uses the correct `ruby` binary when executing the bundle (in this example we'll use ruby 2.4.1; be sure to substitute if you're using something different):

1. Switch to your preferred Ruby: `rvm use 2.4.1`
2. `gem install rubocop`
3. `rvm wrapper 2.4.1 textmate`
4. Assign `TM_RUBY` to the full value of `which textmate_ruby` (something like `/Users/you/.rvm/bin/textmate_ruby`)
5. Continue the installation per the instructions above.

Screenshot
----------
![screenshot](Support/screenshot.png?raw=true "screenshot")

