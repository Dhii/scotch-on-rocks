### Local Setup
The `Vagrantfile` is based on [ScotchBox][] 3, and will set up a local environment.
However, the docroot of Bedrock is different to the default docroot of Apache, which
is used by ScotchBox. Therefore, the `Vagrantfile` has been modified to run a provisioning
script. This script changes the default web-server docroot and the docroot of the example
virtualhost `scotchbox.local` to the one used by Bedrock.

It is unadvisable to commit the `.env` file, because it usually contains sensitive data,
such as the encryption keys and database access credentials used on the site. However,
this file is included here, and contains the credentials for working with the local
[ScotchBox][] installation. **DO NOT COMMIT TO ACTUAL PROJECT**.


[ScotchBox]: https://box.scotch.io/
