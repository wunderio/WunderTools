# FAQ

WunderTools moves fast and is used in many different projects, so issues emerge. Here we collect the most common pitfalls and the solutions to them.

### Frequently Asked Questions ###


#### Varnish repo is outdated ####

Symptom: provision fails
Old official repo.varnish-cache.org repo is deprecated. This might lead to existing environments provisioning to fail even as we have already fixed the issue in the wundermachina. The fix is to ensure the target environment doesn't have reference to the old repo anymore by either running `sudo yum-config-manager --disable varnish-4.1` or manually removing the `/etc/yum.repos.d/varnish.repo` and reprovisioning varnish again (`./provision.sh -t varnish [env]`)

#### key.wunder.io issues ####

Symptom: `curl: (6) Could not resolve host: key.example.tld; Name or service not known"], "stdout":`

Solution: Due to changes in defaults for key.wunder.io ansible role all projects need to add `base_pubkeys_enable: False` to their `conf/vagrant.yml` variables.

#### Drupal console and/or codeception issues ####

Export the db credentials:

`export DB_USER_DRUPAL=drupal`
`export DB_PASS_DRUPAL=password`

#### More info out of the standard "power plug" page ####

While "our best people are on the case", if you want to have more error information you can:  append `?error-debug=randomvar` to the end of an url to see the original error message.
