# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Adding default Admin user
user = User.create(email:'admin@changeme.com', role: 'admin')
user.password = 'testme'
user.password_confirmation = 'testme'
user.save

# Adding default permissions
manage_users = Permission.create(rule: 'ManageUsers', status: true)
manage_clients = Permission.create(rule: 'ManageClients', status: true)
manage_activities = Permission.create(rule: 'ManageActivities', status: true)
manage_interventions = Permission.create(rule: 'ManageInterventions', status: true)
create_interventions = Permission.create(rule: 'CreateInterventions', status: true)
edit_interventions = Permission.create(rule: 'EditInterventions', status: true)
delete_interventions = Permission.create(rule: 'DeleteInterventions', status: true)

