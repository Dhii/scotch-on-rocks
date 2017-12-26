## What is this and why should I use it?
There are many tools out there that make our lives as developers easier. However, it is a pain to make them
work together. This project aims to provide a starter setup to allow faster creation of WordPress environments,
like many other projects do. But it also aims to make those environments version controlled, easily deployable,
and simple to develop locally. Indeed, in the author's opinion, these 3 things are essential to the development
of any web application.

And so, the author has picked the most contemporary and proven technologies used for web development,
and specifically for WordPress development, in order to fulfill the 3 essential requirements. This is why
this starter pack allows one-click creation of a local development environment, one-click deployments, easy
cloud VPS provisioning, and a version-controlled codebase with declarative dependency management. Everything
in this starter aims to fulfill the requirements for running and developing WordPress websites. However,
this configuration may be forked in the future to adapt to another platform.

The technologies and tools used here include:

- [WordPress][] because... that's what I work with.
- [Bedrock][] for version-controlled WordPress.
- [Git][] for version control.
- [Composer][] for declarative dependency management.
- [Scotchbox][] for local development.
- [Vagrant][] for configuration-based virtualization.
- [Capistrano][] for one-click deployment
- [cloud-init][] for portable, re-usable cloud VPS configuration.
- [PHP 7][] for fast running and modern development.
- [MariaDB][] for fast and modern data storage and retrieval.

## Requirements
Your host environment - the one you will be developing on - is required to have these tools installed:

- [Git][].
- [Vagrant][].
- An [SSH][] client.
- [Capistrano][].

Capistrano will be automatically installed inside the dev VM, so it's possible to deploy from it, provided that
you have access to the SSH key that is used for deployment inside the VM.

For Windows hosts, it is recommended to use [Git BASH][] , as it allows running Vagrant, comes with an SSH client, and
is installed together with Git.

## Installation Steps

### 1. Initialize the project

#### 1. **Clone the project**

```bash
git clone --depth=1 https://github.com/Dhii/scotch-on-rocks.git my-project
cd my-project
```

#### 2. Erase previous history
Just delete the `.git` folder, then initialize the repository:

```bash
rm -rf .git
git init
```

#### 3. Commit everything

```
git add .
git commit
```

#### 4. Create a remote repo and point to it

For example, you can create an empty repo on [GitHub][]. Then, a command to point
your local repo to the new remote could look like this:

```bash
git remote add origin https://github.com/my-user/my-project.git
```

### 2. Configure the package
You will probably want to update the following:

- [Project name][local\composer-package-name].
- [Project description][local\composer-package-description].
- [Author info][local\composer-author-info].

Maybe also:
- [Project tags][local\composer-keywords].
- [Package license][local\composer-package-license].
- Set [minimum stability][composer\config-minimum-stability] to `dev`.

### 3. Set up local environment
The dependencies should not be installed yet at this point, and if they are - chances are that they
do not match the target environment. Both the local and the remote versions of PHP should match.
The current local version is PHP 7.0.

1. Run [`vagrant up`][vagrant\command-up] to create the virtual environment.
2. The [`composer update`][composer\command-update] command was run as part of the provisioning process.
Commit the changes in the [`composer.lock`][local\composer.lock] file to record the new packages.

### 4. Set up deployment

1. Set the [repo URL][local\repo-url] to the URL of the repo created above.
2. Generate and set the [authorized keys][local\deploy-authorized-keys] to the **public** key.
3. Set the [path][local\capistrano-ssh-key-path] to the **private** key.
4. Set the [target hostname][local\hostname].
5. Push your changes. This is necessary for Capistrano.
6. Configure the hosting.
    - For DigitalOcean, create a droplet with [this user data][local\do-provision.yml]. You may want to replace
    the values of `mysqlPassword`, `wordpressDatabase`, `wordpressUser`, `wordpressPassword` with actual credentials.
    However, it is not advisable to commit changes to this file for security reasons.
    - Watch out when using [special shell characters][shell\special-chars]: these values will be parts of
    shell commands, and therefore must be [escaped][shell\escaping-chars].
7. Run `bundle install` as per [bedrock-capistrano requirements][roots\bedrock-capistrano-requirements].
8. Create an env config on the target server at `/srv/www/html/shared/.env`.
    - You can use the existing [`.env`][local\.env] file as template. However, it is not advisable to commit
    changes to this file for security reasons.
    - You will need to SSH into the target server for this. It should be possible to use the `deploy` user
    that is created as part of provisioning, with one of the keys from step 4.2.

### 5. Deploy
1. Before the first deployment, run `bundle exec cap production deploy:check`.
2. Then, deploy with `bundle exec cap production deploy`


## Remote Setup

### DigitalOcean
[DigitalOcean][] allows the usage of a provisioning system called [cloud-init][]. This
repository includes configuration for that system - a cloud-config - in [`do-provision.yml`][local\do-provision.yml].
While the format of configuration is standard for anything running cloud-init, different systems need to be
configured differently. This file contains the YAML configuration specifically for use with DigitalOcean. While
the same configuration may allow provisioning of systems with other VPS providers, it is not guaranteed to work
with anything other than DigitalOcean.

