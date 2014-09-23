# efg

This is the master wrapper cookbook for the alphagov EFG cookbook.  It has the responsibility for:

- provisioning an application server for running the core Rails application
- provisioning a database server for the same
- getting a machine into a state where it can be a capistrano deployment target
- placing the machine into monitoring
- placing the machine into backups
- centralising logs
- providing core functionality common to all systems (users, handy tools etc)

## Usage

This cookbook provides recipes for each of the responsibilities described above:

- efg::appserver
- efg::database
- efg::deployable
- efg::monitoring
- efg::backup
- efg::logging
- efg::base

The default recipe includes all of these recipes, suitable for deloying a single machine.

Databases and users are created using details provided in a databag called `databases`:

```
{"id": "databases",
   "production": {
    "dbname": "efg",
    "user": "efg",
    "password": "efg"       		    
  }      		     
}
```

## Testing

This cookbook uses ChefSpec and KitchenCI for testing.  The tests are broken out by the above responsibilites, and can be tested in isolation by specifiying the componnent, either as a suite name or by file.  Examples include:

To run ChefSpec database tests:

    rspec -fd --color spec/database_spec.rb

To run ServerSpec/KitchenCi database tests:

    kitchen test database

