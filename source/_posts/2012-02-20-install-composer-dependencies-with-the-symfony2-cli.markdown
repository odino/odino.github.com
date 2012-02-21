---
published: true
layout: post
title: "Create a Composer command line installer with the Symfony2 CLI"
date: 2012-02-21 10:51
comments: true
categories: [Symfony2, PHP, CLI]
---

{% render_partial series/symfony-components.markdown %}

Today we are going to see the power of Symfony2's
[Console component](https://github.com/symfony/console),
which lets us build powerful interactive command line applications
in pure PHP.
<!-- more -->

{% img right /images/installer.png %}

In this episode we are going to create an interactive shell
able to generate new composer-based projects: we will have a
command to define which dependencies we need and another one
to:

* create the installation directory
* download composer
* generate  a `composer.json` according to the required dependencies
* run a `php composer.phar install` to install everything

The approach we're going to use will be very rough and incomplete: no
error handling, no decent abstraction, but is intended to give you a
clue about the potentiality of the CLI tool and to show you how you can
easily create PHP command line applications without the need to
write too much good code.

## Approach and installation

The Symfony2 Console lets use extend the `Console\Command\Command` class to
implement your own commands, so we will add a couple custom commands, one to
**register dependencies** and one to **execute the installation**.

First of all, let create our own `composer.json`, to download the Console
and [Process](/launching-phpunit-tests-from-a-browser-with-symfony2/){% fn_ref 1 %}
components:

``` bash composer.json
{
    "require": {
        "php": ">=5.3.2",
        "symfony/console": "2.0.10",
        "symfony/process": "2.0.10"
    }
}
```

then install everything and create your `installer.php` script which
serves as the entry point for the console:

``` bash installing the dependencies
wget http://getcomposer.org/composer.phar

php composer.phar install
```

``` php installer.php
<?php

require 'vendor/.composer/autoload.php';
require 'Command/DependencyContainer.php';
require 'Command/Install.php';

use Symfony\Component\Console\Shell;
use Symfony\Component\Console\Application;

$application            = new Application('Installer', '1.0.0-alpha');
$dependencyContainer    = new DependencyContainer();
$application->add($dependencyContainer);
$application->add(new Install($dependencyContainer));
$shell = new Shell($application);

$shell->run();
```

In the `installer.php` we are instantiating a new interactive shell
application, adding to it 2 new commands and then we run it: don't try it now,
as the added command classes don't exist yet.

## A container for the dependencies

The first custom command we are going to add is a dependency container, which is
a convenient class storing the dependencies, like `symfony/yaml`, in an
attribute, and exposes a `getDependencies()` method that will be used by the
installer command to retrieve the dependencies to install.

``` php Command/DependencyContainer.php
<?php

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class DependencyContainer extends Command
{
    protected $dependencies = array();
    
    public function getDependencies()
    {
        return $this->dependencies;
    }
    
    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $dialog  = $this->getHelperSet()->get('dialog');
        $package = $dialog->ask($output, '<question>Please enter the name of the package you want to install</question>');
        
        if ($package) {
            $this->dependencies[] = '"' . $package . '": "master"';
            $output->writeln(sprintf('<info>Package %s was succesfully registered</info>', $package));
        } else {
            $output->writeln('<error>You must insert a package name</error>');   
        }
    }
    
    protected function configure()
    {
        $this
            ->setName('add-dependency');
        ;
    }
}
```

As you see, the command will be called when doing a `add-dependency` from the console
and will ask the user to prompt the dependency we wants to add; a basic check is done:

``` php Checking for non-empty input
<?php
...

if ($package) {
    $this->dependencies[] = '"' . $package . '": "master"';
    $output->writeln(sprintf('<info>Package %s was succesfully registered</info>', $package));
} else {
    $output->writeln('<error>You must insert a package name</error>');   
}
```

Note that, for being *quick'n'dirty*, we store the dependencies in the composer way:

``` bash
"dependencyvendor/dependencyname": "dependencyversion"
```

and we use `master` as the only version available{% fn_ref 2 %}.

This is it: now we only need to create the command to install everything.

## The installation command

The `Install` command will be called with `install` from the command line, and
executes 4 sub-tasks to finish the installation process:

* create the installation directory
* download composer via `wget`
* generate the `composer.json` according to the dependencies specified in the
DependencyContainer
* run the composer traditional installation (`php composer.phar install`)

This command takes a `DependencyContainer` argument in the constructor
to extract the dependencies needed to be installed:

``` php Command/Install.php
<?php

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Process\Process;

class Install extends Command
{
    protected $installDir;
    protected $failingProcess;
    protected $dependenciesContainer;
    
    public function __construct(DependencyContainer $dependenciesContainer)
    {
        parent::__construct();
        
        $this->dependenciesContainer = $dependenciesContainer;
    }
    
    protected function execute(InputInterface $input, OutputInterface $output)
    {
        if ($this->createInstallationDirectory($output)
         && $this->downloadComposer($output)
         && $this->generateJson($output)
         && $this->install($output)) {
            $output->writeln('<info>MISSION ACCOMPLISHED</info>');
        } else {
            $output->writeln('<error>Nasty error happened :\'-(</error>');
            
            if ($this->failingProcess instanceOf Process) {
                $output->writeln('<error>%s</error>', $this->failingProcess->getErrorOutput());   
            }
        }
    }
    
    protected function configure()
    {
        $this
            ->setName('install')
        ;
    }
}
```

as you see we execute this 4 tasks and, if an error happens, we output an error,
otherwise a confirmation message tells the user that everything went fine.

If a failure happens, we get the error message thanks to the `Process` method `getErrorOutput()`.

Let's see how the tasks are implemented in this class: first of all, we need a `createInstallationDirectory()`
method that launches a new `mkdir` process and returns a boolean value, indicating the
successfulness of the process; before returning false, the class' internal attribute
`$failingProcess` is updated:

``` php
<?php
...

protected function createInstallationDirectory(OutputInterface $output)
{
    $dialog             = $this->getHelperSet()->get('dialog');
    $this->installDir   = $dialog->ask($output, '<question>Please specify a non-existing directory to start the installation</question>');
    
    if (!is_dir($this->installDir)) {
        $mkdir = new Process(sprintf('mkdir -p %s', $this->installDir));
        $mkdir->run();
        
        if ($mkdir->isSuccessful()) {
            $output->writeln(sprintf('<info>Directory %s succesfully  created</info>', $this->installDir));
            
            return true;
        }
    }
    
    $this->failingProcess = $mkdir;
    return false;
}
```

As you see, the user will be asked to provide an `$installDir` in which we are going
to execute the whole process.

Now we need to create the `downloadComposer()` method, which uses `wget` to put `composer.phar`
in the installation directory:

``` php
<?php
...

protected function downloadComposer(OutputInterface $output)
{
    $wget = new Process(sprintf('wget getcomposer.org/composer.phar -O %s/composer.phar', $this->installDir, $this->installDir));
    $wget->run();

    if ($wget->isSuccessful()) {
        $output->writeln('<info>Downloaded composer in the installation directory</info>');

        return true;
    }
    
    $this->failingProcess = $wget;
    return false;
}
```

Then we generate a `composer.json` in the installation directory:

``` php
<?php
...

protected function generateJson(OutputInterface $output)
{
    $skeleton       = file_get_contents(__DIR__ . "/../composer.s");
    $dependencies   = implode(',', $this->dependenciesContainer->getDependencies());
    $skeleton       = str_replace('PLACEHOLDER', $dependencies, $skeleton);
    
    if (file_put_contents($this->installDir . "/composer.json", $skeleton)) {
        $output->writeln('<info>composer.json has been generated</info>');
        
        return true;
    }
    
    return false;
}
```

Note that you will need a template file to do so:

``` bash composer.s
{
    "require": {
        PLACEHOLDER
    }
}
```

The last step consists in launching a new process which runs the
usual composer's installation process on the installation directory:

``` php
<?php
...

protected function install(OutputInterface $output)
{
    $install = new Process(sprintf('cd %s && php composer.phar install', $this->installDir));
    $install->run();

    if ($install->isSuccessful()) {
        $output->writeln('<info>Packages succesfully installed</info>');

        return true;
    }
    
    $this->failingProcess = $install;
    return false;
}
```

This is the console output for generating a new project which depends on
`symfony/yaml` and `symfony/dom-crawler`:

{% img center /images/shell.png %}

The auto-generated `composer.json` will look like:

``` bash
{
    "require": {
        "symfony/yaml": "master","symfony/dom-crawler": "master"
    }
}
```

## Conclusion

As said, this implementation is pretty naive and can definitely be improved:
but with a couple classes and basic logic you are able to write a powerful
tool that doesn't require a web frontend and runs directly from the command line
with a pure implementation in PHP, thanks to the Symfony2 components.

{% footnotes %}
  {% fn The Process component will be used to execute shell commands directly from PHP %}
	{% fn Tip: if you want, you can add the code to show the user another dialog to indicate the dependency version, and use master as a fallback %}
{% endfootnotes %}