When using the [DigitalOcean API][digitalocean\api], one may want to retrieve the contents of that file programmatically.
However, when using the web UI - the online control panel - it may be necessary to copy-paste the contents into the
[userdata][digitalocean\userdata] field.


## Local Setup
The [`Vagrantfile`][local\Vagrantfile] is based on [ScotchBox][] 3, and will set up a local environment.
However, the docroot of Bedrock is different to the default docroot of Apache, which
is used by ScotchBox. Therefore, the `Vagrantfile` has been modified to run a provisioning
script. This script changes the default web-server docroot and the docroot of the example
virtualhost `scotchbox.local` to the one used by Bedrock.

It is unadvisable to commit the `.env` file, because it usually contains sensitive data,
such as the encryption keys and database access credentials used on the site. However,
this file is included here, and contains the credentials for working with the local
[ScotchBox][] installation. **DO NOT COMMIT TO ACTUAL PROJECT**.

## Deployment
This project uses [bedrock-capistrano][roots\bedrock-capistrano] - a [Capistrano][] configuration that allows
structured and consistent deployment of Bedrock-powered WordPress to remote environments. To stick to the
default setup, the remote environment is required to have a user with name `deploy` - the commands
run by Capistrano in the target environment will be run under that username. The
[DigitalOcean cloud-config][local\do-provision.yml] tells the environment to set up that user for SSH access. However,
the authorized key will need to be added first. So, before creation of the remote environment, [generate an
SSH key pair][digitalocean\set-up-ssh-keys] (if you haven't already), and add the **public** key to the
[list of authorized keys][local\deploy-authorized-keys]; be sure to remove the example key. Then, point
Capistrano to your **private** key by updating the [SSH key path][local\capistrano-ssh-key-path]. While in the
Capistrano environment config, also update the [hostname of your server][local\hostname].

Capistrano does not upload local files to the target server, but instead uses [Git][] to clone the
remote repository of your project. The [URL of the Git repository][local\repo-url] is normally the same
for all your environments, and therefore are located in [`config/deploy.rb`][local\config/deploy.rb]. 

## WordPress
The WordPress config for the target host must be in the [`.env`][local\.env] file. The file in this repo
contains configuration that matches the local virtual environment created by ScotchBox. To configure it for the target
server, it needs to be updated to match that server's environment, and uploaded manually to the `shared` folder of
your application, which by default would be at `/srv/www/html/shared`.



[Bedrock]: https://roots.io/bedrock/
[ScotchBox]: https://box.scotch.io/
[cloud-init]: https://cloud-init.io/
[DigitalOcean]: https://www.digitalocean.com
[Capistrano]: http://capistranorb.com/
[Git]: https://git-scm.com/
[Git BASH]: http://gitforwindows.org/
[GitHub]: https://github.com/
[Composer]: https://getcomposer.org/
[PHP 7]: http://php.net/manual/en/migration70.new-features.php
[WordPress]: https://wordpress.org/
[MariaDB]: https://mariadb.org/about/
[Vagrant]: https://www.vagrantup.com/
[SSH]: https://en.wikipedia.org/wiki/Secure_Shell

[local\deploy-authorized-keys]: do-provision.yml#L9
[local\capistrano-ssh-key-path]: config/deploy/production.rb#L19
[local\hostname]: config/deploy/production.rb#L19
[local\repo-url]: config/deploy.rb#L2
[local\do-provision.yml]: do-provision.yml
[local\config/deploy.rb]: config/deploy.rb
[local\.env]: .env
[local\Vagrantfile]: Vagrantfile
[local\composer-package-name]: composer.json#L2
[local\composer-package-license]: composer.json#L4
[local\composer-package-description]: composer.json#L5
[local\composer-author-info]: composer.json#L7
[local\composer-keywords]: composer.json#L13
[local\composer.lock]: composer.lock
[digitalocean\userdata]: https://www.digitalocean.com/community/tutorials/an-introduction-to-droplet-metadata
[digitalocean\api]: https://developers.digitalocean.com/
[digitalocean\set-up-ssh-keys]: https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2
[roots\bedrock-capistrano]: https://github.com/roots/bedrock-capistrano
[roots\bedrock-capistrano-requirements]: https://github.com/roots/bedrock-capistrano#requirements
[shell\special-chars]: http://tldp.org/LDP/abs/html/special-chars.html
[shell\escaping-chars]: http://tldp.org/LDP/abs/html/escapingsection.html#ESCP
[composer\config-minimum-stability]: https://getcomposer.org/doc/04-schema.md#minimum-stability
[composer\command-update]: https://getcomposer.org/doc/03-cli.md#update
[vagrant\command-up]: https://www.vagrantup.com/docs/cli/up.html
[vagrant\command-ssh]: https://www.vagrantup.com/docs/cli/ssh.html
