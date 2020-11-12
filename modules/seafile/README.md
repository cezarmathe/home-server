# home-server/seafile

This module will deploy a Seafile instance.

**NOTE**: when first deploying Seafile, you will have to disable the separated volumes of the
Seafile container and use only the `seafile_data` volume. After Seafile sucessfully bootstraps,
you can move your files to the desired separate locations and reenable those volumes.
