---
published: false
layout: post
title: "Create a Composer command line installer with the Symfony2 CLI"
date: 2012-02-21 10:51
comments: true
categories: [Symfony2, PHP, CLI]
---

{% render_partial series/symfony-components.markdown %}

Today we are going to see the power of Symfony2's Console component,
which lets us build powerful interactive command line applications
in pure PHP.
<!-- more -->

``` bash
{
    "require": {
        "php": ">=5.3.2",
        "symfony/console": "2.0.10",
        "symfony/process": "2.0.10"
    }
}
```

sessio_start e richiesto?
``` php
<?php

require 'vendor/.composer/autoload.php';
require 'Command/DependencyContainer.php';
require 'Command/Install.php';

use Symfony\Component\Console\Shell;
use Symfony\Component\Console\Application;

session_start();

$application            = new Application('Installer', '1.0.0-alpha');
$dependencyContainer    = new DependencyContainer();
$application->add($dependencyContainer);
$application->add(new Install($dependencyContainer));
$shell = new Shell($application);

$shell->run();
```

```
{
    "require": {
        PLACEHOLDER
    }
}
```

``` php
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
}
```

``` php
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
