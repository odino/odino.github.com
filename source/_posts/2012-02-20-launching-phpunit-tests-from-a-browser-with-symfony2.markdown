---
layout: post
title: "Launching PHPUnit tests from a browser with Symfony2"
date: 2012-02-20 13:41
comments: true
categories: [Symfony2, PHP]
---

{% render_partial series/symfony-components.markdown %}

Today we are going to launch interactive PHPUnit tests thanks to the
Symfony2 [Process](https://github.com/symfony/Process) component.
<!-- more -->

## Premise

This article will show you how to build a script to run your unit tests
from a browser and render the output to the webpage: since the aim
of this series of articles is to show you how easily you can integrate
Symfony2 code into your own projects, I will use nasty scripts to
accomplish our requirements.

## The approach

Our approach will be very basic and dummy: we are goint to execute a shell
command from PHP, write each output buffers into a file and poll the file
from the frontend to progressively read its content.

## Into the mix

To do so, let's create a JS-loving `index.php` file:

``` html The entry point of out application
<html>
  <body>
    <h1>PHPUnit web tests</h1>
    <a href="#" id="run">
      Run tests
    </a>
    <div id="output"></div>
    
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" ></script>
    <script type="text/javascript">
      $(document).ready(function(){
        var getOutput = function(){
          $.ajax({
            url: "output.php",
            success: function(data) {
              $('#output').html(data.content);

              if (data.stop != 1) {
                getOutput();
              }
            }
          });
        };
        $('#run').click(function(){
          $.ajax({
            url: "process.php",
          });
          getOutput();
        });
      });
    </script>
  </body>
</html>
```

As you see, as you click on the `Run tests` link you will fire an event that:

* makes a `GET` call to `process.php`
* makes a recursive `GET` request to `output.php`, until the output object 
does not contain the `stop` attribute

The output script is really easy:

``` php
<?php

$fileName = sys_get_temp_dir() . '/test.output.txt';
header('Content-Type: application/json');

if (file_exists($fileName)) {
  $f = file_get_contents(sys_get_temp_dir() . '/test.output.txt');

  echo json_encode(array('content' => $f));  
} else {
  $f = file_get_contents(sys_get_temp_dir() . '/test.output.txt.f');
  
  echo json_encode(array('content' => $f, 'stop' => 1));
  unlink($f);
}
```

As you see, each time we call this script, it reads the content of the `test.output.txt`
file in the temporary directory of your system: if it doesn't find it, it reads the
`test.output.txt.f` file{% fn_ref 1 %}.

## Enter Process

In our final step, let's install the Process component:

``` bash composer.json
{
    "require": {
        "php": ">=5.3.2",
        "symfony/process": "2.0.10"
    }
}

```

``` 
wget http://getcomposer.org/composer.phar

php composer.phar install
```

then we can create our `process.php` script:

``` php
<?php

require __DIR__ . '/vendor/.composer/autoload.php';

use Symfony\Component\Process\Process;

$file = sys_get_temp_dir() . '/test.output.txt';

$handle   = fopen($file, 'w+');
$process  = new Process('phpunit -c /home/foor/bar/phpunit.xml /home/foo/bar');
$process->run(function ($type, $buffer) use($handle) {
  fwrite($handle, nl2br($buffer));
});

fclose($handle); 

rename($file, $file . ".f");
```

As you see we are launching the test suite and, at each buffer, thanks to a
lambda, we write a new chunk to the file: at the end of the process the
`txt` file gets renamed, so the `output.php` script knows that it needs to
notify the frontend that he's not required to poll it anymore, adding 
the `stop` attribute to the JSON object it outputs:

``` php fragment of output.php
<?php

echo json_encode(array('content' => $f, 'stop' => 1));
```

{% img center /images/phpunit-process.png %}

## Benefits from the Process component

{% blockquote %}
  I can do that crap with shell_exec() too!
{% endblockquote %}

There are some advantages of using Process instead of writing your own command
executor: first of all, if you want to take care of the subtle differences
between the different platforms, you can use the `Process\ProcessBuilder` class;
then error handling becomes very easy since you are able to catch all the buffers:

``` php
<?php
...

$process->run(function ($type, $buffer) {
    if ('err' === $type) {
        echo 'Something nasty happened';
			  syslog(LOG_ERR, $buffer);
    } else {
        echo $buffer;
    }
});
```

{% footnotes %}
  {% fn Flaw here: no error handling when the .f file is not found %}
{% endfootnotes %}
