require 'rexml/document'
require 'cgi'
require 'htmlentities'
require 'data/enums'
require 'authlogic/test_case'
include Authlogic::TestCase
activate_authlogic

def parse_lookup_type(lookup_type_name)
  Enums::LookupType.collection.each_pair do |name, type|
    return type if name == lookup_type_name
  end
  nil
end

def parse_resource_type(resource_type_name)
  Enums::ResourceType.collection.each_pair do |name, type|
    return type if name == resource_type_name
  end
  nil
end

def build_lookup(xml_lookup, taster, lookup_type, entity_type, parent_lookup)
  
  coder = HTMLEntities.new
  lookup_name = coder.decode(xml_lookup.attributes["name"])
  lookup = ReferenceLookup.find_by_canonical_name(lookup_name.canonicalize)
  
  puts lookup.to_s
  if !lookup.present?

    lookup = ReferenceLookup.new
    lookup.name = lookup_name
    full_name = xml_lookup.attributes["full_name"]
    lookup.full_name = coder.decode(full_name) if full_name.present?
    lookup.lookup_type = lookup_type
    lookup.entity_type = entity_type
    lookup.creator = lookup.updater = taster
    puts 'creating lookup: ' + lookup.name
    lookup.save
  
    xml_lookup.elements.each("reference") do |xml_resource|
      resource = Resource.new
      resource.reference_lookup = lookup
      resource.creator = resource.updater = taster
      resource.url = xml_resource.attributes["url"]
      resource.resource_type = parse_resource_type(xml_resource.attributes["type"])
      resource.body = xml_resource.text
      resource.title = lookup.name
      if resource.url.present? || resource.body.present?
        puts 'creating resource:' + resource.url
        resource.save
      end
    end
  else
    puts "Lookup with name: #{lookup_name} already exists. skipping."
  end
  
  xml_lookup.elements.each("children") do |children|
    children.elements.each("lookup") do |child_xml_lookup|
      build_lookup(child_xml_lookup, taster, lookup_type, entity_type, lookup)
    end
  end
  
end

def read_lookups(file)
  xmldoc = REXML::Document.new file
  lookups = REXML::XPath.first( xmldoc, "//lookups" )
  return lookups
end

def load_lookups(filename)
  file = File.open("#{Rails.root}/db/reference_data/#{filename}", 'r')
  lookups = read_lookups(file)
  entity_type = lookups.attributes["entity_type"]
  lookup_type = parse_lookup_type(lookups.attributes["field_name"])
  admin = Taster.find_by_username('Admin')
  
  lookups.elements.each("lookup") do |xml_lookup|
    build_lookup(xml_lookup, admin, lookup_type, entity_type, nil)
  end
  file.close
end

namespace :db do
  task :load_reference_varietals => :environment do
    load_lookups('wine_varietals.xml')
  end
  
  task :load_reference_wine_regions => :environment do
    load_lookups('wine_regions.xml')
  end
  
  task :load_reference_beer_styles => :environment do
    load_lookups('beer_styles.xml')
  end
end

