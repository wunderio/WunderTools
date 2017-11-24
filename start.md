# Quick start quide

## To start a new project using WunderTools follow these simple steps:  

### 1. Clone the repository and cd into it

```bash
git clone git@github.com:wunderio/WunderTools.git YourProject
cd YourProject
```

  Hint: You can remove the .git folder if you want clean history for your project.
  In that case you need to also initialize a new git repository:
  
```bash
rm -r .git
git init .
git add -a
git commit -m 'Initialized a new project with WunderTools.'
```  

### 2a) Add your project repository as remote

```bash
git remote add YourRemote git@github.com:yourname/YourProject.git
```  

### 2b) Add the wundertools files to an existing remote repository

Alternatively, when the project repository is hosted outside of our organization's github account, you can simply copy the files from the wundertools repository after cloning it and paste them into your project repository that you cloned from it's remote origin.

### 3. Configure your project:

For a default setup, you have now have to at least customize:

 - project name (e.g. 'intra'; may contain [a-zA-Z0..9-_])
 - host name (e.g. 'intra.dev')

To set those, edit the following configuration files:

  - **conf/project.yml**
    - `project` > `name` - set to your project name (*)
  - **conf/variables.yml**
    - `project_name` - set to your project name
  - **conf/vagrant_local.yml**
    - `name` - set to your project name
    - `hostname` - set to your main hostname
    - `aliases` - set to any number of alternate hostname aliases (one line, space separated)
    - _optionally_ you can set a fixed IP address at `ip
  - **conf/vagrant.yml**
    - `vars` > `domain_name` - set to your main hostname
    - _optionally_ activate/uncomment any services you need in addition to the default, e.g.
	  to get an elasticsearch server provisioned in the vm,
      uncomment the line starting with `# - { role: elasticsearch`.
    - _optionally_ add any tasks like cron jobs to the `tasks` section.

### 4. Launch your new environment

```bash
vagrant up
```
This will take some minutes, but stay tuned, since some user input will be necessary, such as:

- ```Build.sh version has been updated. [...]
I have updated everything ([y]es / [n]o / show [c]hangelog)?``` 
**y**
- `Allow vagrant to check for plugin depedencies?` 
**y**
- `Password:`
**[YOUR HOST SYSTEM'S USER PASSWORD]**

### 5. Build your application

On your host system run 

```bash
vagrant ssh
```

Now you're inside the guest vm created by vagrant in the last step.
Go to the app's directory …

```bash
cd /vagrant/drupal
```

… and there run

```bash
./build.sh create
```

The build.sh script will take a few minutes to run and will also do a _composer install_ for you implicitly.

Stay tuned during the build process, as you'll have to answer some questions:

* `Type yes to verify you want to create a new installation`
**yes**
* `You are about to DROP all tables in your 'drupal' database. Do you want to continue? (y/n):`
**y**

### 6. Verify the application is running

After that, your application should be served by the vm, and you should be able in your host system to **point your browser to the host name** you had set in step 3, e.g. 'intra.dev' and see the application being served.

Your can now `exit` out of your vm.

If you experience a problem, have a look at the "Common Problems" section at the end of this document.

### 7. Commit the created/changed files

The build process creates some files, a symlink and exports the Drupal configuration. **Commit those changes to git** and push to your remote origin.

Also consider to do fix permissions on Drupal's sites/default on your host system so that you won't run into permission problems when switching branches with different versions of e.g. settings.php. You can do this in your project root directory with:

```bash
chmod 755 drupal/web/sites/default
```



## C – Common Problems

#### Host name serves no or wrong content

If your browser either can't find or return anything for the host name you set, or serves something wrong (like the default stand-in content by any web server running on your host system), then check the last lines of your `/etc/hosts`:

* Has vagrant amended some lines there with for host name you set?
* Is the host name associated to the correct IP address of the vm? (Hint: it should _not_ be -127.0.0.1- !)?

If the lines are missing or wrong …

* ammend them manually.
* check if you have the vagrant-hostmanager plugin installed on your host system, via executing the `vagrant plugin list` on your host system's shell.



 
