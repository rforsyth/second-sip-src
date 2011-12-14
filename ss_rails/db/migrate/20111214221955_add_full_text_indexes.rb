class AddFullTextIndexes < ActiveRecord::Migration
  def self.up
    
    execute(<<-'eosql'.strip)
      CREATE index tasters_fts_idx
      ON tasters
      USING gin(
        (setweight(to_tsvector('english', coalesce("tasters"."username", '')), 'A') || ' ' ||
         setweight(to_tsvector('english', coalesce("tasters"."email", '')), 'A') || ' ' ||
         setweight(to_tsvector('english', coalesce("tasters"."real_name", '')), 'B') || ' ' ||
         setweight(to_tsvector('english', coalesce("tasters"."greeting", '')), 'C'))
      )
    eosql
    
    execute(<<-'eosql'.strip)
      CREATE index notes_fts_idx
      ON notes
      USING gin(
        (setweight(to_tsvector('english', coalesce("notes"."producer_name", '')), 'A') || ' ' ||
         setweight(to_tsvector('english', coalesce("notes"."product_name", '')), 'A') || ' ' ||
         setweight(to_tsvector('english', coalesce("notes"."searchable_metadata", '')), 'B') || ' ' ||
         setweight(to_tsvector('english', coalesce("notes"."description_overall", '')), 'C') || ' ' ||
         setweight(to_tsvector('english', coalesce("notes"."description_appearance", '')), 'D') || ' ' ||
         setweight(to_tsvector('english', coalesce("notes"."description_aroma", '')), 'D') || ' ' ||
         setweight(to_tsvector('english', coalesce("notes"."description_flavor", '')), 'D') || ' ' ||
         setweight(to_tsvector('english', coalesce("notes"."description_mouthfeel",'')), 'D'))
      )
    eosql
    
    execute(<<-'eosql'.strip)
      CREATE index products_fts_idx
      ON products
      USING gin(
        (setweight(to_tsvector('english', coalesce("products"."name", '')), 'A') || ' ' ||
         setweight(to_tsvector('english', coalesce("products"."producer_name", '')), 'A') || ' ' ||
         setweight(to_tsvector('english', coalesce("products"."searchable_metadata", '')), 'B') || ' ' ||
         setweight(to_tsvector('english', coalesce("products"."description", '')), 'C'))
      )
    eosql
    
    execute(<<-'eosql'.strip)
      CREATE index reference_products_fts_idx
      ON reference_products
      USING gin(
        (setweight(to_tsvector('english', coalesce("reference_products"."name", '')), 'A') || ' ' ||
         setweight(to_tsvector('english', coalesce("reference_products"."reference_producer_name", '')), 'A') || ' ' ||
         setweight(to_tsvector('english', coalesce("reference_products"."searchable_metadata", '')), 'B') || ' ' ||
         setweight(to_tsvector('english', coalesce("reference_products"."description", '')), 'C'))
      )
    eosql
    
    execute(<<-'eosql'.strip)
      CREATE index producers_fts_idx
      ON producers
      USING gin(
        (setweight(to_tsvector('english', coalesce("producers"."name", '')), 'A') || ' ' ||
         setweight(to_tsvector('english', coalesce("producers"."searchable_metadata", '')), 'B') || ' ' ||
         setweight(to_tsvector('english', coalesce("producers"."description", '')), 'C'))
      )
    eosql
    
    execute(<<-'eosql'.strip)
      CREATE index reference_producers_fts_idx
      ON reference_producers
      USING gin(
        (setweight(to_tsvector('english', coalesce("reference_producers"."name", '')), 'A') || ' ' ||
         setweight(to_tsvector('english', coalesce("reference_producers"."searchable_metadata", '')), 'B') || ' ' ||
         setweight(to_tsvector('english', coalesce("reference_producers"."description", '')), 'C'))
      )
    eosql
    
  end

  def self.down
  end
end
