Getting Chef Solo Working With the Database Cookbook and Vagrant
================================================================

This is going to be one big jargon laden blob if you're not trying to do
exactly what I was trying to do this week, but hopefully it turns up in
a search for the next person.

I'm setting up a new development environment using Vagrant_ and I'm
using Chef_ Solo to provision the Ubuntu_ (12.4 Precise Penguin)
guest.  I wanted MySQL_ server running and wanted to use the `database
cookbook`_ from Opscode_ to pre-create a database.

My run list looked like:

.. code:: ruby

    recipe[mysql::server], recipe[webapp]

Where the webapp recipe's metadata.rb included:

.. code:: ruby

    depends "database"

and the default recipe led off with:

.. code:: ruby

    mysql_database 'master' do
      connection my_connection
      action :create
    end

Which would blow up at execution time with the message "missing gem 'mysql'",
which was really frustrating because the gem was already installed in the
previous mysql::server recipe.

I learned about chef_gem_ as compared to gem_package from the chef docs, and
found another page the showed how to `run actions at compile time`_ instead of
during chef processing, but only when I did both like this:

.. code:: ruby

    %w{mysql-client libmysqlclient-dev make}.each do |pack|
      package pack do
        action :nothing
      end.run_action(:install)
    end
    g = chef_gem "mysql" do
          action :nothing
    end
    g.run_action(:install)

was I able to get things working.  Notice that I had to install the OS packages
for mysql, the mysql development headers, and the venerable make because I could
early install the mysql ruby gem into chef's gem path -- which with Vagrant's
chef solo provisioner is entirely separate from any system gems.

.. _Vagrant: http://vagrantup.com/
.. _Chef: http://www.opscode.com/chef/
.. _Ubuntu: http://www.ubuntu.com/
.. _MySQL: http://www.mysql.com/
.. _database cookbook: http://community.opscode.com/cookbooks/database
.. _Opscode: http://www.opscode.com/
.. _chef_gem: http://wiki.opscode.com/display/chef/Resources#Resources-Differencesbetweenchefgemandgempackageresources
.. _run actions at compile time: http://wiki.opscode.com/display/chef/Evaluate+and+Run+Resources+at+Compile+Time

.. raw:: html

    <script type="text/javascript" src="https://ry4an.org/unblog/static/syntaxhighlighter/shCore.js"></script>
    <script type="text/javascript" src="https://ry4an.org/unblog/static/syntaxhighlighter/shBrushRuby.js"></script>
    <link type="text/css" rel="stylesheet" href="https://ry4an.org/unblog/static/syntaxhighlighter/shCoreDefault.css"/>
    <script type="text/javascript">SyntaxHighlighter.defaults.toolbar=false; SyntaxHighlighter.all();</script>

.. tags: ideas-built
