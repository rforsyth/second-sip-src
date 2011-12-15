# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# require 'spec_helper'
# require 'authlogic/test_case'
# include Authlogic::TestCase
# 
# activate_authlogic

# create administrator user
taster = Taster.new
taster.signup!(:taster => {:username => 'Admin',
                 :email => 'techsupport@secondsip.com', :greeting => 'Hello!',
                 :real_name => 'Tech Support'})
taster.activate!(:taster => {:password => 'TechRefug33',
                   :password_confirmation => 'TechRefug33'})
taster.roles_mask = 1
taster.save


