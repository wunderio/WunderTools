# Quick start quide

### To start a new project using WunderTools follow these simple steps:  
  

#### 1. Clone the repository and cd into it

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

#### 2. Add your project repository as remote
```bash
git remote add YourRemote git@github.com:yourname/YourProject.git
```  

#### 3. Configure your project:
  - Set project name etc. in conf/project.yml
  - Set hostname, ip etc. in conf/vagrant_local.yml
  - Configure your local environment in conf/vagrant.yml  
  

#### 4. Launch your new environment
```bash
vagrant up
```

