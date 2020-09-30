# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


  Role.create([{ name: 'Developer' }, { name: 'Manager' }, { name: 'Admin' }])


  Project.create([{ name: 'Mera' }, { name: 'Infi' }, { name: 'Internal' }])

	dev = User.create(name: 'Sai Dev', password: '1234', email: "s@s.com")
	
	manager = User.create(name: 'Sai Manager', password: '1234', email: "m@m.com")
	
	admin = User.create(name: 'Sai Admin', password: '1234', email: "a@a.com")
	

	dev.roles << Role.first
	manager.roles << Role.first(2).last
	admin.roles << Role.last
